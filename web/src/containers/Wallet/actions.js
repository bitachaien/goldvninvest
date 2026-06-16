import querystring from 'query-string';
import { requestAuthenticated } from 'utils';

export const fetchBalanceHistory = (values) => {
	const queryValues =
		values && Object.keys(values).length ? querystring.stringify(values) : '';
	return requestAuthenticated(`/user/balance-history?${queryValues}`);
};

export const fetchPlHistory = (values) => {
	const queryValues =
		values && Object.keys(values).length ? querystring.stringify(values) : '';
	return requestAuthenticated(`/user/balance-pl?${queryValues}`);
};

export const getAddressBookDetails = () => {
	return requestAuthenticated(`/user/addressbook`);
};

export const setUserLabelAndAddress = (values) => {
	const options = {
		method: 'POST',
		body: JSON.stringify(values),
	};
	return requestAuthenticated(`/user/addressbook`, options);
};

export const requestWhitelistAddress = (values) => {
	const options = {
		method: 'POST',
		body: JSON.stringify(values),
	};
	return requestAuthenticated(`/user/addressbook/whitelist`, options);
};

export const confirmWhitelistAddress = (token) => {
	const options = {
		method: 'POST',
		body: JSON.stringify({ token }),
	};
	return requestAuthenticated(`/user/addressbook/whitelist/confirm`, options);
};
