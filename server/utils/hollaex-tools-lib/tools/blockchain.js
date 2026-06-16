'use strict';

const { SERVER_PATH } = require('../constants');
const { getModel } = require('./database/model');
const dbQuery = require('./database/query');
const { client } = require('./database/redis');
const { sendEmail } = require(`${SERVER_PATH}/mail`);
const { MAILTYPE } = require(`${SERVER_PATH}/mail/strings`);
const { loggerWithdrawals } = require(`${SERVER_PATH}/config/logger`);
const {
	WITHDRAWAL_ADDRESS_NOT_ALLOWED,
	BLACKLISTED_ADDRESS_ALREADY_EXISTS,
	BLACKLISTED_ADDRESS_NOT_FOUND,
	BLACKLISTED_ADDRESS_REQUIRED
} = require(`${SERVER_PATH}/messages`);
const { Op } = require('sequelize');

const BLACKLIST_CACHE_KEY = 'blacklisted:addresses';
const BLACKLIST_CACHE_TTL = 3600; // seconds, safety-net so a missed invalidation self-heals
const ALERT_THROTTLE_TTL = 600; // seconds, dedupe operator alerts per (address, user)
const BLACKLIST_DEFAULT_LIMIT = 50;
const BLACKLIST_MAX_LIMIT = 100;
const BLACKLIST_ORDER_FIELDS = new Set([
	'id',
	'address',
	'network',
	'label',
	'reason',
	'created_by',
	'created_at',
	'updated_at'
]);

const EVM_ADDRESS_REGEX = /^0x[0-9a-fA-F]{40}$/;

// Networks whose addresses carry a memo/tag suffix ("address:tag"). Mirrors the
// selective ":" handling in wallet.js isValidAddress (only XLM/XRP). Must NOT be
// applied universally: formats like BCH CashAddr ("bitcoincash:q...") put the
// payload after the colon, so a blanket split would corrupt the address.
const TAG_NETWORKS = new Set(['xlm', 'stellar', 'xrp']);

// empty/whitespace network means "all networks"
const normalizeNetwork = (network) => {
	const n = (network || '').toString().trim().toLowerCase();
	return n.length > 0 ? n : null;
};

const parsePositiveInteger = (value, fallback) => {
	const parsed = Number.parseInt(value, 10);
	return Number.isFinite(parsed) && parsed > 0 ? parsed : fallback;
};

/**
 * Normalize an address for storage and comparison.
 * - trims whitespace
 * - for tag-based networks (XRP/XLM) strips the memo/tag suffix so the base
 *   address is matched regardless of tag; other networks keep the full address
 * - lowercases EVM-family addresses (ETH, BNB/BSC, MATIC/Polygon, ...) which are case-insensitive
 * Case-sensitive chains (BTC base58, TRON, ...) are preserved as-is.
 */
const normalizeAddress = (address = '', network = null) => {
	let addr = (address || '').toString().trim();
	// only drop the ":tag" / ":memo" for networks that actually use it
	if (TAG_NETWORKS.has(normalizeNetwork(network))) {
		addr = addr.split(':')[0];
	}
	if (EVM_ADDRESS_REGEX.test(addr)) {
		return addr.toLowerCase();
	}
	return addr;
};

// cache/lookup key for an (address, network) pair; null network -> global
const buildKey = (address, network) => `${address}|${network || ''}`;

const invalidateBlacklistCache = async () => {
	try {
		await client.delAsync(BLACKLIST_CACHE_KEY);
	} catch (err) {
		loggerWithdrawals.error('tools/blockchain/invalidateBlacklistCache', err.message);
	}
};

// Returns a Set of "address|network" keys (network "" means it applies to all
// networks). Cached in redis as the key array so the hot path is an O(1) lookup.
const getBlacklistSet = async () => {
	let cached;
	try {
		cached = await client.getAsync(BLACKLIST_CACHE_KEY);
	} catch (err) {
		loggerWithdrawals.error('tools/blockchain/getBlacklistSet/cache', err.message);
	}

	if (cached) {
		try {
			return new Set(JSON.parse(cached));
		} catch (err) {
			loggerWithdrawals.error('tools/blockchain/getBlacklistSet/parse', err.message);
		}
	}

	const rows = await getModel('blacklistedAddress').findAll({
		attributes: ['address', 'network'],
		raw: true
	});
	const keys = rows.map((row) => buildKey(row.address, row.network));

	try {
		await client.setexAsync(BLACKLIST_CACHE_KEY, BLACKLIST_CACHE_TTL, JSON.stringify(keys));
	} catch (err) {
		loggerWithdrawals.error('tools/blockchain/getBlacklistSet/setCache', err.message);
	}

	return new Set(keys);
};

/**
 * Returns true if the given address is blacklisted for the given network.
 * A blacklist entry with a null network blocks all networks; an entry with a
 * specific network only blocks that network.
 */
const isAddressBlacklisted = async (address, network = null) => {
	if (!address) {
		return false;
	}
	const normalizedAddress = normalizeAddress(address, network);
	if (!normalizedAddress) {
		return false;
	}
	const normalizedNetwork = normalizeNetwork(network);
	const set = await getBlacklistSet();
	// match an entry scoped to this network, or a global (all-networks) entry
	return (
		set.has(buildKey(normalizedAddress, normalizedNetwork)) ||
		set.has(buildKey(normalizedAddress, null))
	);
};

