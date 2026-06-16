'use strict';
const { debounce, each } = require('lodash');
const {
	CHAT_MESSAGE_CHANNEL,
	CHAT_MAX_MESSAGES,
	WEBSOCKET_CHANNEL,
	P2P_CHAT_MESSAGE_CHANNEL
} = require('../../constants');
const { storeData, restoreData } = require('./utils');
const { isUserBanned } = require('./ban');
const { safeJsonParse } = require('../../utils');
const moment = require('moment');
const { subscriber, publisher } = require('../../db/pubsub');
const { getChannels } = require('../channel');
const WebSocket = require('ws');

const MESSAGES_KEY = 'WS:MESSAGES';
let MESSAGES = [];

// Fields a client is allowed to set on a P2P chat message / status update.
// Everything else (identity + server-set fields) is applied AFTER this pick so
// the caller cannot overwrite who the event is from or inject trust markers
// (is_admin / is_system / verified / sender_role / ...). See H-2.
const P2P_MESSAGE_FIELDS = ['id', 'message', 'receiver_id', 'receiver_name', 'sender_name', 'transaction_id'];
const P2P_STATUS_FIELDS = ['id', 'title', 'receiver_id', 'transaction_id'];
const P2P_STATUS_VALUES = ['created', 'confirmed', 'cancelled', 'appeal'];

const pickFields = (obj, keys) => {
	const out = {};
	if (!obj || typeof obj !== 'object') return out;
	for (const key of keys) {
		if (obj[key] !== undefined) out[key] = obj[key];
	}
	return out;
};

// redis subscriber, get message and updates MESSAGES array
subscriber.subscribe(CHAT_MESSAGE_CHANNEL);
subscriber.subscribe(P2P_CHAT_MESSAGE_CHANNEL);

subscriber.on('message', (channel, data) => {
	if (channel === CHAT_MESSAGE_CHANNEL) {
		const parsed = safeJsonParse(data);
		if (!parsed || typeof parsed.type !== 'string') {
			return;
		}
		if (parsed.type === 'message') {
			MESSAGES.push(parsed.data);
		} else if (parsed.type === 'deleteMessage') {
			MESSAGES.splice(parsed.data, 1);
		}
	} else if (channel === P2P_CHAT_MESSAGE_CHANNEL) {
		const parsed = safeJsonParse(data);
		if (!parsed || typeof parsed.type !== 'string') {
			return;
		}
		if (parsed.type === 'message') {
			publishP2PChatMessage('addMessage', parsed.data);
		} else if (parsed.type === 'status') {
			publishP2PChatMessage('getStatus', parsed.data);
		}
	}
});

const getMessages = (limit = CHAT_MAX_MESSAGES) => {
	return MESSAGES.slice(-limit);
};

const sendInitialMessages = (ws) => {
	ws.send(JSON.stringify({
		topic: 'chat',
		action: 'init',
		data: getMessages()
	}));
};

const addMessage = (username, verification_level, userId, message) => {
	const timestamp = moment().unix();
	if (!isUserBanned(userId)) {
		const data = {
			id: `${timestamp}-${username}`,
			user_id: userId,
			username,
			verification_level,
			message,
			timestamp
		};
		publisher.publish(CHAT_MESSAGE_CHANNEL, JSON.stringify({ type: 'message', data }));
		publishChatMessage('addMessage', data);
		maintenanceMessageList();
	} else {
		throw new Error('User is banned');
	}
};

const addP2PMessage = (user_id, p2pData) => {
	const created_at = moment();
	const data = {
		...pickFields(p2pData, P2P_MESSAGE_FIELDS),
		// Server-set identity, applied after the whitelist so it cannot be spoofed.
		user_id,
		sender_id: user_id,
		type: 'message',
		created_at
	};
	publisher.publish(P2P_CHAT_MESSAGE_CHANNEL, JSON.stringify({ type: 'message', data }));
};

const getP2PStatus = (user_id, p2pData) => {
	const created_at = moment();
	const status = P2P_STATUS_VALUES.includes(p2pData && p2pData.status) ? p2pData.status : undefined;
	const data = {
		...pickFields(p2pData, P2P_STATUS_FIELDS),
		status,
		// Server-set identity, applied after the whitelist so it cannot be spoofed.
		user_id,
		sender_id: user_id,
		created_at
	};
	publisher.publish(P2P_CHAT_MESSAGE_CHANNEL, JSON.stringify({ type: 'status', data }));

};

const deleteMessage = (idToDelete) => {
	const indexOfMessage = MESSAGES.findIndex(({ id }) => id === idToDelete);
	if (indexOfMessage > -1) {
		publisher.publish(CHAT_MESSAGE_CHANNEL, JSON.stringify({ type: 'deleteMessage', data: indexOfMessage }));
		maintenanceMessageList();
		publishChatMessage('deleteMessage', idToDelete);
	}
};

const publishChatMessage = (event, data) => {
	each(getChannels()[WEBSOCKET_CHANNEL('chat')], (ws) => {
		if (ws.readyState === WebSocket.OPEN) {
			ws.send(JSON.stringify({
				topic: 'chat',
				action: event,
				data
			}));
		}
	});
};

const publishP2PChatMessage = (event, data) => {
	if (data.receiver_id) {
		each(getChannels()[WEBSOCKET_CHANNEL('p2pChat', data.receiver_id)], (ws) => {
			if (ws.readyState === WebSocket.OPEN) {
				ws.send(JSON.stringify({
					topic: `p2pChat`,
					action: event,
					data
				}));
			}
		});
	};
};

const maintenanceMessageList = debounce(() => {
	MESSAGES = getMessages();
	storeData(MESSAGES_KEY, MESSAGES);
}, 5000);

restoreData(MESSAGES_KEY).then((messages) => {
	MESSAGES = messages;
});

module.exports = {
	getMessages,
	addMessage,
	deleteMessage,
	publishChatMessage,
	sendInitialMessages,
	addP2PMessage,
	getP2PStatus
};
