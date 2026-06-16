'use strict';

const { SERVER_PATH } = require('../constants');
const {
	EVENTS_CHANNEL,
	REQUEST_VERIFICATION_METHODS
} = require(`${SERVER_PATH}/constants`);
const { publisher } = require('./database/redis');
const { sendEmail } = require(`${SERVER_PATH}/mail`);
const { getKitConfig } = require('./common');
const { isSmsPluginActive } = require('./plugin');
const { logger } = require(`${SERVER_PATH}/config/logger`);
const { isEmail } = require('validator');
const {
	NO_ACTIVE_SMS_PLUGIN_ON_EXCHANGE,
	PROVIDE_VALID_EMAIL,
	USER_EMAIL_NOT_VERIFIED,
	USER_HAS_NO_PHONE,
	USER_PHONE_NOT_VERIFIED,
	VERIFICATION_EMAIL_REQUIRES_REAL_EMAIL
} = require(`${SERVER_PATH}/messages`);

const PHONE_SIGNUP_EMAIL_SUFFIX = '_sms';

const ACTIONS_SKIP_CONTACT_VERIFIED_CHECK = new Set([
	'signup',
	'reset_password',
	'confirm_email'
]);

const isPhoneSignupSyntheticUser = (user = {}) => {
	if (!user) {
		return false;
	}
	if (user.meta && user.meta.phone_signup === true) {
		return true;
	}
	if (!user.email || typeof user.email !== 'string') {
		return false;
	}
	return user.email.endsWith(PHONE_SIGNUP_EMAIL_SUFFIX);
};

const hasDeliverableEmail = (user) => {
	return !!(user?.email && isEmail(user.email) && !isPhoneSignupSyntheticUser(user));
};

const requiresVerifiedContact = (action_type) => {
	return !ACTIONS_SKIP_CONTACT_VERIFIED_CHECK.has(action_type);
};

const parseRequestVerificationMethod = (value) => {
	if (value == null || value === '') {
		return undefined;
	}
	const normalized = String(value).toLowerCase();
	if (normalized === 'sms') {
		return 'sms';
	}
	if (normalized === 'email') {
		return 'email';
	}
	throw new Error(
		`verification_method must be one of: ${REQUEST_VERIFICATION_METHODS.join(', ')}`
	);
};

const assertEmailVerificationEligible = (user, { requireVerified = false } = {}) => {
	if (!user?.email || !isEmail(user.email)) {
		throw new Error(PROVIDE_VALID_EMAIL);
	}
	if (isPhoneSignupSyntheticUser(user)) {
		throw new Error(VERIFICATION_EMAIL_REQUIRES_REAL_EMAIL);
	}
	if (requireVerified && !user.email_verified) {
		throw new Error(USER_EMAIL_NOT_VERIFIED);
	}
};

const assertSmsVerificationEligible = async (
	user,
	{ requireVerified = false } = {},
	deps = {}
) => {
	if (!user?.phone_number) {
		throw new Error(USER_HAS_NO_PHONE);
	}
	if (requireVerified && !user.phone_number_verified) {
		throw new Error(USER_PHONE_NOT_VERIFIED);
	}
	const _getKitConfig = deps.getKitConfig || getKitConfig;
	const _isSmsPluginActive = deps.isSmsPluginActive || isSmsPluginActive;

	if (!_getKitConfig()?.features?.sms_verification) {
		throw new Error('SMS verification feature is not enabled on this exchange');
	}
	const active = await _isSmsPluginActive();
	if (!active) {
		throw new Error(NO_ACTIVE_SMS_PLUGIN_ON_EXCHANGE);
	}
};

const resolveDeliveryChannels = async (user, {
	emailType,
	requestVerificationMethod,
	action_type,
	deps = {}
}) => {
	const request = parseRequestVerificationMethod(requestVerificationMethod);
	const requireVerified = requiresVerifiedContact(action_type);

	if (request === 'email') {
		assertEmailVerificationEligible(user, { requireVerified });
		if (!emailType) {
			throw new Error(PROVIDE_VALID_EMAIL);
		}
		return { sendEmail: true, publishSms: false, method: 'email' };
	}
	if (request === 'sms') {
		await assertSmsVerificationEligible(user, { requireVerified }, deps);
		return { sendEmail: false, publishSms: true, method: 'sms' };
	}

	// Default: email when a real address is available; SMS for synthetic phone-signup emails.
	if (emailType && hasDeliverableEmail(user)) {
		assertEmailVerificationEligible(user, { requireVerified });
		return { sendEmail: true, publishSms: false, method: 'email' };
	}
	await assertSmsVerificationEligible(user, { requireVerified }, deps);
	return { sendEmail: false, publishSms: true, method: 'sms' };
};

const sendVerificationCode = async (user, {
	action_type,
	verification_code,
	emailType,
	emailData = {},
	domain,
	requestVerificationMethod
}) => {
	if (!user) {
		throw new Error('sendVerificationCode: user is required');
	}
	if (!action_type) {
		throw new Error('sendVerificationCode: action_type is required');
	}
	if (!verification_code) {
		throw new Error('sendVerificationCode: verification_code is required');
	}

	const channels = await resolveDeliveryChannels(user, {
		emailType,
		requestVerificationMethod,
		action_type
	});

	if (channels.sendEmail) {
		try {
			sendEmail(emailType, user.email, emailData, user.settings, domain);
		} catch (err) {
			logger.error(
				'tools/verification/sendVerificationCode email dispatch failed',
				err.message
			);
		}
	}

	if (channels.publishSms) {
		try {
			publisher.publish(EVENTS_CHANNEL, JSON.stringify({
				type: 'user_verification',
				data: {
					user_id: user.id,
					verification_method: 'sms',
					action_type,
					verification_code,
					phone_number: user.phone_number
				}
			}));
		} catch (err) {
			logger.error(
				'tools/verification/sendVerificationCode publish failed',
				err.message
			);
		}
	}

	return { method: channels.method };
};

module.exports = {
	parseRequestVerificationMethod,
	assertEmailVerificationEligible,
	assertSmsVerificationEligible,
	sendVerificationCode
};