/**
 * Chokepoint guard: throws WITHDRAWAL_ADDRESS_NOT_ALLOWED if the destination is
 * blacklisted. On a blocked attempt it logs the event and sends a throttled
 * alert to the exchange operator. The block itself is never throttled.
 */
const enforceAddressNotBlacklisted = async (address, network = null, user = {}) => {
	if (!(await isAddressBlacklisted(address, network))) {
		return;
	}

	const userId = user && (user.id || user.network_id);
	const normalizedAddress = normalizeAddress(address, network);

	loggerWithdrawals.warn(
		'tools/blockchain/enforceAddressNotBlacklisted blocked',
		'user_id',
		userId,
		'address',
		normalizedAddress,
		'network',
		normalizeNetwork(network)
	);

	// throttle operator alert per (address, user) so retries don't spam the inbox
	try {
		const throttleKey = `blacklist-alert:${normalizedAddress}:${userId || 'unknown'}`;
		const alreadyAlerted = await client.getAsync(throttleKey);
		if (!alreadyAlerted) {
			await client.setexAsync(throttleKey, ALERT_THROTTLE_TTL, '1');
			sendEmail(
				MAILTYPE.ALERT,
				null,
				{
					type: 'Blacklisted withdrawal attempt',
					data: {
						user_id: userId,
						email: user && user.email,
						address: normalizedAddress,
						network: normalizeNetwork(network)
					}
				},
				{}
			);
		}
	} catch (err) {
		loggerWithdrawals.error('tools/blockchain/enforceAddressNotBlacklisted/alert', err.message);
	}

	throw new Error(WITHDRAWAL_ADDRESS_NOT_ALLOWED);
};

const createBlacklistedAddress = async (data = {}) => {
	const normalizedAddress = normalizeAddress(data.address, data.network);
	if (!normalizedAddress) {
		throw new Error(BLACKLISTED_ADDRESS_REQUIRED);
	}
	const normalizedNetwork = normalizeNetwork(data.network);

	const existing = await getModel('blacklistedAddress').findOne({
		where: {
			address: normalizedAddress,
			network: normalizedNetwork === null ? { [Op.is]: null } : normalizedNetwork
		}
	});
	if (existing) {
		throw new Error(BLACKLISTED_ADDRESS_ALREADY_EXISTS);
	}

	const created = await getModel('blacklistedAddress').create({
		address: normalizedAddress,
		network: normalizedNetwork,
		label: data.label || null,
		reason: data.reason || null,
		created_by: data.created_by || null
	});

	await invalidateBlacklistCache();
	return created;
};

const getBlacklistedAddresses = (opts = {}) => {
	const limit = Math.min(
		parsePositiveInteger(opts.limit, BLACKLIST_DEFAULT_LIMIT),
		BLACKLIST_MAX_LIMIT
	);
	const page = parsePositiveInteger(opts.page, 1);
	const offset = limit * (page - 1);
	const requestedOrderBy = (opts.order_by || 'created_at').toString();
	const orderBy = BLACKLIST_ORDER_FIELDS.has(requestedOrderBy)
		? requestedOrderBy
		: 'created_at';
	const order = (opts.order || 'desc').toString().toLowerCase() === 'asc'
		? 'asc'
		: 'desc';

	const query = {
		limit,
		offset,
		order: [[orderBy, order]],
		attributes: ['id', 'address', 'network', 'label', 'reason', 'created_by', 'created_at', 'updated_at']
	};

	if (opts.search) {
		const search = opts.search.toString().trim();
		if (search) {
			const addressSearches = new Set([search]);
			const normalizedSearch = normalizeAddress(search);
			if (normalizedSearch) {
				addressSearches.add(normalizedSearch);
			}
			if (search.includes(':')) {
				const tagBaseSearch = normalizeAddress(search.split(':')[0]);
				if (tagBaseSearch) {
					addressSearches.add(tagBaseSearch);
				}
			}
			query.where = {
				[Op.or]: [
					...Array.from(addressSearches).map((addressSearch) => ({
						address: { [Op.iLike]: `%${addressSearch}%` }
					})),
					{ network: { [Op.iLike]: `%${search.toLowerCase()}%` } },
					{ label: { [Op.iLike]: `%${search}%` } },
					{ reason: { [Op.iLike]: `%${search}%` } }
				]
			};
		}
	}

	return dbQuery.findAndCountAllWithRows('blacklistedAddress', query);
};

const deleteBlacklistedAddress = async (id) => {
	const entry = await getModel('blacklistedAddress').findOne({ where: { id } });
	if (!entry) {
		throw new Error(BLACKLISTED_ADDRESS_NOT_FOUND);
	}
	await entry.destroy();
	await invalidateBlacklistCache();
	return entry;
};

module.exports = {
	normalizeAddress,
	isAddressBlacklisted,
	enforceAddressNotBlacklisted,
	createBlacklistedAddress,
	getBlacklistedAddresses,
	deleteBlacklistedAddress,
	invalidateBlacklistCache
};
