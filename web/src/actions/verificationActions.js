import axios from 'axios';
import querystring from 'query-string';
import { PLUGIN_URL } from '../config/constants';

const VERIFICATION_ENDPOINTS = {
	VERIFY_SMS_CODE: `${PLUGIN_URL}/plugins/sms/verify`,
	VERIFY_BANK: `${PLUGIN_URL}/plugins/bank/user`,
	GET_USER: '/user',
	VERIFY_USER_PAYMENT: 'user/bank',
	SET_EMAIL: '/user/set-email',
	CONFIRM_SET_EMAIL: '/user/set-email/confirm',
};

export const getUserData = () => axios.get(VERIFICATION_ENDPOINTS.GET_USER);

export const requestSmsCode = (phoneNumber = '') => {
	const qs = querystring.stringify({ phone: phoneNumber });
	return axios.get(`${VERIFICATION_ENDPOINTS.VERIFY_SMS_CODE}?${qs}`);
};

export const verifySmsCode = ({ code = '', phone = '' }) => {
	const body = { code, phone };
	return axios.post(VERIFICATION_ENDPOINTS.VERIFY_SMS_CODE, body);
};

export const verifyBankData = (formProps) => {
	return axios.post(VERIFICATION_ENDPOINTS.VERIFY_BANK, formProps);
};

export const verifyUserPayment = (formProps) => {
	return axios.post(VERIFICATION_ENDPOINTS.VERIFY_USER_PAYMENT, formProps);
};

export const requestSetEmail = (email = '') => {
	return axios.post(VERIFICATION_ENDPOINTS.SET_EMAIL, { email });
};

export const confirmSetEmail = (code = '') => {
	return axios.post(VERIFICATION_ENDPOINTS.CONFIRM_SET_EMAIL, { code });
};
