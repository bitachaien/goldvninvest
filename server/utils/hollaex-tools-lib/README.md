
<!-- PROJECT LOGO -->
<br />
<p align="center">

  <h3 align="center">HollaEx Tools Library</h3>

  <p align="center">
    Tools Library for developing HollaEx Kit enabled Exchanges
    <br />
    <a href="https://github.com/github_username/repo_name"><strong>Explore the docs »</strong></a>
  </p>
</p>


<!-- GETTING STARTED -->
## Getting Started

### Prerequisites

This Tools Library will only work with the [HollaEx Kit](https://github.com/hollaex/hollaex-kit).

### Installation

1. Clone the repo
   ```sh
   git clone https://github.com/hollaex/hollaex-tools-lib.git
   ```
2. Install NPM packages
   ```sh
   npm install hollaex-tools-lib
   ```



<!-- USAGE EXAMPLES -->
## Usage

### Importing Library

```javascript
const tools = require('hollaex-tools-lib');
```

### Common Functions

- getUserByEmail(email, [rawData = true], [networkData = false])
- getUserByKitId(kit_id, [rawData = true], [networkData = false])
- getUserByNetworkId(network_id, [rawData = true], [networkData = false])
- getUserTier(user_id);
- createUser(email, password, [opts = { role: 'user', id: null }])
- getKitConfig()
- getKitSecrets()
- getKitCoins()
- getKitCoinsConfig()
- getKitPairs()
- getKitPairsConfig()
- createUserOrderByKitId()


### Full list of functions

<!-- TABLE OF CONTENTS -->
- [Common Functions](#common-functions)
- [User Functions](#user-functions)
- [Order Functions](#order-functions)
- [Wallet Functions](#wallet-functions)
- [Coin Functions](#coin-functions)
- [Pair Functions](#pair-functions)
- [Exchange Functions](#exchange-functions)
- [Plugin Functions](#plugin-functions)
- [Broker Functions](#broker-functions)
- [Stake Functions](#stake-functions)
- [P2P Functions](#p2p-functions)
- [Verification Functions](#verification-functions)
- [Security Functions](#security-functions)
- [Tier Functions](#tier-functions)
- [Database Functions](#database-functions)

#### Common functions

- `getKitVersion()`
  - Fetches the current kit version stored in the exchange status record.
  - Returns promise with the kit version number.
	```javascript
	tools.getKitVersion()
		.then((version) => {
			/*
				12
			*/
		});
	```

- `isUrl(url)`
  - Checks whether the given string is a valid URL.
  - `url` = the string to validate as a URL
  - Returns boolean value.
	```javascript
	tools.isUrl('https://hollaex.com');
	```

- `getKitConfig()`
  - Returns the in-memory kit configuration object for the exchange.
  - Returns object.
	```javascript
	const config = tools.getKitConfig();
	/*
		{
			api_name: 'My Exchange',
			info: { name: 'My Exchange', plan: 'crypto', initialized: true, ... },
			user_meta: {...},
			color: {...},
			strings: {...},
			...
		}
	*/
	```

- `getKitSecrets()`
  - Returns the in-memory kit secrets object for the exchange.
  - Returns object.
	```javascript
	const secrets = tools.getKitSecrets();
	/*
		{
			captcha: {...},
			smtp: {...},
			emails: { sender: 'no-reply@hollaex.com', audit: '...', send_email_to_support: false, ... },
			...
		}
	*/
	```

- `subscribedToCoin(coin)`
  - Checks whether the exchange is subscribed to (has) the given coin.
  - `coin` = the coin symbol, e.g. `'btc'`
  - Returns boolean value.
	```javascript
	tools.subscribedToCoin('btc');
	```

- `getKitTier(tier)`
  - Returns the configuration object for a single tier by its level.
  - `tier` = the tier level key, e.g. `1`
  - Returns object.
	```javascript
	const tier = tools.getKitTier(1);
	/*
		{
			id: 1,
			name: 'basic',
			fees: {...},
			...
		}
	*/
	```

- `getKitTiers()`
  - Returns all configured tiers keyed by tier level.
  - Returns object.
	```javascript
	const tiers = tools.getKitTiers();
	/*
		{
			'1': { id: 1, name: 'basic', ... },
			'2': { id: 2, name: 'advanced', ... }
		}
	*/
	```

- `getKitCoin(coin)`
  - Returns the configuration object for a single coin.
  - `coin` = the coin symbol, e.g. `'btc'`
  - Returns object.
	```javascript
	const coin = tools.getKitCoin('btc');
	/*
		{
			symbol: 'btc',
			fullname: 'Bitcoin',
			active: true,
			allow_deposit: true,
			allow_withdrawal: true,
			...
		}
	*/
	```

- `getKitCoins()`
  - Returns an array of all coin symbols the exchange supports.
  - Returns array.
	```javascript
	const coins = tools.getKitCoins();
	/*
		['btc', 'eth', 'usdt', 'xht']
	*/
	```

- `getKitCoinsConfig()`
  - Returns the full coins configuration object keyed by coin symbol.
  - Returns object.
	```javascript
	const coins = tools.getKitCoinsConfig();
	/*
		{
			btc: { symbol: 'btc', fullname: 'Bitcoin', ... },
			eth: { symbol: 'eth', fullname: 'Ethereum', ... }
		}
	*/
	```

- `subscribedToPair(pair)`
  - Checks whether the exchange is subscribed to the given trading pair (either as a kit pair or a quick trade pair).
  - `pair` = the pair string, e.g. `'btc-usdt'`
  - Returns boolean value.
	```javascript
	tools.subscribedToPair('btc-usdt');
	```

- `getKitPair(pair)`
  - Returns the configuration object for a single trading pair.
  - `pair` = the pair string, e.g. `'btc-usdt'`
  - Returns object.
	```javascript
	const pair = tools.getKitPair('btc-usdt');
	/*
		{
			name: 'btc-usdt',
			pair_base: 'btc',
			pair_2: 'usdt',
			active: true,
			...
		}
	*/
	```

- `getFrozenUsers()`
  - Returns the in-memory map of frozen user ids.
  - Returns object.
	```javascript
	const frozen = tools.getFrozenUsers();
	/*
		{ '42': true, '108': true }
	*/
	```

- `getKitPairs()`
  - Returns an array of all trading pair names the exchange supports.
  - Returns array.
	```javascript
	const pairs = tools.getKitPairs();
	/*
		['btc-usdt', 'eth-usdt']
	*/
	```

- `getKitPairsConfig()`
  - Returns the full trading pairs configuration object keyed by pair name.
  - Returns object.
	```javascript
	const pairs = tools.getKitPairsConfig();
	/*
		{
			'btc-usdt': { name: 'btc-usdt', pair_base: 'btc', pair_2: 'usdt', ... },
			'eth-usdt': { name: 'eth-usdt', pair_base: 'eth', pair_2: 'usdt', ... }
		}
	*/
	```

- `maskSecrets(secrets)`
  - Masks sensitive values (captcha secret key and smtp password) in a secrets object in-place.
  - `secrets` = the secrets object to mask
  - Returns object (the same secrets object with sensitive fields replaced by the mask).
	```javascript
	const masked = tools.maskSecrets({ captcha: { secret_key: 'abc' }, smtp: { password: 'pw' } });
	/*
		{
			captcha: { secret_key: '************' },
			smtp: { password: '************' }
		}
	*/
	```

- `updateKitConfig(kit, scopes)`
  - Updates the kit configuration portion of the exchange status.
  - `kit` = object of kit config keys to update
  - `scopes` = array of the requesting operator's roles (used to authorize the update)
  - Returns promise with the updated `{ kit, secrets }` object (secrets masked).
	```javascript
	tools.updateKitConfig({ api_name: 'New Name' }, ['admin'])
		.then((data) => {
			/*
				{
					kit: { api_name: 'New Name', info: {...}, ... },
					secrets: {...}
				}
			*/
		});
	```

- `updateKitSecrets(secrets, scopes)`
  - Updates the kit secrets portion of the exchange status.
  - `secrets` = object of kit secret keys to update
  - `scopes` = array of the requesting operator's roles (used to authorize the update)
  - Returns promise with the updated `{ kit, secrets }` object (secrets masked).
	```javascript
	tools.updateKitSecrets({ smtp: { password: 'newpw' } }, ['admin'])
		.then((data) => {
			/*
				{
					kit: {...},
					secrets: { smtp: { password: '************' }, ... }
				}
			*/
		});
	```

- `updateKitConfigSecrets(data = {}, scopes, auditInfo, configs, userId)`
  - Updates kit config and/or secrets together, enforcing role-based authorization, writing audit logs, and publishing config-refresh events.
  - `data` = object with optional `kit` and `secrets` sub-objects to update
  - `scopes` = array of the requesting operator's roles; communicators cannot update secrets or unauthorized keys
  - `auditInfo` = `{ userEmail, sessionId, apiPath, method }` used to create audit log entries
  - `configs` = array of permission keys the operator is authorized to update
  - `userId` = id of the user performing the update
  - Returns promise with the updated `{ kit, secrets }` object (secrets masked).
	```javascript
	tools.updateKitConfigSecrets(
		{ kit: { api_name: 'New Name' } },
		['admin'],
		{ userEmail: 'admin@hollaex.com', sessionId: 1, apiPath: '/admin/kit', method: 'PUT' },
		['api_name'],
		1
	)
		.then((data) => {
			/*
				{
					kit: { api_name: 'New Name', info: {...}, ... },
					secrets: {...}
				}
			*/
		});
	```

- `sendEmailToSupport(email, category, subject, description)`
  - Sends a contact-us / support email if the support email feature is enabled.
  - `email` = sender's email address
  - `category` = support category
  - `description` = body of the support message
  - Returns promise (resolves with nothing; rejects if support is disabled).
	```javascript
	tools.sendEmailToSupport('user@hollaex.com', 'general', 'Help', 'I need assistance')
		.then(() => {
			/*
				email queued for support
			*/
		});
	```

- `getNetworkKeySecret()`
  - Fetches the exchange's HollaEx Network API key and secret from the status record.
  - Returns promise with `{ apiKey, apiSecret }`.
	```javascript
	tools.getNetworkKeySecret()
		.then((keys) => {
			/*
				{
					apiKey: 'a1b2c3...',
					apiSecret: 'd4e5f6...'
				}
			*/
		});
	```

- `setExchangeInitialized()`
  - Flags the exchange as initialized in the status record and publishes a config update. Throws if already initialized.
  - Returns promise (resolves with nothing).
	```javascript
	tools.setExchangeInitialized()
		.then(() => {
			/*
				exchange marked initialized
			*/
		});
	```

- `setExchangeSetupCompleted()`
  - Flags the exchange kit setup as completed and publishes a config update. Throws if already completed.
  - Returns promise (resolves with nothing).
	```javascript
	tools.setExchangeSetupCompleted()
		.then(() => {
			/*
				exchange setup marked completed
			*/
		});
	```

- `updateNetworkKeySecret(apiKey, apiSecret)`
  - Updates the exchange's HollaEx Network API key and secret and triggers a network init refresh.
  - `apiKey` = the new network API key (required)
  - `apiSecret` = the new network API secret (required)
  - Returns promise (resolves with nothing; rejects if either value is missing).
	```javascript
	tools.updateNetworkKeySecret('a1b2c3...', 'd4e5f6...')
		.then(() => {
			/*
				network key/secret updated
			*/
		});
	```

- `isValidTierLevel(level)`
  - Checks whether the given numeric tier level exists in the configured tiers.
  - `level` = the tier level number, e.g. `1`
  - Returns boolean value.
	```javascript
	tools.isValidTierLevel(1);
	```

- `getTierLevels()`
  - Returns an array of the configured tier level keys (as strings).
  - Returns array.
	```javascript
	const levels = tools.getTierLevels();
	/*
		['1', '2', '3']
	*/
	```

- `getAssetsPrices(assets = [], quote, amount, opts = { additionalHeaders: null })`
  - Fetches oracle prices for the given assets quoted in a coin, via the network library.
  - `assets` = array of coin symbols to price; each must be a subscribed coin
  - `quote` = the coin to quote the prices in
  - `amount` = the amount to price; must be greater than 0
  - `opts` = optional `{ additionalHeaders }` passed to the network request
  - Returns promise with an object mapping each asset to its price.
	```javascript
	tools.getAssetsPrices(['btc', 'eth'], 'usdt', 1)
		.then((prices) => {
			/*
				{ btc: 65000, eth: 3200 }
			*/
		});
	```

- `storeImageOnNetwork(image, name, opts = { additionalHeaders: null })`
  - Uploads an image/icon to the HollaEx Network and returns its hosted URL.
  - `image` = the image buffer/file to upload
  - `name` = the name to store the image under
  - `opts` = optional `{ additionalHeaders }` passed to the network request
  - Returns promise with the upload result containing the hosted image URL.
	```javascript
	tools.storeImageOnNetwork(imageBuffer, 'btc-icon')
		.then((data) => {
			/*
				{ path: 'https://bucket.../btc-icon.png' }
			*/
		});
	```

- `getPublicTrades(symbol, opts = { additionalHeaders: null })`
  - Fetches recent public trades from the network, optionally filtered by symbol.
  - `symbol` = trading pair to filter by, e.g. `'btc-usdt'` (optional)
  - `opts` = optional `{ additionalHeaders }` passed to the network request
  - Returns promise with an object keyed by symbol of recent trades.
	```javascript
	tools.getPublicTrades('btc-usdt')
		.then((trades) => {
			/*
				{
					'btc-usdt': [
						{ size: 0.1, price: 65000, side: 'buy', timestamp: '2026-06-06T...' }
					]
				}
			*/
		});
	```

- `getOrderbook(symbol, opts = { additionalHeaders: null })`
  - Fetches the order book for a single trading pair from the network.
  - `symbol` = trading pair, e.g. `'btc-usdt'`
  - `opts` = optional `{ additionalHeaders }` passed to the network request
  - Returns promise with the order book object.
	```javascript
	tools.getOrderbook('btc-usdt')
		.then((orderbook) => {
			/*
				{
					'btc-usdt': {
						bids: [[64990, 0.5], ...],
						asks: [[65010, 0.3], ...],
						timestamp: '2026-06-06T...'
					}
				}
			*/
		});
	```

- `getOrderbooks(opts = { additionalHeaders: null })`
  - Fetches order books for all trading pairs from the network.
  - `opts` = optional `{ additionalHeaders }` passed to the network request
  - Returns promise with an object of order books keyed by symbol.
	```javascript
	tools.getOrderbooks()
		.then((orderbooks) => {
			/*
				{
					'btc-usdt': { bids: [...], asks: [...] },
					'eth-usdt': { bids: [...], asks: [...] }
				}
			*/
		});
	```

- `getChart(from, to, symbol, resolution, opts = { additionalHeaders: null })`
  - Fetches OHLCV chart data for a single pair over a time range from the network.
  - `from` = start time (unix timestamp / seconds)
  - `to` = end time (unix timestamp / seconds)
  - `symbol` = trading pair, e.g. `'btc-usdt'`
  - `resolution` = candle resolution, e.g. `'60'` or `'1D'`
  - `opts` = optional `{ additionalHeaders }` passed to the network request
  - Returns promise with an array of candle data.
	```javascript
	tools.getChart(1717545600, 1717632000, 'btc-usdt', '60')
		.then((chart) => {
			/*
				[
					{ time: '2026-06-06T...', open: 64900, high: 65100, low: 64800, close: 65000, volume: 12.3 }
				]
			*/
		});
	```

- `getCharts(from, to, resolution, opts = { additionalHeaders: null })`
  - Fetches OHLCV chart data for all pairs over a time range from the network.
  - `from` = start time (unix timestamp / seconds)
  - `to` = end time (unix timestamp / seconds)
  - `resolution` = candle resolution, e.g. `'60'` or `'1D'`
  - `opts` = optional `{ additionalHeaders }` passed to the network request
  - Returns promise with chart data keyed by symbol.
	```javascript
	tools.getCharts(1717545600, 1717632000, '1D')
		.then((charts) => {
			/*
				{
					'btc-usdt': [ { time, open, high, low, close, volume }, ... ],
					'eth-usdt': [ ... ]
				}
			*/
		});
	```

- `getMiniCharts(assets, opts = { from: null, to: null, quote: null, period: null, additionalHeaders: null })`
  - Fetches lightweight mini-chart price series for the given assets from the network.
  - `assets` = array of coin symbols
  - `opts` = optional `{ from, to, quote, period, additionalHeaders }` controlling range, quote coin and sampling period
  - Returns promise with mini-chart data keyed by asset.
	```javascript
	tools.getMiniCharts(['btc', 'eth'], { quote: 'usdt', period: 7 })
		.then((data) => {
			/*
				{
					btc: { close: [...], price_difference: 1200, price_difference_percent: 1.8 },
					eth: { ... }
				}
			*/
		});
	```

- `getUdfConfig(opts = { additionalHeaders: null })`
  - Fetches the TradingView UDF datafeed configuration from the network.
  - `opts` = optional `{ additionalHeaders }` passed to the network request
  - Returns promise with the UDF config object.
	```javascript
	tools.getUdfConfig()
		.then((config) => {
			/*
				{
					supported_resolutions: ['60', '1D', ...],
					supports_group_request: false,
					supports_search: true,
					...
				}
			*/
		});
	```

- `getUdfHistory(from, to, symbol, resolution, opts = { additionalHeaders: null })`
  - Fetches TradingView UDF history (OHLCV bars) for a pair from the network.
  - `from` = start time (unix timestamp / seconds)
  - `to` = end time (unix timestamp / seconds)
  - `symbol` = trading pair, e.g. `'btc-usdt'`
  - `resolution` = candle resolution
  - `opts` = optional `{ additionalHeaders }` passed to the network request
  - Returns promise with the UDF history object.
	```javascript
	tools.getUdfHistory(1717545600, 1717632000, 'btc-usdt', '60')
		.then((history) => {
			/*
				{
					s: 'ok',
					t: [1717545600, ...],
					o: [64900, ...],
					h: [65100, ...],
					l: [64800, ...],
					c: [65000, ...],
					v: [12.3, ...]
				}
			*/
		});
	```

- `getUdfSymbols(symbol, opts = { additionalHeaders: null })`
  - Fetches TradingView UDF symbol info for a pair from the network.
  - `symbol` = trading pair, e.g. `'btc-usdt'`
  - `opts` = optional `{ additionalHeaders }` passed to the network request
  - Returns promise with the UDF symbol info object.
	```javascript
	tools.getUdfSymbols('btc-usdt')
		.then((info) => {
			/*
				{
					name: 'btc-usdt',
					ticker: 'btc-usdt',
					pricescale: 100,
					session: '24x7',
					...
				}
			*/
		});
	```

- `getTicker(symbol, opts = { additionalHeaders: null })`
  - Fetches the latest ticker for a single trading pair from the network.
  - `symbol` = trading pair, e.g. `'btc-usdt'`
  - `opts` = optional `{ additionalHeaders }` passed to the network request
  - Returns promise with the ticker object.
	```javascript
	tools.getTicker('btc-usdt')
		.then((ticker) => {
			/*
				{
					open: 64500,
					close: 65000,
					high: 65200,
					low: 64300,
					last: 65000,
					volume: 120.5
				}
			*/
		});
	```

- `getTickers(opts = { additionalHeaders: null })`
  - Fetches the latest tickers for all trading pairs from the network.
  - `opts` = optional `{ additionalHeaders }` passed to the network request
  - Returns promise with tickers keyed by symbol.
	```javascript
	tools.getTickers()
		.then((tickers) => {
			/*
				{
					'btc-usdt': { open, close, high, low, last, volume },
					'eth-usdt': { ... }
				}
			*/
		});
	```

- `getTradesHistory(symbol, side, limit, page, orderBy, order, startDate, endDate, opts = { additionalHeaders: null })`
  - Fetches the exchange's historical trades from the network with filtering and pagination.
  - `symbol` = trading pair filter
  - `side` = `'buy'` or `'sell'` filter
  - `limit` = number of records per page
  - `page` = page number
  - `orderBy` = field to order by
  - `order` = `'asc'` or `'desc'`
  - `startDate` = range start (ISO date)
  - `endDate` = range end (ISO date)
  - `opts` = optional `{ additionalHeaders }` passed to the network request
  - Returns promise with `{ count, data }`.
	```javascript
	tools.getTradesHistory('btc-usdt', 'buy', 50, 1, 'timestamp', 'desc', '2026-06-01', '2026-06-06')
		.then((trades) => {
			/*
				{
					count: 230,
					data: [
						{ symbol: 'btc-usdt', side: 'buy', size: 0.1, price: 65000, timestamp: '2026-06-06T...' }
					]
				}
			*/
		});
	```

- `sendEmail(type, receiver, data, userSettings = {}, domain)`
  - Sends a templated SMTP email of the given mail type.
  - `type` = mail type key (resolved against `MAILTYPE`)
  - `receiver` = recipient email address
  - `data` = template data object
  - `userSettings` = recipient's notification/settings object (optional)
  - `domain` = exchange domain used in the email (optional)
  - Returns promise (resolves once the email is dispatched).
	```javascript
	tools.sendEmail('WELCOME', 'user@hollaex.com', { name: 'User' }, {}, 'https://hollaex.com')
		.then(() => {
			/*
				email sent
			*/
		});
	```

- `isEmail(email)`
  - Checks whether the given string is a valid email address.
  - `email` = the string to validate
  - Returns boolean value.
	```javascript
	tools.isEmail('user@hollaex.com');
	```

- `sleep(ms)`
  - Returns a promise that resolves after the given number of milliseconds.
  - `ms` = delay in milliseconds
  - Returns promise (resolves with nothing after the delay).
	```javascript
	tools.sleep(1000)
		.then(() => {
			/*
				resolved after 1 second
			*/
		});
	```

- `sendCustomEmail(to, subject, html, opts = { from: null, cc: null, text: null, bcc: null })`
  - Sends a custom HTML email via nodemailer, supporting cc/bcc/text and a default audit bcc.
  - `to` = comma-separated recipient addresses
  - `subject` = email subject
  - `html` = HTML body
  - `opts` = optional `{ from, cc, text, bcc }`; `bcc: 'default'` bccs the audit address when support emails are enabled, otherwise cc/bcc accept comma-separated strings
  - Returns promise (resolves once the email is dispatched).
	```javascript
	tools.sendCustomEmail('user@hollaex.com', 'Notice', '<p>Hello</p>', { bcc: 'default' })
		.then(() => {
			/*
				custom email sent
			*/
		});
	```

- `addKitUserMeta(name, type, description, required = false)`
  - Adds a new user_meta field to the kit config, validates it, persists it and publishes the update.
  - `name` = the new field name (must not already exist)
  - `type` = field data type (must be a valid user meta type)
  - `description` = field description
  - `required` = whether the field is required (default `false`)
  - Returns promise with the updated user_meta object.
	```javascript
	tools.addKitUserMeta('nickname', 'string', 'User nickname', false)
		.then((userMeta) => {
			/*
				{
					nickname: { type: 'string', required: false, description: 'User nickname' }
				}
			*/
		});
	```

- `updateKitUserMeta(name, data = { type: null, description: null, required: null }, auditInfo)`
  - Updates an existing user_meta field (only provided values change), writes an audit log and publishes the update.
  - `name` = the field name (must already exist)
  - `data` = `{ type, description, required }`; at least one value must be provided
  - `auditInfo` = `{ userEmail, sessionId, apiPath, method }` used for the audit log
  - Returns promise with the updated user_meta object.
	```javascript
	tools.updateKitUserMeta(
		'nickname',
		{ required: true },
		{ userEmail: 'admin@hollaex.com', sessionId: 1, apiPath: '/admin/kit/user-meta', method: 'PUT' }
	)
		.then((userMeta) => {
			/*
				{
					nickname: { type: 'string', required: true, description: 'User nickname' }
				}
			*/
		});
	```

- `deleteKitUserMeta(name)`
  - Removes an existing user_meta field from the kit config and publishes the update.
  - `name` = the field name to delete (must already exist)
  - Returns promise with the updated user_meta object.
	```javascript
	tools.deleteKitUserMeta('nickname')
		.then((userMeta) => {
			/*
				{}
			*/
		});
	```

- `kitUserMetaFieldIsValid(field, data)`
  - Validates a user_meta field definition (required keys, valid type, string description, boolean required).
  - `field` = the field name (used in error messages)
  - `data` = the field definition `{ type, description, required }`
  - Returns object `{ success, message }` (`message` only present on failure).
	```javascript
	tools.kitUserMetaFieldIsValid('nickname', { type: 'string', description: 'Nickname', required: false });
	/*
		{ success: true }
	*/
	```

- `stringIsDate(date)`
  - Checks whether the given value is a string that parses to a valid date.
  - `date` = the value to test
  - Returns boolean value.
	```javascript
	tools.stringIsDate('2026-06-06');
	```

- `errorMessageConverter(err)`
  - Converts an error/exception into a human-readable error message string.
  - `err` = the error object to convert
  - Returns string.
	```javascript
	const message = tools.errorMessageConverter(err);
	/*
		'User does not exist'
	*/
	```

- `getDomain()`
  - Returns the configured exchange domain constant.
  - Returns string.
	```javascript
	const domain = tools.getDomain();
	/*
		'https://hollaex.com'
	*/
	```

- `isDatetime(date, formats = [moment.ISO_8601])`
  - Checks whether the given value is a valid datetime matching one of the allowed formats.
  - `date` = the value to validate
  - `formats` = array of accepted moment formats (default ISO 8601)
  - Returns boolean value.
	```javascript
	tools.isDatetime('2026-06-06T12:00:00Z');
	```

- `emailHtmlBoilerplate(html)`
  - Wraps the given HTML content in the standard exchange email template boilerplate.
  - `html` = the inner HTML content
  - Returns string (the full templated HTML).
	```javascript
	const fullHtml = tools.emailHtmlBoilerplate('<p>Hello</p>');
	/*
		'<html>...<p>Hello</p>...</html>'
	*/
	```

- `getNetworkConstants(opts = { additionalHeaders: null })`
  - Fetches the HollaEx Network constants (coins, pairs, tiers, etc.) from the network.
  - `opts` = optional `{ additionalHeaders }` passed to the network request
  - Returns promise with the network constants object.
	```javascript
	tools.getNetworkConstants()
		.then((constants) => {
			/*
				{
					coins: {...},
					pairs: {...},
					tiers: {...},
					...
				}
			*/
		});
	```

- `getNetworkEndpoint()`
  - Returns the configured HollaEx Network endpoint URL constant.
  - Returns string.
	```javascript
	const endpoint = tools.getNetworkEndpoint();
	/*
		'https://api.hollaex.network'
	*/
	```

- `getMinFees()`
  - Returns the minimum fees configuration for the exchange's current plan.
  - Returns object.
	```javascript
	const minFees = tools.getMinFees();
	/*
		{ maker: 0.1, taker: 0.1 }
	*/
	```

- `getEmail()`
  - Returns the configured exchange contact/notification email settings.
  - Returns object.
	```javascript
	const email = tools.getEmail();
	/*
		{ timezone: 'UTC', ... }
	*/
	```

- `updateEmail(data)`
  - Updates the exchange email settings in the status record and publishes the update.
  - `data` = object containing the `email` settings to set
  - Returns promise with the updated email settings.
	```javascript
	tools.updateEmail({ email: { timezone: 'UTC' } })
		.then((email) => {
			/*
				{ timezone: 'UTC' }
			*/
		});
	```

- `checkExchangeStatus()`
  - Checks the exchange status/health against the HollaEx Network (re-exported from init).
  - Returns promise with the status check result.
	```javascript
	tools.checkExchangeStatus()
		.then((status) => {
			/*
				true
			*/
		});
	```

- `validateIp(ip)`
  - Validates an IPv4/IPv6 address or CIDR range (IPv4 allows /16, /24, /32; IPv6 allows /0–/128).
  - `ip` = the IP or CIDR string to validate
  - Returns boolean value.
	```javascript
	tools.validateIp('192.168.0.1/24');
	```

- `validatePair(pair)`
  - Validates a trading pair string format and that both base and quote coins exist and differ.
  - `pair` = the pair string, e.g. `'btc-usdt'`
  - Returns boolean value.
	```javascript
	tools.validatePair('btc-usdt');
	```

- `getBrokerDeals()`
  - Returns the in-memory list of configured broker deals.
  - Returns array.
	```javascript
	const deals = tools.getBrokerDeals();
	/*
		[ { id: 1, symbol: 'btc-usdt', buy_price: 64900, sell_price: 65100, ... } ]
	*/
	```

- `getQuickTrades()`
  - Returns the in-memory list of configured quick trade entries.
  - Returns array.
	```javascript
	const quickTrades = tools.getQuickTrades();
	/*
		[ { symbol: 'btc-usdt', type: 'pro', active: true } ]
	*/
	```

- `getNetworkQuickTrades()`
  - Returns the in-memory list of network-provided quick trade entries.
  - Returns array.
	```javascript
	const networkQuickTrades = tools.getNetworkQuickTrades();
	/*
		[ { symbol: 'btc-usdt', type: 'network', active: true } ]
	*/
	```

- `parseNumber(number, precisionValue)`
  - Reduces a number to the given significant-digit precision, rounding down.
  - `number` = the number to parse
  - `precisionValue` = number of significant digits to keep
  - Returns number.
	```javascript
	tools.parseNumber(0.123456789, 4);
	/*
		0.1234
	*/
	```

- `getQuickTradePairs()`
  - Returns an array of symbols from the configured quick trades.
  - Returns array.
	```javascript
	const pairs = tools.getQuickTradePairs();
	/*
		['btc-usdt', 'eth-usdt']
	*/
	```

- `getTransactionLimits()`
  - Returns the in-memory transaction limits configuration.
  - Returns array/object.
	```javascript
	const limits = tools.getTransactionLimits();
	/*
		[ { id: 1, tier: 1, amount: 1000, currency: 'usdt', type: 'withdrawal', ... } ]
	*/
	```

- `getRoles()`
  - Returns the in-memory custom roles configuration.
  - Returns array/object.
	```javascript
	const roles = tools.getRoles();
	/*
		[ { id: 1, role_name: 'support', permissions: [...], ... } ]
	*/
	```

- `getTradePaths()`
  - Returns the in-memory configured trade paths.
  - Returns array/object.
	```javascript
	const paths = tools.getTradePaths();
	/*
		[ { source: 'btc', destination: 'usdt', path: ['btc-usdt'] } ]
	*/
	```

- `removeRepeatingDecimals(num)`
  - Collapses a trailing run of repeating decimal digits on long decimal numbers and returns the parsed float.
  - `num` = the number to clean up
  - Returns number.
	```javascript
	tools.removeRepeatingDecimals(0.123333333);
	/*
		0.123333
	*/
	```

#### User functions

- `loginUser(email, password, otp_code, captcha, ip, device, domain, origin, referer [, headers = {}])`
  - Authenticates a user by email/password, verifying activation, email/phone verification, OTP and captcha, then registers the login
  - `otp_code` = TOTP code, required only when the user has OTP enabled
  - `captcha` = captcha token verified against the IP
  - `ip`, `device`, `domain`, `origin`, `referer` = login metadata recorded on success
  - Returns a promise resolving to the user model instance
	```javascript
	tools.user.loginUser('user@example.com', 'Password123!', '123456', captchaToken, '1.2.3.4')
		.then((user) => {
			/*
				{ id: 42, email: 'user@example.com', verification_level: 2, activated: true, ... }
			*/
		});
	```

- `getUserTier(user_id)`
  - Returns the tier (verification level) configuration row for a given user
  - `user_id` = kit id of the user; user must be verified (level >= 1)
  - Returns a promise resolving to the tier record
	```javascript
	tools.user.getUserTier(42)
		.then((tier) => {
			/*
				{ id: 2, name: 'Tier 2', maker: {...}, taker: {...}, ... }
			*/
		});
	```

- `createUser(email, password [, opts = { role, id, email_verified, referral, additionalHeaders }])`
  - Creates a kit user (and a matching network user), optionally as admin, applies referral, sends welcome email
  - `opts.role` = `'user'` or `'admin'`
  - `opts.id` = force a specific kit id (number)
  - `opts.referral` = affiliation code to attach
  - Returns a promise that resolves (no value) once the user is created and the welcome email is queued
	```javascript
	tools.user.createUser('user@example.com', 'Password123!', { role: 'user', referral: 'ABC123' })
		.then(() => {
			/* user created */
		});
	```

- `getUserByEmail(email [, rawData = true, networkData = false, opts = { additionalHeaders }])`
  - Looks up a user by email, optionally merging network balance/wallet
  - `rawData` = return plain object (true) vs sequelize instance (false)
  - `networkData` = also fetch balance and wallet from the network
  - Returns a promise resolving to the user (or null)
	```javascript
	tools.user.getUserByEmail('user@example.com')
		.then((user) => {
			/*
				{ id: 42, email: 'user@example.com', network_id: 100, verification_level: 2, ... }
			*/
		});
	```

- `getUserByKitId(kit_id [, rawData = true, networkData = false, opts = { additionalHeaders }])`
  - Looks up a user by their kit id
  - `kit_id` = the exchange (kit) user id
  - Returns a promise resolving to the user (or null)
	```javascript
	tools.user.getUserByKitId(42)
		.then((user) => {
			/*
				{ id: 42, email: 'user@example.com', network_id: 100, ... }
			*/
		});
	```

- `getUserByNetworkId(network_id [, rawData = true, networkData = false, opts = { additionalHeaders }])`
  - Looks up a user by their network id
  - `network_id` = the user's id on the network layer
  - Returns a promise resolving to the user (or null)
	```javascript
	tools.user.getUserByNetworkId(100)
		.then((user) => {
			/*
				{ id: 42, email: 'user@example.com', network_id: 100, ... }
			*/
		});
	```

- `getUserByPhoneNumber(phone_number [, rawData = true, networkData = false, opts = { additionalHeaders }])`
  - Looks up a user by E.164 phone number (must include leading `+` and country code)
  - `phone_number` = strict-mode mobile phone, normalized before lookup
  - Returns a promise resolving to the user (or null)
	```javascript
	tools.user.getUserByPhoneNumber('+14155552671')
		.then((user) => {
			/*
				{ id: 42, phone_number: '+14155552671', ... }
			*/
		});
	```

- `freezeUserById(userId)`
  - Deactivates (freezes) a user by kit id, revokes all sessions, publishes a freeze event and emails the user; cannot freeze admins
  - Returns a promise resolving to the updated user instance
	```javascript
	tools.user.freezeUserById(42)
		.then((user) => {
			/*
				{ id: 42, activated: false, ... }
			*/
		});
	```

- `freezeUserByEmail(email)`
  - Deactivates (freezes) a user by email and emails the user; cannot freeze admins
  - Returns a promise resolving to the updated user instance
	```javascript
	tools.user.freezeUserByEmail('user@example.com')
		.then((user) => {
			/*
				{ id: 42, activated: false, ... }
			*/
		});
	```

- `unfreezeUserById(userId)`
  - Reactivates (unfreezes) a previously frozen user by kit id and emails them
  - Returns a promise resolving to the updated user instance
	```javascript
	tools.user.unfreezeUserById(42)
		.then((user) => {
			/*
				{ id: 42, activated: true, ... }
			*/
		});
	```

- `unfreezeUserByEmail(email)`
  - Reactivates (unfreezes) a previously frozen user by email and emails them
  - Returns a promise resolving to the updated user instance
	```javascript
	tools.user.unfreezeUserByEmail('user@example.com')
		.then((user) => {
			/*
				{ id: 42, activated: true, ... }
			*/
		});
	```

- `getAllUsers()`
  - Returns all users with sensitive/omitted fields excluded
  - Returns a promise resolving to an array of user records
	```javascript
	tools.user.getAllUsers()
		.then((users) => {
			/*
				[ { id: 42, email: 'user@example.com', ... }, ... ]
			*/
		});
	```

- `updateUserSettings(userOpts = {}, settings = {})`
  - Merges and updates a user's settings (notification, interface, risk, language, etc.); `verification_method` is always stripped
  - `userOpts` = identifier object ({ kit_id } / { email } / { network_id })
  - `settings` = partial settings object to merge
  - Returns a promise resolving to the omitted-field user object
	```javascript
	tools.user.updateUserSettings({ kit_id: 42 }, { language: 'fr', interface: { theme: 'dark' } })
		.then((user) => {
			/*
				{ id: 42, settings: { language: 'fr', interface: { theme: 'dark', ... }, ... }, ... }
			*/
		});
	```

- `omitUserFields(user)`
  - Synchronously strips omitted/sensitive fields from a user object and normalizes settings defaults
  - Returns the filtered user object (not a promise)
	```javascript
	tools.user.omitUserFields(userObject);
	/*
		{ id: 42, email: 'user@example.com', settings: { notification: {...}, interface: {...}, risk: {...} } }
	*/
	```

- `registerUserLogin(userId, ip [, opts = { device, domain, origin, referer, token, expiry, status, country }])`
  - Creates a login record (and a session if token + status are provided); infers country from IP when not supplied
  - `opts.status` = whether the login succeeded (false adds attempt counter)
  - `opts.token`/`opts.expiry` = JWT and expiry used to create the session
  - Returns a promise resolving to the login record (or session)
	```javascript
	tools.user.registerUserLogin(42, '1.2.3.4', { device: 'Chrome', status: true, token: jwt })
		.then((login) => {
			/*
				{ id: 9001, user_id: 42, ip: '1.2.3.4', status: true, country: 'US', ... }
			*/
		});
	```

- `getAllUsersAdmin([opts = { id, user_id, search, pending, pending_type, limit, page, order_by, order, start_date, end_date, format, ... }])`
  - Admin search/listing of users with rich filtering (search, verification, KYC/bank pending, dob range, etc.), CSV export, and network balance for single-user lookups
  - `opts.search` = fuzzy match across email/username/full_name/phone/id number
  - `opts.pending` + `opts.pending_type` (`'id'` / `'bank'`) = filter users awaiting admin approval
  - `opts.format` = `'csv'` returns CSV string, otherwise paginated count/data
  - Returns a promise resolving to `{ count, data }` (or a CSV string)
	```javascript
	tools.user.getAllUsersAdmin({ search: 'user@example.com' })
		.then(({ count, data }) => {
			/*
				{ count: 1, data: [ { id: 42, email: 'user@example.com', balance: {...}, wallet: {...} } ] }
			*/
		});
	```

- `updateUserRole(user_id, role_name, admin_id, otp_code)`
  - Assigns/clears an operator role for a user; requires the acting admin to have OTP enabled and pass `otp_code`; revokes the user's sessions. Cannot assign or change the `admin` role
  - `role_name` = `'user'` (clears role) or an existing operator role name
  - Returns a promise resolving to the user (when set to `user`) or `{ message: 'Success' }`
	```javascript
	tools.user.updateUserRole(42, 'support', 1, '123456')
		.then((result) => {
			/*
				{ message: 'Success' }
			*/
		});
	```

- `updateUserNote(userId, note, auditInfo)`
  - Updates the admin note on a user and writes an audit log
  - `auditInfo` = `{ userEmail, sessionId, apiPath, method }` used for the audit entry
  - Returns a promise resolving to the updated user instance
	```javascript
	tools.user.updateUserNote(42, 'VIP customer', { userEmail: 'admin@ex.com', sessionId: 5, apiPath: '/admin/user/note', method: 'put' })
		.then((user) => {
			/*
				{ id: 42, note: 'VIP customer', ... }
			*/
		});
	```

- `updateUserDiscount(userId, discount, auditInfo)`
  - Sets a user's fee discount (0-100); on increase, logs an audit entry and emails the user
  - `discount` = percentage between 0 and 100
  - Returns a promise resolving to `{ id, discount }`
	```javascript
	tools.user.updateUserDiscount(42, 20, { userEmail: 'admin@ex.com', sessionId: 5, apiPath: '/admin/user/discount', method: 'put' })
		.then((data) => {
			/*
				{ id: 42, discount: 20 }
			*/
		});
	```

- `changeUserVerificationLevelById(userId, newLevel [, domain])`
  - Changes a user's verification (tier) level; publishes an event and emails on upgrade. User must already be verified
  - `newLevel` = valid tier level
  - Returns a promise that resolves (no value)
	```javascript
	tools.user.changeUserVerificationLevelById(42, 3)
		.then(() => {
			/* level updated */
		});
	```

- `deactivateUserOtpById(userId)`
  - Disables OTP (2FA) for a user by kit id
  - Returns a promise resolving to the updated user instance
	```javascript
	tools.user.deactivateUserOtpById(42)
		.then((user) => {
			/*
				{ id: 42, otp_enabled: false, ... }
			*/
		});
	```

- `toggleFlaggedUserById(userId)`
  - Toggles the `flagged` boolean on a user
  - Returns a promise resolving to the updated user instance
	```javascript
	tools.user.toggleFlaggedUserById(42)
		.then((user) => {
			/*
				{ id: 42, flagged: true, ... }
			*/
		});
	```

- `getUserLogins([opts = { userId, status, country, ip, limit, page, orderBy, order, startDate, endDate, format }])`
  - Lists login records with filtering and optional CSV export
  - `opts.status` = filter by success/failure
  - `opts.format` = `'csv'` returns CSV string
  - Returns a promise resolving to `{ count, data }` (or a CSV string)
	```javascript
	tools.user.getUserLogins({ userId: 42, limit: 50 })
		.then(({ count, data }) => {
			/*
				{ count: 12, data: [ { id: 9001, user_id: 42, ip: '1.2.3.4', country: 'US', status: true } ] }
			*/
		});
	```

- `getUserAudits([opts = { user_id, subject, limit, page, orderBy, order, startDate, endDate, format }])`
  - Lists admin audit log records (only on supported plans) with optional CSV export
  - `opts.subject` = fuzzy match on the actor (admin email)
  - Returns a promise resolving to `{ count, data }` (or a CSV string)
	```javascript
	tools.user.getUserAudits({ user_id: 42 })
		.then(({ count, data }) => {
			/*
				{ count: 3, data: [ { id: 1, subject: 'admin@ex.com', description: '...', user_id: 42 } ] }
			*/
		});
	```

- `setUsernameById(userId, username)`
  - Sets a user's chat username (once only); validates format and uniqueness
  - `username` = 3-15 chars, lowercase alphanumeric/underscore
  - Returns a promise resolving to the updated user instance
	```javascript
	tools.user.setUsernameById(42, 'trader_joe')
		.then((user) => {
			/*
				{ id: 42, username: 'trader_joe', settings: { chat: { set_username: true } } }
			*/
		});
	```

- `getAffiliationCount(userId [, opts = { limit, page, order_by, order, start_date, end_date }])`
  - Lists/counts the affiliations (referred users) for a referrer
  - `userId` = referrer kit id
  - Returns a promise resolving to `{ count, data }` with included referred user email
	```javascript
	tools.user.getAffiliationCount(42)
		.then(({ count, data }) => {
			/*
				{ count: 5, data: [ { code: 'ABC123', earning_rate: 10, user: { id: 50, email: 'ref@ex.com' } } ] }
			*/
		});
	```

- `getUserReferer(userId)`
  - Returns the affiliation record (with referer email) for a referred user, or the string `'No Referer'`
  - Returns a promise resolving to the affiliation object or `'No Referer'`
	```javascript
	tools.user.getUserReferer(50)
		.then((data) => {
			/*
				{ code: 'ABC123', earning_rate: 10, referer: { id: 42, email: 'ref@ex.com' } }
			*/
		});
	```

- `isValidUsername(username)`
  - Synchronously tests whether a username matches `^[a-z0-9_]{3,15}$`
  - Returns a boolean (not a promise)
	```javascript
	tools.user.isValidUsername('trader_joe'); // true
	```

- `createUserCryptoAddressByKitId(kitId, crypto [, opts = { network, additionalHeaders }])`
  - Generates a crypto deposit address for a user (resolved by kit id) on the network
  - `crypto` = coin symbol (e.g. `'btc'`)
  - `opts.network` = specific chain/network for multi-network coins
  - Returns a promise resolving to the created crypto address record
	```javascript
	tools.user.createUserCryptoAddressByKitId(42, 'xrp', { network: 'xrp' })
		.then((data) => {
			/*
				{ currency: 'xrp', address: 'rXXXX...', network: 'xrp', ... }
			*/
		});
	```

- `createAudit(adminId, event, ip [, opts = { userId, prevUserData, newUserData, domain }])`
  - Creates an audit record describing the diff between previous and new user data for an admin action
  - `event` = audit event name
  - `opts.prevUserData` / `opts.newUserData` = old/new user objects compared to build the description
  - Returns a promise resolving to the created audit record
	```javascript
	tools.user.createAudit(1, 'user update', '1.2.3.4', { userId: 42, prevUserData: {...}, newUserData: {...} })
		.then((audit) => {
			/*
				{ id: 1, admin_id: 1, event: 'user update', description: {...}, ip: '1.2.3.4' }
			*/
		});
	```

- `createAuditLog(subject, adminEndpoint, method [, data = {}, prevData = null])`
  - Builds a human-readable audit log entry for an admin endpoint call (get/post/put/delete); no-op when `subject.email` is missing
  - `subject` = `{ email, session_id }` of the acting admin
  - `method` = HTTP method controlling the generated description wording
  - Returns a promise resolving to the created audit record (or undefined/error on failure)
	```javascript
	tools.user.createAuditLog({ email: 'admin@ex.com', session_id: 5 }, '/admin/user', 'put', { note: 'x' }, { note: 'y' })
		.then((audit) => {
			/*
				{ id: 1, subject: 'admin@ex.com', description: 'note field(s) updated ...', user_id: undefined }
			*/
		});
	```

- `getUserStatsByKitId(userId [, opts = { additionalHeaders }])`
  - Fetches trading stats for a user (resolved by kit id) from the network
  - Returns a promise resolving to the user's network stats object
	```javascript
	tools.user.getUserStatsByKitId(42)
		.then((stats) => {
			/*
				{ fees: {...}, volume: {...}, ... }
			*/
		});
	```

- `disableUserWithdrawal(user_id [, opts = { expiry_date, override }])`
  - Blocks (or clears) a user's withdrawals until an expiry date; shortening/clearing an active future block requires `override: true`
  - `opts.expiry_date` = when the block expires (null clears it)
  - `opts.override` = allow shortening/clearing an existing active block
  - Returns a promise resolving to the updated user instance
	```javascript
	tools.user.disableUserWithdrawal(42, { expiry_date: '2026-07-01T00:00:00.000Z' })
		.then((user) => {
			/*
				{ id: 42, withdrawal_blocked: '2026-07-01T00:00:00.000Z', ... }
			*/
		});
	```

- `getExchangeOperators([opts = { limit, page, orderBy, order, email }])`
  - Lists exchange operator users (those holding an operator role)
  - `opts.email` = fuzzy match on operator email
  - Returns a promise resolving to `{ count, data }`
	```javascript
	tools.user.getExchangeOperators()
		.then(({ count, data }) => {
			/*
				{ count: 2, data: [ { id: 1, email: 'admin@ex.com', role: 'admin' } ] }
			*/
		});
	```

- `createUserOnNetwork(email [, opts = { additionalHeaders }])`
  - Creates the corresponding user on the network layer; accepts a real email or the synthetic `<digits>_sms` phone-signup placeholder
  - Returns a promise resolving to the created network user
	```javascript
	tools.user.createUserOnNetwork('user@example.com')
		.then((networkUser) => {
			/*
				{ id: 100, email: 'user@example.com', ... }
			*/
		});
	```

- `getUserNetwork(networkId [, opts = { additionalHeaders }])`
  - Fetches a user directly from the network layer by network id
  - Returns a promise resolving to the network user object
	```javascript
	tools.user.getUserNetwork(100)
		.then((networkUser) => {
			/*
				{ id: 100, balance: {...}, wallet: [...] }
			*/
		});
	```

- `getUsersNetwork([opts = { additionalHeaders }])`
  - Fetches the list of users from the network layer
  - Returns a promise resolving to the network users response
	```javascript
	tools.user.getUsersNetwork()
		.then((data) => {
			/*
				{ count: 1000, data: [ { id: 100, ... } ] }
			*/
		});
	```

- `createUserCryptoAddressByNetworkId(networkId, crypto [, opts = { network, additionalHeaders }])`
  - Generates a crypto deposit address for a user identified by network id
  - Returns a promise resolving to the created crypto address record
	```javascript
	tools.user.createUserCryptoAddressByNetworkId(100, 'btc')
		.then((data) => {
			/*
				{ currency: 'btc', address: 'bc1...', ... }
			*/
		});
	```

- `getUserStatsByNetworkId(networkId [, opts = { additionalHeaders }])`
  - Fetches trading stats for a user by network id
  - Returns a promise resolving to the user's network stats object
	```javascript
	tools.user.getUserStatsByNetworkId(100)
		.then((stats) => {
			/*
				{ fees: {...}, volume: {...} }
			*/
		});
	```

- `getUserByAffiliationCode(affiliationCode)`
  - Looks up a referral code record by its code string
  - Returns a promise resolving to `{ id, user_id, discount, earning_rate }` (or null)
	```javascript
	tools.user.getUserByAffiliationCode('ABC123')
		.then((referrer) => {
			/*
				{ id: 7, user_id: 42, discount: 10, earning_rate: 20 }
			*/
		});
	```

- `checkAffiliation(affiliationCode, user_id)`
  - Attaches a new user to a referrer's affiliation code (creates affiliation, increments referral_count, applies discount)
  - `user_id` = the newly referred user's kit id
  - Returns a promise (resolves after applying the referer's discount, or no-op if code invalid)
	```javascript
	tools.user.checkAffiliation('ABC123', 50)
		.then(() => {
			/* affiliation linked */
		});
	```

- `connectUserReferral(affiliationCode, userId [, hoursThreshold = 24])`
  - Connects a referral code to an existing user within a time window (requires referral history feature active); rejects expired window, duplicate affiliation, or self-referral
  - `hoursThreshold` = max hours since account creation to allow connecting
  - Returns a promise resolving to the updated user instance (with discount applied)
	```javascript
	tools.user.connectUserReferral('ABC123', 50)
		.then((user) => {
			/*
				{ id: 50, discount: 10, ... }
			*/
		});
	```

- `verifyUserEmailByKitId(kitId)`
  - Marks a user's email as verified (admin action); errors if already verified
  - Returns a promise resolving to the updated user instance
	```javascript
	tools.user.verifyUserEmailByKitId(42)
		.then((user) => {
			/*
				{ id: 42, email_verified: true, ... }
			*/
		});
	```

- `verifyUserPhoneByKitId(kitId)`
  - Marks a user's phone number as verified (admin action); errors if no phone or already verified
  - Returns a promise resolving to the updated user instance
	```javascript
	tools.user.verifyUserPhoneByKitId(42)
		.then((user) => {
			/*
				{ id: 42, phone_number_verified: true, ... }
			*/
		});
	```

- `generateAffiliationCode()`
  - Synchronously generates a random uppercase alphanumeric affiliation code
  - Returns a string (not a promise)
	```javascript
	tools.user.generateAffiliationCode(); // 'A1B2C3'
	```

- `updateUserMeta(id [, givenMeta = {}, opts = { overwrite }], auditInfo)`
  - Validates and updates a user's custom `meta` fields against the kit's meta reference (type checks, required fields, deletion of nils), then audit-logs the change
  - `opts.overwrite` = replace the whole meta object vs merge
  - Returns a promise resolving to `{ id, email, meta }`
	```javascript
	tools.user.updateUserMeta(42, { referral_source: 'twitter' }, { overwrite: false }, { userEmail: 'admin@ex.com', sessionId: 5, apiPath: '/admin/user/meta', method: 'put' })
		.then((data) => {
			/*
				{ id: 42, email: 'user@example.com', meta: { referral_source: 'twitter' } }
			*/
		});
	```

- `mapNetworkIdToKitId(networkIds = [])`
  - Resolves an array of network ids to their kit ids (cached); throws if none found
  - Returns a promise resolving to a map `{ [networkId]: kitId }`
	```javascript
	tools.user.mapNetworkIdToKitId([100, 101])
		.then((map) => {
			/*
				{ 100: 42, 101: 43 }
			*/
		});
	```

- `mapKitIdToNetworkId(kitIds = [])`
  - Resolves an array of kit ids to their network ids (cached); throws if none found
  - Returns a promise resolving to a map `{ [kitId]: networkId }`
	```javascript
	tools.user.mapKitIdToNetworkId([42, 43])
		.then((map) => {
			/*
				{ 42: 100, 43: 101 }
			*/
		});
	```

- `updateUserInfo(userId [, data = {}], auditInfo)`
  - Updates whitelisted profile fields (full_name, nationality, phone_number, gender, dob, address, id_data) with per-field type validation, publishes an update event, and audit-logs
  - `data` = object of fields to update (invalid-typed fields are ignored)
  - Returns a promise resolving to the omitted-field user object
	```javascript
	tools.user.updateUserInfo(42, { full_name: 'Jane Doe', nationality: 'US' }, { userEmail: 'admin@ex.com', sessionId: 5, apiPath: '/admin/user', method: 'put' })
		.then((user) => {
			/*
				{ id: 42, full_name: 'Jane Doe', nationality: 'US', ... }
			*/
		});
	```

- `updateLoginAttempt(loginId)`
  - Atomically increments a login row's `attempt` counter only while below the lockout cap
  - Returns a promise resolving to the sequelize update result `[affectedCount]`
	```javascript
	tools.user.updateLoginAttempt(9001)
		.then(([affectedCount]) => {
			/* affectedCount: 1 */
		});
	```

- `updateLoginStatus(loginId)`
  - Sets a login record's `status` to true (marks it successful)
  - Returns a promise resolving to the sequelize update result `[affectedCount]`
	```javascript
	tools.user.updateLoginStatus(9001)
		.then(([affectedCount]) => {
			/* affectedCount: 1 */
		});
	```

- `getExchangeUserSessions([opts = { user_id, last_seen, status, limit, page, order_by, order, start_date, end_date, format }])`
  - Lists user sessions joined to login/user info, with active/expired filtering and optional CSV export
  - `opts.status` = true (active, not expired) or false (revoked/expired)
  - `opts.last_seen` = string like `'24h'` to filter recently active sessions
  - Returns a promise resolving to `{ count, data }` (or a CSV string)
	```javascript
	tools.user.getExchangeUserSessions({ user_id: 42, status: true })
		.then(({ count, data }) => {
			/*
				{ count: 1, data: [ { id: 5, status: true, expiry_date: '...', login: { user_id: 42, User: { email: '...' } } } ] }
			*/
		});
	```

- `revokeExchangeUserSession(sessionId [, userId = null])`
  - Revokes (deactivates) a single session and removes its token from redis; optionally enforces the session belongs to `userId`
  - Returns a promise resolving to the updated session data (with `user_id`, token stripped)
	```javascript
	tools.user.revokeExchangeUserSession(5, 42)
		.then((session) => {
			/*
				{ id: 5, status: false, user_id: 42, ... }
			*/
		});
	```

- `findUserLatestLogin(user, status)`
  - Finds the user's most recent login (optionally filtered by status) if within the login-timeout window, else null
  - `user` = user object (uses `user.id`)
  - Returns a promise resolving to a login record or null
	```javascript
	tools.user.findUserLatestLogin({ id: 42 }, false)
		.then((login) => {
			/*
				{ id: 9001, user_id: 42, status: false, attempt: 2, ... }
			*/
		});
	```

- `createUserLogin(user, ip, device, domain, origin, referer, token, long_term, status [, headers])`
  - Records a login: registers a new login (and session if token+status) when needed, or increments the failed-attempt counter on an existing failed login within the timeout window
  - `long_term` = use long vs normal token expiry
  - `status` = whether login succeeded
  - Returns a promise resolving to the login record (or null)
	```javascript
	tools.user.createUserLogin(user, '1.2.3.4', 'Chrome', 'ex.com', 'https://ex.com', null, null, false, false)
		.then((login) => {
			/*
				{ id: 9001, user_id: 42, status: false, attempt: 1, ... }
			*/
		});
	```

- `getAllBalancesAdmin([opts = { user_id, currency, format, additionalHeaders }])`
  - Fetches network balances across users (or a single user), mapping network ids back to kit ids; supports CSV export
  - `opts.user_id` = restrict to one user (kit id)
  - `opts.format` = `'csv'` / `'all'`
  - Returns a promise resolving to balances `{ count, data }` (or a CSV string)
	```javascript
	tools.user.getAllBalancesAdmin({ user_id: 42, currency: 'usdt' })
		.then((balances) => {
			/*
				{ count: 1, data: [ { user_id: 42, network_id: 100, balance: 1000, currency: 'usdt' } ] }
			*/
		});
	```

- `deleteKitUser(userId [, sendEmail = true])`
  - Soft-deletes a user by appending `_deleted` to their email and deactivating them; revokes sessions; cannot delete admins
  - Returns a promise resolving to the updated user instance
	```javascript
	tools.user.deleteKitUser(42)
		.then((user) => {
			/*
				{ id: 42, email: 'user@example.com_deleted', activated: false }
			*/
		});
	```

- `restoreKitUser(userId)`
  - Restores a soft-deleted user by stripping the `_deleted` suffix and reactivating them
  - Returns a promise resolving to the updated user instance
	```javascript
	tools.user.restoreKitUser(42)
		.then((user) => {
			/*
				{ id: 42, email: 'user@example.com', activated: true }
			*/
		});
	```

- `getUserBalanceHistory([opts = { user_id, limit, page, orderBy, order, startDate, endDate, format }])`
  - Lists stored daily balance-history snapshots (only on fiat/boost/enterprise plans with the feature active); prepends a live snapshot when the range isn't single-day; supports CSV export
  - Returns a promise resolving to `{ count, data }` (or a CSV string)
	```javascript
	tools.user.getUserBalanceHistory({ user_id: 42, startDate: '2026-01-01', endDate: '2026-02-01' })
		.then((balances) => {
			/*
				{ count: 31, data: [ { user_id: 42, balance: { btc: {...} }, total: 12345.67, created_at: '...' } ] }
			*/
		});
	```

- `fetchUserProfitLossInfo(user_id [, opts = { period: 7 }])`
  - Computes cumulative profit/loss totals and percentages over multiple intervals (1d/7d/1m/3m/6m/1y) from balance history, trades, deposits and withdrawals; caches result in redis for an hour
  - `opts.period` = lookback window in days used to gather source data
  - Returns a promise resolving to a per-interval P/L map
	```javascript
	tools.user.fetchUserProfitLossInfo(42, { period: 30 })
		.then((results) => {
			/*
				{ '1d': { total: '12.50', totalPercentage: '0.20' }, '7d': {...}, '1m': {...} }
			*/
		});
	```

- `revokeAllUserSessions(userId [, excludedSessionId = null])`
  - Sets all of a user's active sessions to inactive and deletes their redis tokens
  - `excludedSessionId` = optionally keep one session active
  - Returns a promise resolving to `true`
	```javascript
	tools.user.revokeAllUserSessions(42)
		.then((ok) => {
			/* true */
		});
	```

- `changeKitUserEmail(userId, newEmail, auditInfo)`
  - Changes a user's email (cannot change admin or deleted-account emails), revokes sessions, audit-logs and alerts admin
  - `newEmail` = valid, non-duplicate email
  - Returns a promise resolving to the updated user instance
	```javascript
	tools.user.changeKitUserEmail(42, 'new@example.com', { userEmail: 'admin@ex.com', sessionId: 5, apiPath: '/admin/user/email', method: 'put' })
		.then((user) => {
			/*
				{ id: 42, email: 'new@example.com', ... }
			*/
		});
	```

- `storeVerificationCode(user, verification_code)`
  - Stores a signup verification code in redis (5-minute TTL) keyed to the user; fire-and-forget
  - Returns nothing meaningful (sets the redis key)
	```javascript
	tools.user.storeVerificationCode({ id: 42, email: 'user@example.com' }, '123456');
	```

- `signUpUser(email, password [, opts = {}], version)`
  - Registers a new user via email or phone (mutually exclusive), creating kit + network records, storing a verification code and sending signup verification; handles unverified resend and phone-signup synthetic accounts
  - `opts.phone_number` = E.164 phone (triggers SMS phone-signup flow)
  - `opts.referral` / `opts.meta` / `opts.email_verified` / `opts.google_id` = optional signup extras
  - `version` = code format version (`'v3'`/`'v4'` use numeric codes, else uuid)
  - Returns a promise resolving to the created/found user instance
	```javascript
	tools.user.signUpUser('user@example.com', 'Password123!', { referral: 'ABC123' }, 'v4')
		.then((user) => {
			/*
				{ id: 42, email: 'user@example.com', network_id: 100, verification_level: 1, ... }
			*/
		});
	```

- `requestUserSetEmail(kitUserId, newEmail [, domain])`
  - Starts the flow for a phone-signup synthetic user to set a real email: validates eligibility/uniqueness, stores a code in redis and emails it
  - Returns a promise resolving to `{ message: 'Verification code sent' }`
	```javascript
	tools.user.requestUserSetEmail(42, 'real@example.com')
		.then((res) => {
			/*
				{ message: 'Verification code sent' }
			*/
		});
	```

- `confirmUserSetEmail(kitUserId, code)`
  - Confirms the set-email code (timing-safe compare), assigns the new verified email, derives a username from it, clears the phone-signup meta and publishes an event
  - Returns a promise resolving to the omitted-field user object
	```javascript
	tools.user.confirmUserSetEmail(42, '123456')
		.then((user) => {
			/*
				{ id: 42, email: 'real@example.com', email_verified: true, username: 'real' }
			*/
		});
	```

- `isPhoneSignupSyntheticUser(user = {})`
  - Synchronously determines whether a user was created via phone signup (meta.phone_signup or `_sms` email suffix)
  - Returns a boolean (not a promise)
	```javascript
	tools.user.isPhoneSignupSyntheticUser({ email: '14155552671_sms' }); // true
	```

- `validateSmsVerificationEligibility(user [, action_type = 'signup'])`
  - Asserts a user is eligible for SMS verification for the given action; non-signup/reset/confirm actions require an already-verified phone
  - `action_type` = e.g. `'signup'`, `'reset_password'`, `'confirm_email'`
  - Returns a promise (resolves when eligible, rejects otherwise)
	```javascript
	tools.user.validateSmsVerificationEligibility(user, 'signup')
		.then(() => {
			/* eligible */
		});
	```

- `verifyUser(email, code [, domain])`
  - Verifies a signup code from redis, marks the user's email or phone (for synthetic phone signups) as verified, publishes an event and sends the welcome email (skipped for phone signups)
  - Returns a promise resolving to the verified user instance
	```javascript
	tools.user.verifyUser('user@example.com', '123456')
		.then((user) => {
			/*
				{ id: 42, email_verified: true, ... }
			*/
		});
	```

- `getAllAffiliations([query = {}])`
  - Thin wrapper running a raw sequelize `findAndCountAll` against the affiliation model with the given query
  - Returns a promise resolving to `{ count, rows }`
	```javascript
	tools.user.getAllAffiliations({ where: { referer_id: 42 } })
		.then(({ count, rows }) => {
			/*
				{ count: 5, rows: [ { user_id: 50, referer_id: 42, code: 'ABC123' } ] }
			*/
		});
	```

- `applyEarningRate(amount, earning_rate)`
  - Synchronously computes `amount * (earning_rate / 100)` using bignumber math
  - Returns a number (not a promise)
	```javascript
	tools.user.applyEarningRate(100, 20); // 20
	```

- `addAmounts(amount1, amount2)`
  - Synchronously adds two amounts using bignumber math
  - Returns a number (not a promise)
	```javascript
	tools.user.addAmounts(0.1, 0.2); // 0.3
	```

- `settleFees(user_id)`
  - Settles a referrer's accumulated unrealized referral fees: sums them, enforces a minimum, converts to native currency, transfers from the distributor account, and marks records realized (alerts admin on insufficient balance/errors)
  - Returns a promise (resolves on success, throws on failure with an obfuscated message)
	```javascript
	tools.user.settleFees(42)
		.then(() => {
			/* fees settled and transferred */
		});
	```

- `getUnrealizedReferral(user_id)`
  - Returns the summed unrealized (unsettled) referral fees for a referrer (supported plans + feature active only)
  - Returns a promise resolving to grouped records with summed `accumulated_fees`
	```javascript
	tools.user.getUnrealizedReferral(42)
		.then((records) => {
			/*
				[ { referer: 42, accumulated_fees: 123.45 } ]
			*/
		});
	```

- `getRealizedReferral([opts = { user_id, limit, page, order_by, order, start_date, end_date, format }])`
  - Lists realized (settled) referral history records with optional CSV export
  - `opts.user_id` = filter by referer id
  - Returns a promise resolving to `{ count, data }` (or a CSV string)
	```javascript
	tools.user.getRealizedReferral({ user_id: 42 })
		.then(({ count, data }) => {
			/*
				{ count: 3, data: [ { referer: 42, referee: 50, accumulated_fees: 12.3, status: true } ] }
			*/
		});
	```

- `fetchUserReferrals([opts = { user_id, limit, page, order_by, order, start_date, end_date, format }])`
  - Aggregates a referrer's referral history grouped by day (or by referee when `order_by === 'referee'`), with an overall total
  - Returns a promise resolving to `{ count, data, total? }`
	```javascript
	tools.user.fetchUserReferrals({ user_id: 42 })
		.then((result) => {
			/*
				{ count: 5, data: [ { date: '2026-06-01', accumulated_fees: 10 } ], total: 50 }
			*/
		});
	```

- `createUnrealizedReferralFees(currentTime)`
  - Cron-style routine that scans network trades since the last settlement, accumulates fees per affiliated referee, applies earning rates, converts to native currency and bulk-creates unrealized ReferralHistory records
  - `currentTime` = upper bound timestamp for the earning period window
  - Returns a promise resolving to the bulk-created records (or an error if caught)
	```javascript
	tools.user.createUnrealizedReferralFees(new Date().toISOString())
		.then((records) => {
			/*
				[ { referer: 42, referee: 50, coin: 'usdt', accumulated_fees: 1.23, status: false } ]
			*/
		});
	```

- `getUserReferralCodes([opts = { user_id, limit, page, order_by, order, start_date, end_date, format }])`
  - Lists a user's referral codes, attaching matching affiliations to each (non-CSV); supports CSV export
  - Returns a promise resolving to `{ count, data }` (each row has `affiliations`) or a CSV string
	```javascript
	tools.user.getUserReferralCodes({ user_id: 42 })
		.then(({ count, data }) => {
			/*
				{ count: 2, data: [ { code: 'ABC123', discount: 10, earning_rate: 20, affiliations: [...] } ] }
			*/
		});
	```

- `createUserReferralCode(data)`
  - Creates a referral code after validating discount/earning_rate (0-100, increments of 10), code length, combined cap vs exchange earning rate, and a max of 3 codes per non-admin user
  - `data` = `{ user_id, discount, earning_rate, code, is_admin }`
  - Returns a promise resolving to the created referral code record
	```javascript
	tools.user.createUserReferralCode({ user_id: 42, discount: 10, earning_rate: 20, code: 'ABC123', is_admin: false })
		.then((referralCode) => {
			/*
				{ id: 7, user_id: 42, code: 'ABC123', discount: 10, earning_rate: 20 }
			*/
		});
	```

- `fetchUserTradingVolume(user_id [, opts = { to, from }])`
  - Computes a user's trading volume converted to native currency; with `from`/`to` returns per-asset volume for that range, otherwise returns cached top-asset volumes for 1/7/30/90-day windows
  - Returns a promise resolving to `{ user_id, volume }` (and `volumeNative` in the windowed case)
	```javascript
	tools.user.fetchUserTradingVolume(42)
		.then((data) => {
			/*
				{ user_id: 42, volume: { '7': [ { btc: 1.2 } ], '30': [...] }, volumeNative: {...} }
			*/
		});
	```

- `updateUserAddresses(user_id, data)`
  - Replaces a user's crypto address book, validating required fields/allowed keys and rejecting duplicate labels or addresses; preserves existing `created_at` per label
  - `data` = `{ addresses: [{ address, network, label, currency }] }`
  - Returns a promise resolving to the user address book record
	```javascript
	tools.user.updateUserAddresses(42, { addresses: [{ address: 'bc1...', network: 'btc', label: 'cold', currency: 'btc' }] })
		.then((book) => {
			/*
				{ user_id: 42, addresses: [ { address: 'bc1...', label: 'cold', created_at: '...' } ] }
			*/
		});
	```

- `fetchUserAddressBook(user_id)`
  - Returns the user's saved address book (or an empty addresses list if none exists)
  - Returns a promise resolving to the address book record
	```javascript
	tools.user.fetchUserAddressBook(42)
		.then((book) => {
			/*
				{ user_id: 42, addresses: [...] }
			*/
		});
	```

- `getPaymentDetails(user_id [, opts = { limit, page, order_by, order, start_date, end_date, is_p2p, is_fiat_control, status }])`
  - Lists payment detail records, optionally filtered by user and flags
  - Returns a promise resolving to `{ count, data }`
	```javascript
	tools.user.getPaymentDetails(42, { is_p2p: true })
		.then(({ count, data }) => {
			/*
				{ count: 1, data: [ { id: 3, user_id: 42, name: 'Bank', details: {...}, status: 1 } ] }
			*/
		});
	```

- `createPaymentDetail(data)`
  - Creates a payment detail for a user and emails the admin (user id 1) for approval
  - `data` = `{ user_id, name, label, details, is_p2p, is_fiat_control, status }`
  - Returns a promise resolving to the created payment detail record
	```javascript
	tools.user.createPaymentDetail({ user_id: 42, name: 'My Bank', label: 'primary', details: { fields: [...] }, is_p2p: false, status: 1 })
		.then((paymentDetail) => {
			/*
				{ id: 3, user_id: 42, name: 'My Bank', status: 1 }
			*/
		});
	```

- `updatePaymentDetail(id, data [, isAdmin = false])`
  - Updates a payment detail (non-admins cannot change status and cannot edit an already-verified detail); emails the user when status becomes verified (3)
  - `data` = fields to update (must include `user_id` for the lookup)
  - Returns a promise resolving to the updated payment detail record
	```javascript
	tools.user.updatePaymentDetail(3, { user_id: 42, status: 3 }, true)
		.then((paymentDetail) => {
			/*
				{ id: 3, user_id: 42, status: 3 }
			*/
		});
	```

- `deletePaymentDetail(id, user_id)`
  - Deletes a user's payment detail by id
  - Returns a promise that resolves once destroyed (no value)
	```javascript
	tools.user.deletePaymentDetail(3, 42)
		.then(() => {
			/* deleted */
		});
	```

- `fetchUserAutoTrades(user_id [, opts = { limit, page, order_by, order, start_date, end_date, active }])`
  - Lists a user's auto-trade (DCA) configurations
  - `opts.active` = filter by active flag
  - Returns a promise resolving to `{ count, data }`
	```javascript
	tools.user.fetchUserAutoTrades(42)
		.then(({ count, data }) => {
			/*
				{ count: 1, data: [ { id: 1, spend_coin: 'usdt', buy_coin: 'btc', spend_amount: 50, frequency: 'weekly', active: true } ] }
			*/
		});
	```

- `createUserAutoTrade(user_id, { spend_coin, buy_coin, spend_amount, frequency, week_days, day_of_month, trade_hour, active, description }, ip)`
  - Creates an auto-trade config after validating coins, a matching quick-trade pair, schedule fields and (when active) sufficient balance; limited to 20 per user
  - `frequency` / `week_days` / `day_of_month` / `trade_hour` = schedule
  - Returns a promise resolving to the created auto-trade config
	```javascript
	tools.user.createUserAutoTrade(42, { spend_coin: 'usdt', buy_coin: 'btc', spend_amount: 50, frequency: 'weekly', week_days: [1], trade_hour: 9, active: true }, '1.2.3.4')
		.then((config) => {
			/*
				{ id: 1, user_id: 42, spend_coin: 'usdt', buy_coin: 'btc', spend_amount: 50, active: true }
			*/
		});
	```

- `updateUserAutoTrade(user_id, { id, spend_coin, buy_coin, spend_amount, frequency, week_days, day_of_month, trade_hour, active, description }, ip)`
  - Updates an existing auto-trade config (by id + user), revalidating coins/pair/schedule and (when active) balance
  - Returns a promise resolving to the updated auto-trade config
	```javascript
	tools.user.updateUserAutoTrade(42, { id: 1, spend_coin: 'usdt', buy_coin: 'btc', spend_amount: 100, active: false }, '1.2.3.4')
		.then((config) => {
			/*
				{ id: 1, spend_amount: 100, active: false, ... }
			*/
		});
	```

- `deleteUserAutoTrade(removed_ids, user_id)`
  - Deletes one or more of a user's auto-trade configs by id
  - `removed_ids` = id or array of ids
  - Returns a promise resolving to an array of destroy results
	```javascript
	tools.user.deleteUserAutoTrade([1, 2], 42)
		.then((results) => {
			/* [1, 1] */
		});
	```

- `getAnnouncements([opts = { limit, page, order_by, order, start_date, end_date, is_popup, is_navbar, is_dropdown }])`
  - Lists announcements with optional placement filters (popup/navbar/dropdown)
  - Returns a promise resolving to `{ count, data }`
	```javascript
	tools.user.getAnnouncements({ is_popup: true })
		.then(({ count, data }) => {
			/*
				{ count: 1, data: [ { id: 1, title: 'Maintenance', message: '...', type: 'info', is_popup: true } ] }
			*/
		});
	```

- `createAnnouncement({ title, message, type = 'info', user_id, end_date, start_date, is_popup, is_navbar, is_dropdown })`
  - Creates an announcement (fiat plan only), stored with `created_by = user_id`
  - Returns a promise resolving to the created announcement record
	```javascript
	tools.user.createAnnouncement({ title: 'Maintenance', message: 'Downtime tonight', type: 'warning', user_id: 1, is_popup: true })
		.then((announcement) => {
			/*
				{ id: 1, title: 'Maintenance', type: 'warning', created_by: 1 }
			*/
		});
	```

- `deleteAnnouncement(id)`
  - Deletes an announcement by id
  - Returns a promise resolving to `{ message: 'Success' }`
	```javascript
	tools.user.deleteAnnouncement(1)
		.then((res) => {
			/*
				{ message: 'Success' }
			*/
		});
	```

- `updateAnnouncement(id, { title, message, type, user_id, end_date, start_date, is_popup, is_navbar, is_dropdown })`
  - Updates an existing announcement, recording `updated_by = user_id`
  - Returns a promise resolving to the updated announcement record
	```javascript
	tools.user.updateAnnouncement(1, { title: 'Updated', message: 'New text', user_id: 1 })
		.then((announcement) => {
			/*
				{ id: 1, title: 'Updated', message: 'New text', updated_by: 1 }
			*/
		});
	```

- `confirmUserLogin(token)`
  - Confirms a pending (suspicious) login using a redis token, activating the matching login record if still within the timeout window
  - Returns a promise resolving to the updated login record
	```javascript
	tools.user.confirmUserLogin('confirm-token-abc')
		.then((login) => {
			/*
				{ id: 9001, status: true, ... }
			*/
		});
	```

- `findUserLastLogins(user, status)`
  - Returns up to the 10 most recent login records for a user, optionally filtered by status
  - `user` = user object (uses `user.id`)
  - Returns a promise resolving to an array of login records
	```javascript
	tools.user.findUserLastLogins({ id: 42 }, true)
		.then((logins) => {
			/*
				[ { id: 9001, user_id: 42, status: true, country: 'US' }, ... ]
			*/
		});
	```

- `freezeUserByCode(token)`
  - Freezes a user's account using a one-time freeze token stored in redis (resolves the user id then calls freezeUserById)
  - Returns a promise resolving to the frozen user instance
	```javascript
	tools.user.freezeUserByCode('freeze-token-abc')
		.then((user) => {
			/*
				{ id: 42, activated: false, ... }
			*/
		});
	```

- `createSuspiciousLogin(user, ip, device, country, domain, origin, referer, token, long_term)`
  - Records a suspicious (status=false) login for a new device/country, or increments the attempt counter if a matching recent suspicious login (last 5 min) already exists
  - Returns a promise resolving to the login record
	```javascript
	tools.user.createSuspiciousLogin(user, '1.2.3.4', 'Chrome', 'DE', 'ex.com', 'https://ex.com', null, jwt, false)
		.then((login) => {
			/*
				{ id: 9002, user_id: 42, status: false, country: 'DE', ... }
			*/
		});
	```

- `getExchangeUserRoles([opts = { limit, page, order_by, order, search, start_date, end_date }])`
  - Lists exchange operator role definitions (note: current implementation returns all roles regardless of the filter opts)
  - Returns a promise resolving to `{ count, data }`
	```javascript
	tools.user.getExchangeUserRoles()
		.then(({ count, data }) => {
			/*
				{ count: 2, data: [ { id: 1, role_name: 'admin', permissions: [...] } ] }
			*/
		});
	```

- `createExchangeUserRole({ name, description, rolePermissions, configs, user_id, otp_code, color, restrictions })`
  - Creates a custom operator role (fiat plan only); requires the acting admin's OTP, validates/normalizes route/config/secret permissions, and forbids the reserved name `user`
  - `rolePermissions` = array of `route:...` permission strings
  - `configs` = array of `config:...` / `secret:...` permission strings
  - Returns a promise resolving to the created role record
	```javascript
	tools.user.createExchangeUserRole({ name: 'Support', rolePermissions: ['route:user.get'], configs: [], user_id: 1, otp_code: '123456' })
		.then((role) => {
			/*
				{ id: 3, role_name: 'support', permissions: ['/admin/user:get'], configs: [] }
			*/
		});
	```

- `updateExchangeUserRole(roleId, { description, rolePermissions, configs, user_id, otp_code, color, restrictions })`
  - Updates a role's description/color/restrictions/permissions/configs (fiat plan only, OTP-protected); admin role cannot be updated; only changed fields are persisted
  - Returns a promise resolving to the updated role record
	```javascript
	tools.user.updateExchangeUserRole(3, { description: 'Support team', rolePermissions: ['route:user.get'], configs: [], user_id: 1, otp_code: '123456' })
		.then((role) => {
			/*
				{ id: 3, role_name: 'support', description: 'Support team', ... }
			*/
		});
	```

- `deleteExchangeUserRole(id, user_id, otp_code)`
  - Deletes a custom role (fiat plan only, OTP-protected); cannot delete the admin role or a role still assigned to users
  - Returns a promise resolving to `{ message: 'Role deleted successfully' }`
	```javascript
	tools.user.deleteExchangeUserRole(3, 1, '123456')
		.then((res) => {
			/*
				{ message: 'Role deleted successfully' }
			*/
		});
	```

- `verifyGoogleToken(token)`
  - Verifies a Google OAuth id_token against Google's tokeninfo endpoint, validating issuer, audience (kit's configured client_id), expiry and email_verified
  - `token` = Google id_token (JWT)
  - Returns a promise resolving to `{ email, name, picture, google_id }`
	```javascript
	tools.user.verifyGoogleToken(googleIdToken)
		.then((info) => {
			/*
				{ email: 'user@gmail.com', name: 'Jane Doe', picture: 'https://...', google_id: '1234567890' }
			*/
		});
	```

- `getUserSubaccounts(masterKitId [, { limit, page } = {}])`
  - Lists active subaccounts for a master user (master must not itself be a subaccount)
  - Returns a promise resolving to `{ count, data }` of subaccount summaries
	```javascript
	tools.user.getUserSubaccounts(42, { limit: 20 })
		.then(({ count, data }) => {
			/*
				{ count: 1, data: [ { id: 60, label: 'Trading Bot', email: '...', verification_level: 1, is_subaccount: true } ] }
			*/
		});
	```

- `createSubaccount(masterKitId, { email, password, virtual, label, color })`
  - Creates a subaccount under a master user (kit + network), linking them; `virtual` accounts use a synthetic email and skip the verification email, real ones send a signup email
  - `virtual` = create a virtual subaccount (no real email/password validation)
  - Returns a promise resolving to the omitted-field subaccount user object
	```javascript
	tools.user.createSubaccount(42, { email: 'sub@example.com', password: 'Password123!', label: 'Bot', color: '#fff' })
		.then((subUser) => {
			/*
				{ id: 60, email: 'sub@example.com', is_subaccount: true, verification_level: 1 }
			*/
		});
	```

- `transferBetweenMasterAndSub({ masterKitId, subKitId, currency, amount, direction = 'to_sub', description = 'Subaccount Transfer' })`
  - Transfers a currency amount between a master and its subaccount (relationship enforced)
  - `direction` = `'to_sub'` (master->sub) or otherwise sub->master
  - Returns a promise resolving to the transfer result
	```javascript
	tools.user.transferBetweenMasterAndSub({ masterKitId: 42, subKitId: 60, currency: 'usdt', amount: 100 })
		.then((result) => {
			/*
				{ ... transfer record ... }
			*/
		});
	```

- `deactivateSubaccount(masterKitId, subKitId)`
  - Soft-deletes a subaccount link after verifying zero balances; revokes the sub's sessions, soft-deletes the sub user, and emails the master
  - Returns a promise resolving to `true`
	```javascript
	tools.user.deactivateSubaccount(42, 60)
		.then((ok) => {
			/* true */
		});
	```

- `issueSubaccountToken({ masterKitId, subKitId, ip, headers = {} })`
  - Issues a JWT for an activated subaccount owned by the master user and registers a login (token marked `is_subaccount`)
  - Returns a promise resolving to the issued JWT string
	```javascript
	tools.user.issueSubaccountToken({ masterKitId: 42, subKitId: 60, ip: '1.2.3.4', headers: req.headers })
		.then((token) => {
			/* 'eyJhbGciOi...' */
		});
	```

- `createSharedaccount(mainKitId, { email, label })`
  - Links a main user (by kit id) to a shared user (by email) so the shared user can be granted access; rejects self/subaccount links and duplicates
  - Returns a promise resolving to the created sharedaccount link
	```javascript
	tools.user.createSharedaccount(42, { email: 'partner@example.com', label: 'Accountant' })
		.then((link) => {
			/*
				{ id: 5, main_id: 42, shared_id: 70, active: true, label: 'Accountant' }
			*/
		});
	```

- `getUserSharedaccounts(mainKitId [, { limit, page } = {}])`
  - Lists sharedaccount links owned by a main user (the people granted access to them)
  - Returns a promise resolving to `{ count, data }`
	```javascript
	tools.user.getUserSharedaccounts(42)
		.then(({ count, data }) => {
			/*
				{ count: 1, data: [ { id: 5, email: 'partner@example.com', label: 'Accountant', active: true } ] }
			*/
		});
	```

- `getUserAccessibleSharedaccounts(sharedKitId [, { limit, page } = {}])`
  - Lists sharedaccount links where the given user is the shared party (the accounts they can access)
  - Returns a promise resolving to `{ count, data }`
	```javascript
	tools.user.getUserAccessibleSharedaccounts(70)
		.then(({ count, data }) => {
			/*
				{ count: 1, data: [ { id: 5, email: 'main@example.com', label: 'Accountant', active: true } ] }
			*/
		});
	```

- `issueSharedaccountToken({ sharedKitId, sharedaccountId, ip, headers = {} })`
  - Issues a JWT for the main user via an active sharedaccount link (initiated by the shared user) and registers a login tagged with sharedaccount meta
  - Returns a promise resolving to the issued JWT string
	```javascript
	tools.user.issueSharedaccountToken({ sharedKitId: 70, sharedaccountId: 5, ip: '1.2.3.4', headers: req.headers })
		.then((token) => {
			/* 'eyJhbGciOi...' */
		});
	```

- `pauseSharedaccount(mainKitId, sharedaccountId)`
  - Pauses (deactivates) a sharedaccount link owned by the main user and revokes only the main user's sessions created via that link
  - Returns a promise resolving to `true`
	```javascript
	tools.user.pauseSharedaccount(42, 5)
		.then((ok) => {
			/* true */
		});
	```

- `deleteSharedaccount(mainKitId, sharedaccountId)`
  - Deletes a sharedaccount link owned by the main user, first revoking sessions created via that link
  - Returns a promise resolving to `true`
	```javascript
	tools.user.deleteSharedaccount(42, 5)
		.then((ok) => {
			/* true */
		});
	```

- `resumeSharedaccount(mainKitId, sharedaccountId)`
  - Reactivates a previously paused sharedaccount link (errors if already active)
  - Returns a promise resolving to `true`
	```javascript
	tools.user.resumeSharedaccount(42, 5)
		.then((ok) => {
			/* true */
		});
	```

#### Order functions

- `getAllExchangeOrders(symbol, side, status, open, limit, page, orderBy, order, startDate, endDate, format [, opts])`
  - Fetches all orders across the exchange, mapping each order's network id back to the kit user id.
  - `symbol` = trading pair to filter by (e.g. `xht-usdt`); rejected if not a subscribed pair
  - `open` = boolean filtering open vs. closed orders
  - `format` = `'csv'` for CSV output, otherwise paginated data
  - Returns a promise resolving to `{ count, data }` with each order's `created_by` set to the kit id and `network_id` added.
	```javascript
	tools.order.getAllExchangeOrders('xht-usdt', 'buy', 'pending', true, 50, 1, 'created_at', 'desc')
		.then((data) => {
			/*
				{
					count: 12,
					data: [
						{
							id: 'a1b2c3',
							symbol: 'xht-usdt',
							side: 'buy',
							size: 10,
							price: 0.25,
							status: 'pending',
							created_by: 42,
							network_id: 1057,
							User: { id: 42 }
						},
						{...}
					]
				}
			*/
		});
	```

- `createUserOrderByKitId(userKitId, symbol, side, size, type [, price] [, opts])`
  - Creates an order on the network for a user identified by kit id; non-subscribed symbols are flagged as OTC (`broker: 'otc'`).
  - `type` = `'market'`, `'limit'`, etc.; for market orders price is forced to 0
  - `price` = limit price (default 0)
  - `opts` = `{ stop, meta, additionalHeaders }`; stop price for stop orders, meta passed through
  - Returns a promise resolving to the created order object.
	```javascript
	tools.order.createUserOrderByKitId(42, 'xht-usdt', 'buy', 10, 'limit', 0.25)
		.then((data) => {
			/*
				{
					id: 'a1b2c3',
					symbol: 'xht-usdt',
					side: 'buy',
					size: 10,
					type: 'limit',
					price: 0.25,
					status: 'new',
					fee_structure: { maker: 0.1, taker: 0.1 }
				}
			*/
		});
	```

- `getUserQuickTrade(spending_currency, spending_amount, receiving_amount, receiving_currency, bearerToken, ip, opts [, req] [, user])`
  - Returns a quick-trade quote, resolving the configured quick-trade type (`broker`, `pro`/market, `network`, or chained trade) for the requested pair.
  - `spending_amount` / `receiving_amount` = supply one; the other is computed (must be non-negative)
  - `bearerToken` / `req` = used to authenticate the user (bearer token or HMAC api-key headers) so an execution token is issued
  - Returns a promise resolving to `{ spending_currency, receiving_currency, spending_amount, receiving_amount, type, token, expiry }`.
	```javascript
	tools.order.getUserQuickTrade('usdt', 100, null, 'xht', bearerToken, ip, opts, req)
		.then((data) => {
			/*
				{
					spending_currency: 'usdt',
					receiving_currency: 'xht',
					spending_amount: 100,
					receiving_amount: 396.5,
					type: 'broker',
					token: 'qt-9f3a...',
					expiry: '2026-06-06T12:00:30.000Z'
				}
			*/
		});
	```

- `createUserOrderByEmail(email, symbol, side, size, type [, price] [, opts])`
  - Creates an order on the network for a user looked up by email; non-subscribed symbols are flagged as OTC.
  - `opts` = `{ stop, meta, additionalHeaders }`
  - Returns a promise resolving to the created order object.
	```javascript
	tools.order.createUserOrderByEmail('user@example.com', 'xht-usdt', 'sell', 5, 'market')
		.then((data) => {
			/*
				{ id: 'a1b2c3', symbol: 'xht-usdt', side: 'sell', size: 5, type: 'market', status: 'filled' }
			*/
		});
	```

- `getUserOrderByKitId(userKitId, orderId [, opts])`
  - Fetches a single order for a user (resolved via kit id to network id) by order id.
  - Returns a promise resolving to the order object.
	```javascript
	tools.order.getUserOrderByKitId(42, 'a1b2c3')
		.then((data) => {
			/*
				{ id: 'a1b2c3', symbol: 'xht-usdt', side: 'buy', size: 10, price: 0.25, status: 'pending' }
			*/
		});
	```

- `getUserOrderByEmail(email, orderId [, opts])`
  - Fetches a single order for a user looked up by email.
  - Returns a promise resolving to the order object.
	```javascript
	tools.order.getUserOrderByEmail('user@example.com', 'a1b2c3')
		.then((data) => {
			/*
				{ id: 'a1b2c3', symbol: 'xht-usdt', side: 'buy', size: 10, price: 0.25, status: 'pending' }
			*/
		});
	```

- `cancelUserOrderByKitId(userKitId, orderId [, opts])`
  - Cancels a specific order for a user resolved via kit id.
  - Returns a promise resolving to the cancelled order object.
	```javascript
	tools.order.cancelUserOrderByKitId(42, 'a1b2c3')
		.then((data) => {
			/*
				{ id: 'a1b2c3', symbol: 'xht-usdt', side: 'buy', size: 10, status: 'canceled' }
			*/
		});
	```

- `cancelUserOrderByEmail(email, orderId [, opts])`
  - Cancels a specific order for a user looked up by email.
  - Returns a promise resolving to the cancelled order object.
	```javascript
	tools.order.cancelUserOrderByEmail('user@example.com', 'a1b2c3')
		.then((data) => {
			/*
				{ id: 'a1b2c3', symbol: 'xht-usdt', status: 'canceled' }
			*/
		});
	```

- `getAllUserOrdersByKitId(userKitId, symbol, side, status, open, limit, page, orderBy, order, startDate, endDate, format [, opts])`
  - Fetches all of a user's orders (resolved via kit id), mapping network ids back to kit ids.
  - `format` = `'csv'` returns a CSV string (throws if there is no data), otherwise paginated data
  - Returns a promise resolving to `{ count, data }` or a CSV string.
	```javascript
	tools.order.getAllUserOrdersByKitId(42, 'xht-usdt', 'buy', 'pending', true, 50, 1, 'created_at', 'desc')
		.then((data) => {
			/*
				{
					count: 3,
					data: [
						{ id: 'a1b2c3', symbol: 'xht-usdt', side: 'buy', size: 10, created_by: 42, network_id: 1057 },
						{...}
					]
				}
			*/
		});
	```

- `getAllUserOrdersByEmail(email, symbol, side, status, open, limit, page, orderBy, order, startDate, endDate [, opts])`
  - Fetches all of a user's orders looked up by email.
  - Returns a promise resolving to `{ count, data }`.
	```javascript
	tools.order.getAllUserOrdersByEmail('user@example.com', 'xht-usdt', 'buy', 'pending', true, 50, 1, 'created_at', 'desc')
		.then((data) => {
			/*
				{ count: 3, data: [ {...}, {...} ] }
			*/
		});
	```

- `cancelAllUserOrdersByKitId(userKitId, symbol [, opts])`
  - Cancels all of a user's orders for a given pair (resolved via kit id); requires a subscribed symbol.
  - Returns a promise resolving to an array of cancelled orders.
	```javascript
	tools.order.cancelAllUserOrdersByKitId(42, 'xht-usdt')
		.then((data) => {
			/*
				[ { id: 'a1b2c3', symbol: 'xht-usdt', status: 'canceled' }, {...} ]
			*/
		});
	```

- `cancelAllUserOrdersByEmail(email, symbol [, opts])`
  - Cancels all of a user's orders for a given pair, user looked up by email.
  - Returns a promise resolving to an array of cancelled orders.
	```javascript
	tools.order.cancelAllUserOrdersByEmail('user@example.com', 'xht-usdt')
		.then((data) => {
			/*
				[ { id: 'a1b2c3', symbol: 'xht-usdt', status: 'canceled' }, {...} ]
			*/
		});
	```

- `getAllTradesNetwork(symbol, limit, page, orderBy, order, startDate, endDate, format [, opts])`
  - Fetches all trades across the network, mapping maker/taker network ids back to kit ids.
  - `format` = truthy fetches full data (`'all'`); `'csv'` returns a CSV string
  - Returns a promise resolving to `{ count, data }` (each trade gains `maker_network_id` / `taker_network_id`) or a CSV string.
	```javascript
	tools.order.getAllTradesNetwork('xht-usdt', 50, 1, 'timestamp', 'desc')
		.then((data) => {
			/*
				{
					count: 120,
					data: [
						{
							id: 't1',
							symbol: 'xht-usdt',
							side: 'buy',
							size: 10,
							price: 0.25,
							maker_id: 42,
							taker_id: 17,
							maker_network_id: 1057,
							taker_network_id: 1042
						},
						{...}
					]
				}
			*/
		});
	```

- `getAllUserTradesByKitId(userKitId, symbol, limit, page, orderBy, order, startDate, endDate, format [, opts])`
  - Fetches all of a user's trades (resolved via kit id).
  - `format` = `'csv'` returns a CSV string (throws if empty), otherwise paginated data
  - Returns a promise resolving to `{ count, data }` or a CSV string.
	```javascript
	tools.order.getAllUserTradesByKitId(42, 'xht-usdt', 50, 1, 'timestamp', 'desc')
		.then((data) => {
			/*
				{
					count: 8,
					data: [ { id: 't1', symbol: 'xht-usdt', side: 'buy', size: 10, price: 0.25, fee: 0.025 }, {...} ]
				}
			*/
		});
	```

- `getAllUserTradesByNetworkId(networkId, symbol, limit, page, orderBy, order, startDate, endDate, format [, opts])`
  - Fetches all trades for a user by their network id.
  - `format` = `'csv'` returns a CSV string, otherwise paginated data
  - Returns a promise resolving to `{ count, data }` or a CSV string.
	```javascript
	tools.order.getAllUserTradesByNetworkId(1057, 'xht-usdt', 50, 1, 'timestamp', 'desc')
		.then((data) => {
			/*
				{ count: 8, data: [ { id: 't1', symbol: 'xht-usdt', side: 'buy', size: 10, price: 0.25 }, {...} ] }
			*/
		});
	```

- `getUserOrderByNetworkId(networkId, orderId [, opts])`
  - Fetches a single order directly by the user's network id.
  - Returns a promise resolving to the order object.
	```javascript
	tools.order.getUserOrderByNetworkId(1057, 'a1b2c3')
		.then((data) => {
			/*
				{ id: 'a1b2c3', symbol: 'xht-usdt', side: 'buy', size: 10, price: 0.25, status: 'pending' }
			*/
		});
	```

- `createUserOrderByNetworkId(networkId, symbol, side, size, type [, price] [, opts])`
  - Creates an order using the user's network id; computes fee data from the user's tier and discount.
  - `opts` = `{ stop, meta, additionalHeaders }`; non-subscribed symbols flagged as OTC
  - Returns a promise resolving to the created order object.
	```javascript
	tools.order.createUserOrderByNetworkId(1057, 'xht-usdt', 'buy', 10, 'limit', 0.25)
		.then((data) => {
			/*
				{ id: 'a1b2c3', symbol: 'xht-usdt', side: 'buy', size: 10, type: 'limit', price: 0.25, status: 'new' }
			*/
		});
	```

- `createOrderNetwork(networkId, symbol, side, size, type, price [, feeData] [, opts])`
  - Low-level order creation directly on the network with an explicit fee structure (no user lookup).
  - `feeData` = `{ fee_structure: { maker, taker } }` (defaults to `{}`)
  - Returns a promise resolving to the created order object.
	```javascript
	tools.order.createOrderNetwork(1057, 'xht-usdt', 'buy', 10, 'limit', 0.25, { fee_structure: { maker: 0.1, taker: 0.2 } })
		.then((data) => {
			/*
				{ id: 'a1b2c3', symbol: 'xht-usdt', side: 'buy', size: 10, price: 0.25, status: 'new' }
			*/
		});
	```

- `cancelUserOrderByNetworkId(networkId, orderId [, opts])`
  - Cancels a specific order directly by the user's network id.
  - Returns a promise resolving to the cancelled order object.
	```javascript
	tools.order.cancelUserOrderByNetworkId(1057, 'a1b2c3')
		.then((data) => {
			/*
				{ id: 'a1b2c3', symbol: 'xht-usdt', status: 'canceled' }
			*/
		});
	```

- `getAllUserOrdersByNetworkId(networkId, symbol, side, status, open, limit, page, orderBy, order, startDate, endDate [, opts])`
  - Fetches all of a user's orders directly by network id.
  - Returns a promise resolving to `{ count, data }`.
	```javascript
	tools.order.getAllUserOrdersByNetworkId(1057, 'xht-usdt', 'buy', 'pending', true, 50, 1, 'created_at', 'desc')
		.then((data) => {
			/*
				{ count: 3, data: [ {...}, {...} ] }
			*/
		});
	```

- `cancelAllUserOrdersByNetworkId(networkId, symbol [, opts])`
  - Cancels all of a user's orders for a given pair directly by network id.
  - Returns a promise resolving to an array of cancelled orders.
	```javascript
	tools.order.cancelAllUserOrdersByNetworkId(1057, 'xht-usdt')
		.then((data) => {
			/*
				[ { id: 'a1b2c3', symbol: 'xht-usdt', status: 'canceled' }, {...} ]
			*/
		});
	```

- `getGeneratedFees(startDate, endDate [, opts])`
  - Fetches the fees generated by the exchange within a date range.
  - Returns a promise resolving to per-coin generated fee totals.
	```javascript
	tools.order.getGeneratedFees('2026-01-01T00:00:00.000Z', '2026-06-01T00:00:00.000Z')
		.then((data) => {
			/*
				{ usdt: 1250.5, xht: 340.2, btc: 0.012 }
			*/
		});
	```

- `settleFees([opts])`
  - Settles outstanding fees; if `opts.user_id` (kit id) is provided it is resolved to a network id and only that user is settled.
  - `opts` = `{ user_id, additionalHeaders }`
  - Returns a promise resolving to the settlement result.
	```javascript
	tools.order.settleFees({ user_id: 42 })
		.then((data) => {
			/*
				{ message: 'Success' }
			*/
		});
	```

- `generateOrderFeeData(userTier, symbol [, opts])`
  - Synchronously builds the maker/taker fee structure for a tier and symbol, applying any discount and falling back to the reversed symbol or 0.1 defaults.
  - `userTier` = the user's verification level / tier id
  - `opts` = `{ discount }` discount percentage applied to the tier fees (floored at the exchange minimum fees)
  - Returns `{ fee_structure: { maker, taker } }` (not a promise).
	```javascript
	const feeData = tools.order.generateOrderFeeData(1, 'xht-usdt', { discount: 10 });
	/*
		{ fee_structure: { maker: 0.18, taker: 0.18 } }
	*/
	```

- `dustUserBalance(user_id, opts, { assets, spread, maker_id, quote })`
  - Converts ("dusts") a user's small balances (worth under 1 USDT) into the quote currency via broker trades against the maker account.
  - `assets` = array of coin symbols to consider
  - `spread` = percentage shaved off the quote price
  - `maker_id` = kit id of the maker/admin account taking the other side
  - `quote` = currency the dust is converted into
  - Returns a promise resolving to an array of trade results (or `{ error, symbol, ... }` entries for skipped/failed conversions).
	```javascript
	tools.order.dustUserBalance(42, opts, { assets: ['btc', 'eth'], spread: 1, maker_id: 1, quote: 'usdt' })
		.then((data) => {
			/*
				[
					{ id: 't1', symbol: 'btc-usdt', side: 'sell', size: 0.00001, price: 64000 },
					{ error: 'value is not less than 1 usdt', symbol: 'eth-usdt' }
				]
			*/
		});
	```

- `executeUserOrder(user_id, opts, token, req)`
  - Executes a previously quoted quick trade using its Redis-stored token, dispatching by type (`market`, `broker`, `network`, or chained trade) and deleting the token afterward.
  - `token` = quote token issued by `getUserQuickTrade`; throws `TOKEN_EXPIRED` if missing
  - Returns a promise resolving to the executed order/trade with `type` attached.
	```javascript
	tools.order.executeUserOrder(42, opts, 'qt-9f3a...', req)
		.then((data) => {
			/*
				{
					id: 'a1b2c3',
					symbol: 'xht-usdt',
					side: 'buy',
					size: 396.5,
					price: 0.25,
					type: 'broker'
				}
			*/
		});
	```

- `dustPriceEstimate(user_id, opts, { assets, spread, maker_id, quote })`
  - Estimates (without executing) which of a user's sub-1-USDT balances would be dusted and the resulting order sizes/prices.
  - `assets`, `spread`, `maker_id`, `quote` = same meaning as `dustUserBalance`
  - Returns a promise resolving to an array of estimated conversions.
	```javascript
	tools.order.dustPriceEstimate(42, opts, { assets: ['btc', 'eth'], spread: 1, maker_id: 1, quote: 'usdt' })
		.then((data) => {
			/*
				[
					{ symbol: 'btc-usdt', side: 'sell', size: 0.00001, price: 63360, quoteSize: 0.6336 }
				]
			*/
		});
	```

- `updateQuickTradeConfig({ symbol, type, active }, auditInfo)`
  - Updates a quick-trade config row's `type` and `active` flag and writes an audit log; throws if the config is not found.
  - `type` = quick-trade type (`broker`, `pro`, `network`)
  - `auditInfo` = `{ userEmail, sessionId, apiPath, method }` used for the audit log
  - Returns a promise resolving to the updated quick-trade record.
	```javascript
	tools.order.updateQuickTradeConfig({ symbol: 'xht-usdt', type: 'pro', active: true }, auditInfo)
		.then((data) => {
			/*
				{ symbol: 'xht-usdt', type: 'pro', active: true }
			*/
		});
	```

- `createTrade(order [, opts])`
  - Creates a broker trade directly between a maker and taker (both by kit id) with explicit fees.
  - `order` = `{ symbol, side, price, size, maker_id, taker_id, maker_fee, taker_fee }`
  - Returns a promise resolving to the created trade object.
	```javascript
	tools.order.createTrade({ symbol: 'xht-usdt', side: 'buy', price: 0.25, size: 10, maker_id: 1, taker_id: 42, maker_fee: 0, taker_fee: 0.1 })
		.then((data) => {
			/*
				{ id: 't1', symbol: 'xht-usdt', side: 'buy', price: 0.25, size: 10 }
			*/
		});
	```

- `getUserChainTradeQuote(bearerToken, symbol, size, ip, opts [, req] [, id] [, network_id] [, noSpread])`
  - Builds a multi-hop ("chain") trade quote between two assets by finding the shortest conversion path across quick trades, applying spread and balance checks, and issuing an execution token.
  - `symbol` = `from-to` pair to convert across (requires `chain_trade_config.active`)
  - `size` = amount of the base asset to convert (validated against coin minimums)
  - `id` / `network_id` = used to identify the user when no bearer token is supplied (e.g. for source/middleman accounts)
  - `noSpread` = skip applying the configured spread on the final leg
  - Returns a promise resolving to `{ token, quote_amount }`.
	```javascript
	tools.order.getUserChainTradeQuote(bearerToken, 'btc-xht', 0.01, ip, opts, req)
		.then((data) => {
			/*
				{ token: 'a9f3...', quote_amount: 2520.4 }
			*/
		});
	```

- `executeUserChainTrade(user_id, userToken, opts, req)`
  - Executes a chain-trade quote: runs the underlying leg trades through a middleman (source) account, settles the final broker trade with the user, and rebalances the source account.
  - `userToken` = chain-trade token from `getUserChainTradeQuote`; throws `TOKEN_EXPIRED` if missing
  - Returns a promise resolving to the final broker trade between source account and user.
	```javascript
	tools.order.executeUserChainTrade(42, 'a9f3...', opts, req)
		.then((data) => {
			/*
				{ id: 't9', symbol: 'btc-xht', side: 'sell', size: 0.01, price: 252040 }
			*/
		});
	```

- `findConversionRate(startCurrency, endCurrency, rates [, visited] [, initialAmount])`
  - Recursively finds the shortest conversion path between two currencies through a map of available pair rates.
  - `rates` = object keyed by `from-to` with `{ type, active, price, token }` values
  - `visited` = Set of already-visited currencies (used internally for recursion)
  - `initialAmount` = starting amount to propagate through the path to compute `totalRate`
  - Returns `{ path, totalRate, trades }` (synchronously) or `null` if no path exists.
	```javascript
	const result = tools.order.findConversionRate('btc', 'xht', rates, new Set(), 0.01);
	/*
		{
			path: ['btc', 'usdt', 'xht'],
			totalRate: 2520.4,
			trades: [
				{ symbol: 'btc-usdt', type: 'broker', side: 'sell', size: 0.01, price: 64000, token: null },
				{ symbol: 'usdt-xht', type: 'pro', side: 'buy', size: 2520.4, price: 0.254, token: null }
			]
		}
	*/
	```

- `createMarginTransferByKitId(userKitId, balance_symbol, balance_amount, margin_to_spot [, opts])`
  - Transfers balance between a user's spot and margin wallets on the network (by kit id).
  - `balance_symbol` = coin being transferred
  - `margin_to_spot` = boolean direction (true = margin to spot, false = spot to margin)
  - Returns a promise resolving to the transfer result.
	```javascript
	tools.order.createMarginTransferByKitId(42, 'usdt', 100, false)
		.then((data) => {
			/*
				{ message: 'Success', symbol: 'usdt', amount: 100 }
			*/
		});
	```

- `closeMarginPositionByKitId(userKitId, target_asset, position_id [, opts])`
  - Closes an open margin position for a user (by kit id).
  - `target_asset` = asset to settle the closed position into
  - `position_id` = id of the position to close
  - Returns a promise resolving to the close-position result.
	```javascript
	tools.order.closeMarginPositionByKitId(42, 'usdt', 'pos-123')
		.then((data) => {
			/*
				{ id: 'pos-123', status: 'closed', realized_pnl: 12.4 }
			*/
		});
	```

- `getUserMarginPositionByKitId(userKitId [, opts])`
  - Fetches a user's open margin positions (by kit id).
  - Returns a promise resolving to the user's positions.
	```javascript
	tools.order.getUserMarginPositionByKitId(42)
		.then((data) => {
			/*
				{ count: 1, data: [ { id: 'pos-123', symbol: 'btc-usdt', size: 0.5, side: 'long' } ] }
			*/
		});
	```

- `matchUserOrderByKitId(userKitId, orderId, symbol [, size] [, opts])`
  - Matches (fills against the book) a user's existing order on the network, using the user's tier/discount fee structure.
  - `symbol` = pair used to derive the fee structure
  - `size` = optional partial size to match (default null = full)
  - Returns a promise resolving to the matched order/trade result.
	```javascript
	tools.order.matchUserOrderByKitId(42, 'a1b2c3', 'xht-usdt', 5)
		.then((data) => {
			/*
				{ id: 'a1b2c3', symbol: 'xht-usdt', side: 'buy', filled: 5, status: 'pfilled' }
			*/
		});
	```

- `matchUserOrderByNetworkId(networkId, orderId, symbol [, size] [, opts])`
  - Matches a user's existing order on the network by network id, using the user's tier/discount fee structure.
  - `symbol` = pair used to derive the fee structure (rejected if not subscribed)
  - `size` = optional partial size to match (default null = full)
  - Returns a promise resolving to the matched order/trade result.
	```javascript
	tools.order.matchUserOrderByNetworkId(1057, 'a1b2c3', 'xht-usdt', 5)
		.then((data) => {
			/*
				{ id: 'a1b2c3', symbol: 'xht-usdt', side: 'buy', filled: 5, status: 'pfilled' }
			*/
		});
	```

#### Wallet functions

- `sendRequestWithdrawalEmail(user_id, address, amount, currency, version [, opts])`
  - Verifies the user's OTP, validates the withdrawal, and emails/sends a withdrawal confirmation token (also freezing-account link).
  - `user_id` = kit id of the requesting user
  - `address` = destination address (or email for internal `email` network)
  - `currency` = coin symbol
  - `version` = token format; `v4` = 6-digit numeric code, `v3` = `XX-NNNNN` code, otherwise a long hex/transaction_id token
  - `opts` = `{ network, otpCode, fee, fee_coin, skipValidate, ip, domain, verification_method }`
  - Returns a promise resolving to the stored request data object
	```javascript
	tools.wallet.sendRequestWithdrawalEmail(1, '0xabc...', 0.5, 'eth', 'v4', { network: 'eth', otpCode: '123456', ip: '1.2.3.4', domain: 'https://exchange.com' })
		.then((data) => {
			/*
				{
					user_id: 1,
					email: 'user@example.com',
					amount: 0.5,
					fee: 0.001,
					fee_coin: 'eth',
					transaction_id: '8c1f...',
					address: '0xabc...',
					currency: 'eth',
					network: 'eth',
					timestamp: 1717689600000
				}
			*/
		});
	```

- `validateWithdrawal(user, address, amount, currency [, network])`
  - Validates a withdrawal against coin config, network overrides, address validity, blacklist, verification level, 2FA, balance, and tier limits; computes the fee.
  - `user` = full user object (must have `network_id`, `verification_level`)
  - `network` = blockchain network key (e.g. `eth`), or `email`/`fiat` for internal/fiat transfers
  - Returns a promise resolving to `{ fee, fee_coin, fee_markup? }`
	```javascript
	tools.wallet.validateWithdrawal(user, '0xabc...', 0.5, 'eth', 'eth')
		.then((data) => {
			/*
				{ fee: 0.001, fee_coin: 'eth', fee_markup: 0.0005 }
			*/
		});
	```

- `validateWithdrawalToken(token)`
  - Looks up a stored withdrawal request token, deletes it, and rejects if missing or expired.
  - `token` = confirmation token from the withdrawal request email
  - Returns a promise resolving to the stored withdrawal request data
	```javascript
	tools.wallet.validateWithdrawalToken('123456')
		.then((withdrawal) => {
			/*
				{
					user_id: 1,
					email: 'user@example.com',
					amount: 0.5,
					fee: 0.001,
					fee_coin: 'eth',
					address: '0xabc...',
					currency: 'eth',
					network: 'eth',
					timestamp: 1717689600000
				}
			*/
		});
	```

- `cancelUserWithdrawalByKitId(userId, withdrawalId [, opts])`
  - Cancels a pending withdrawal for a user identified by kit id (resolves to the network id first).
  - `userId` = kit id
  - `withdrawalId` = id of the pending withdrawal to cancel
  - `opts` = `{ additionalHeaders }`
  - Returns a promise resolving to the cancelled withdrawal record
	```javascript
	tools.wallet.cancelUserWithdrawalByKitId(1, 42)
		.then((data) => {
			/*
				{ id: 42, amount: 0.5, currency: 'eth', status: false, dismissed: true, ... }
			*/
		});
	```

- `checkTransaction(currency, transactionId, address, network [, isTestnet] [, opts])`
  - Checks the status of an on-chain transaction via the network library.
  - `currency` = coin symbol
  - `transactionId` = on-chain transaction hash
  - `address` = address involved in the transaction
  - `network` = blockchain network key
  - `isTestnet` = whether to check on testnet (default `false`)
  - `opts` = `{ additionalHeaders }`
  - Returns a promise resolving to the transaction check result
	```javascript
	tools.wallet.checkTransaction('eth', '0xtxhash...', '0xabc...', 'eth')
		.then((data) => {
			/*
				{ message: 'Transaction processed', ... }
			*/
		});
	```

- `performWithdrawal(userId, address, currency, amount [, opts])`
  - Performs a withdrawal for a kit-id user after confirming registration and that the address is not blacklisted.
  - `userId` = kit id
  - `opts` = `{ network, fee_markup, additionalHeaders }`
  - Returns a promise resolving to the created withdrawal record
	```javascript
	tools.wallet.performWithdrawal(1, '0xabc...', 'eth', 0.5, { network: 'eth' })
		.then((data) => {
			/*
				{ transaction_id: '8c1f...', message: 'Withdrawal request is in the queue' }
			*/
		});
	```

- `performDirectWithdrawal(userId, address, currency, amount [, opts])`
  - Validates then directly performs a withdrawal for a kit-id user (no email confirmation step).
  - `userId` = kit id
  - `opts` = `{ network, additionalHeaders }`
  - Returns a promise resolving to the created withdrawal record
	```javascript
	tools.wallet.performDirectWithdrawal(1, '0xabc...', 'eth', 0.5, { network: 'eth' })
		.then((data) => {
			/*
				{ transaction_id: '8c1f...', message: 'Withdrawal request is in the queue' }
			*/
		});
	```

- `transferAssetByKitIds(senderId, receiverId, currency, amount [, description] [, email] [, opts])`
  - Transfers an asset between two users identified by kit ids.
  - `senderId` / `receiverId` = kit ids (mapped to network ids internally)
  - `description` = transfer note (default `'Admin Transfer'`)
  - `email` = whether to email both parties (default `true`)
  - `opts` = `{ category, transactionId, additionalHeaders }`
  - Returns a promise resolving to `{ sender, receiver }` transaction records
	```javascript
	tools.wallet.transferAssetByKitIds(1, 2, 'xht', 100, 'Bonus', true)
		.then((data) => {
			/*
				{ sender: {...}, receiver: {...} }
			*/
		});
	```

- `getUserBalanceByKitId(userKitId [, opts])`
  - Fetches a user's balance by kit id, with the kit id attached to the result.
  - `opts` = `{ additionalHeaders }`
  - Returns a promise resolving to the balance object
	```javascript
	tools.wallet.getUserBalanceByKitId(1)
		.then((data) => {
			/*
				{
					user_id: 1,
					eth_balance: 1.5,
					eth_available: 1.4,
					xht_balance: 100,
					xht_available: 100,
					updated_at: '2026-06-06T00:00:00.000Z'
				}
			*/
		});
	```

- `getUserDepositsByKitId(kitId, currency, status, dismissed, rejected, processing, waiting, limit, page, orderBy, order, startDate, endDate, transactionId, address, description, format [, opts])`
  - Lists a user's deposits by kit id (or exchange-wide if `kitId` is falsy); maps network ids back to kit ids.
  - `format` = `'csv'` returns a CSV string, `'all'` returns all rows, otherwise paginated
  - `opts` = `{ onhold, additionalHeaders }`
  - Returns a promise resolving to `{ count, data }` (or a CSV string)
	```javascript
	tools.wallet.getUserDepositsByKitId(1, 'eth', true, false, false, false, false, 50, 1, 'created_at', 'desc', null, null, null, null, null, null)
		.then((data) => {
			/*
				{ count: 3, data: [ { user_id: 1, network_id: 'abc', currency: 'eth', amount: 0.5, status: true, ... } ] }
			*/
		});
	```

- `getUserWithdrawalsByKitId(kitId, currency, status, dismissed, rejected, processing, waiting, limit, page, orderBy, order, startDate, endDate, transactionId, address, description, format [, opts])`
  - Lists a user's withdrawals by kit id (or exchange-wide if `kitId` is falsy); maps network ids back to kit ids.
  - `format` = `'csv'` returns a CSV string, `'all'` returns all rows, otherwise paginated
  - `opts` = `{ onhold, additionalHeaders }`
  - Returns a promise resolving to `{ count, data }` (or a CSV string)
	```javascript
	tools.wallet.getUserWithdrawalsByKitId(1, 'eth', true, false, false, false, false, 50, 1, 'created_at', 'desc', null, null, null, null, null, null)
		.then((data) => {
			/*
				{ count: 2, data: [ { user_id: 1, network_id: 'abc', currency: 'eth', amount: 0.5, status: true, ... } ] }
			*/
		});
	```

- `performWithdrawalNetwork(networkId, address, currency, amount [, opts])`
  - Performs a withdrawal for a user identified by network id, enforcing the address blacklist first.
  - `networkId` = network user id
  - `opts` = `{ network, additionalHeaders }`
  - Returns a promise resolving to the created withdrawal record
	```javascript
	tools.wallet.performWithdrawalNetwork('abc123', '0xabc...', 'eth', 0.5, { network: 'eth' })
		.then((data) => {
			/*
				{ transaction_id: '8c1f...', message: 'Withdrawal request is in the queue' }
			*/
		});
	```

- `cancelUserWithdrawalByNetworkId(networkId, withdrawalId [, opts])`
  - Cancels a pending withdrawal for a user identified by network id.
  - `opts` = `{ additionalHeaders }`
  - Returns a promise resolving to the cancelled withdrawal record
	```javascript
	tools.wallet.cancelUserWithdrawalByNetworkId('abc123', 42)
		.then((data) => {
			/*
				{ id: 42, amount: 0.5, currency: 'eth', dismissed: true, ... }
			*/
		});
	```

- `getExchangeDeposits(currency, status, dismissed, rejected, processing, waiting, limit, page, orderBy, order, startDate, endDate, transactionId, address, format [, opts])`
  - Lists all exchange deposits, mapping network ids back to kit ids.
  - `format` = `'csv'`/`'all'`/paginated
  - `opts` = `{ onhold, additionalHeaders }`
  - Returns a promise resolving to `{ count, data }`
	```javascript
	tools.wallet.getExchangeDeposits('eth', true, false, false, false, false, 50, 1, 'created_at', 'desc', null, null, null, null, null)
		.then((data) => {
			/*
				{ count: 120, data: [ { user_id: 1, network_id: 'abc', currency: 'eth', amount: 0.5, ... } ] }
			*/
		});
	```

- `getExchangeWithdrawals(currency, status, dismissed, rejected, processing, waiting, limit, page, orderBy, order, startDate, endDate, transactionId, address, format [, opts])`
  - Lists all exchange withdrawals, mapping network ids back to kit ids.
  - `format` = `'csv'`/`'all'`/paginated
  - `opts` = `{ onhold, additionalHeaders }`
  - Returns a promise resolving to `{ count, data }`
	```javascript
	tools.wallet.getExchangeWithdrawals('eth', true, false, false, false, false, 50, 1, 'created_at', 'desc', null, null, null, null, null)
		.then((data) => {
			/*
				{ count: 80, data: [ { user_id: 1, network_id: 'abc', currency: 'eth', amount: 0.5, ... } ] }
			*/
		});
	```

- `getUserBalanceByNetworkId(networkId [, opts])`
  - Fetches a user's balance by network id.
  - `opts` = `{ additionalHeaders }`
  - Returns a promise resolving to the balance object
	```javascript
	tools.wallet.getUserBalanceByNetworkId('abc123')
		.then((data) => {
			/*
				{ eth_balance: 1.5, eth_available: 1.4, updated_at: '2026-06-06T00:00:00.000Z' }
			*/
		});
	```

- `transferAssetByNetworkIds(senderId, receiverId, currency, amount [, description] [, email] [, opts])`
  - Transfers an asset between two users identified by network ids.
  - `description` = transfer note (default `'Admin Transfer'`)
  - `email` = whether to email both parties (default `true`)
  - `opts` = `{ transactionId, additionalHeaders }`
  - Returns a promise resolving to `{ sender, receiver }` transaction records
	```javascript
	tools.wallet.transferAssetByNetworkIds('abc', 'def', 'xht', 100, 'Bonus', true)
		.then((data) => {
			/*
				{ sender: {...}, receiver: {...} }
			*/
		});
	```

- `mintAssetByKitId(kitId, currency, amount [, opts])`
  - Mints (credits) an asset to a user identified by kit id.
  - `opts` = `{ description, network, transactionId, status, email, fee, address, dismissed, rejected, processing, waiting, onhold, additionalHeaders }`
  - Returns a promise resolving to the mint (deposit) record
	```javascript
	tools.wallet.mintAssetByKitId(1, 'eth', 0.5, { description: 'Manual credit', status: true })
		.then((data) => {
			/*
				{ transaction_id: 'm-8c1f...', currency: 'eth', amount: 0.5, status: true, ... }
			*/
		});
	```

- `mintAssetByNetworkId(networkId, currency, amount [, opts])`
  - Mints (credits) an asset to a user identified by network id.
  - `opts` = same shape as `mintAssetByKitId`
  - Returns a promise resolving to the mint (deposit) record
	```javascript
	tools.wallet.mintAssetByNetworkId('abc123', 'eth', 0.5, { status: true })
		.then((data) => {
			/*
				{ transaction_id: 'm-8c1f...', currency: 'eth', amount: 0.5, status: true, ... }
			*/
		});
	```

- `burnAssetByKitId(kitId, currency, amount [, opts])`
  - Burns (debits) an asset from a user identified by kit id.
  - `opts` = `{ description, network, transactionId, status, email, fee, address, dismissed, rejected, processing, waiting, onhold, additionalHeaders }`
  - Returns a promise resolving to the burn (withdrawal) record
	```javascript
	tools.wallet.burnAssetByKitId(1, 'eth', 0.5, { description: 'Manual debit', status: true })
		.then((data) => {
			/*
				{ transaction_id: 'b-8c1f...', currency: 'eth', amount: 0.5, status: true, ... }
			*/
		});
	```

- `burnAssetByNetworkId(networkId, currency, amount [, opts])`
  - Burns (debits) an asset from a user identified by network id.
  - `opts` = same shape as `burnAssetByKitId`
  - Returns a promise resolving to the burn (withdrawal) record
	```javascript
	tools.wallet.burnAssetByNetworkId('abc123', 'eth', 0.5, { status: true })
		.then((data) => {
			/*
				{ transaction_id: 'b-8c1f...', currency: 'eth', amount: 0.5, status: true, ... }
			*/
		});
	```

- `getKitBalance([opts])`
  - Fetches the exchange (kit) account's aggregate balance.
  - `opts` = `{ additionalHeaders }`
  - Returns a promise resolving to the balance object
	```javascript
	tools.wallet.getKitBalance()
		.then((data) => {
			/*
				{ eth_balance: 100, eth_available: 95, xht_balance: 5000, ... }
			*/
		});
	```

- `updatePendingMint(transactionId [, opts])`
  - Updates a pending mint transaction (e.g. confirm/reject/dismiss).
  - `transactionId` = id of the pending mint
  - `opts` = `{ status, dismissed, rejected, processing, waiting, onhold, updatedTransactionId, email, updatedDescription, additionalHeaders }`
  - Returns a promise resolving to the updated mint record
	```javascript
	tools.wallet.updatePendingMint('m-8c1f...', { status: true })
		.then((data) => {
			/*
				{ transaction_id: 'm-8c1f...', status: true, processing: false, ... }
			*/
		});
	```

- `updatePendingBurn(transactionId [, opts])`
  - Updates a pending burn transaction (e.g. confirm/reject/dismiss).
  - `transactionId` = id of the pending burn
  - `opts` = `{ status, dismissed, rejected, processing, waiting, onhold, updatedTransactionId, email, updatedDescription, additionalHeaders }`
  - Returns a promise resolving to the updated burn record
	```javascript
	tools.wallet.updatePendingBurn('b-8c1f...', { rejected: true })
		.then((data) => {
			/*
				{ transaction_id: 'b-8c1f...', rejected: true, processing: false, ... }
			*/
		});
	```

- `isValidAddress(currency, address, network)`
  - Synchronously validates a crypto address for the given currency/network (some currencies like `etn`/`ton`/`sui` skip validation and return `true`).
  - `currency` = coin symbol
  - `address` = address to validate (memo/tag-style addresses are split on `:`)
  - `network` = network key (`eth`, `trx`, `xlm`, `bnb`, etc.)
  - Returns a boolean (not a promise)
	```javascript
	const valid = tools.wallet.isValidAddress('eth', '0xabc...', 'eth');
	/*
		true
	*/
	```

- `validateDepositEnabled(currency [, network])`
  - Synchronously throws if the coin is unsubscribed, deposits are disabled, or the network is overridden to disallow deposits; otherwise returns nothing.
  - `network` = optional network key to check network-level overrides
  - Returns `undefined` (throws on failure)
	```javascript
	tools.wallet.validateDepositEnabled('eth', 'eth');
	/*
		(no return value; throws if deposit is disabled)
	*/
	```

- `validateDeposit(user, amount, currency [, network])`
  - Validates a deposit (deposit enabled, positive amount, user registered, verification level) and computes the deposit fee.
  - `user` = full user object
  - `network` = optional network key
  - Returns a promise resolving to `{ fee, fee_coin }`
	```javascript
	tools.wallet.validateDeposit(user, 0.5, 'eth', 'eth')
		.then((data) => {
			/*
				{ fee: 0, fee_coin: 'eth' }
			*/
		});
	```

- `getWallets(userId, currency, network, address, isValid, limit, page, orderBy, order, format, startDate, endDate [, opts])`
  - Lists exchange wallets (addresses), optionally filtered by user; maps network ids back to kit ids.
  - `userId` = kit id filter (or falsy for all users)
  - `isValid` = filter by address validity
  - `format` = `'csv'` returns a CSV string, `'all'`/paginated otherwise
  - `opts` = `{ additionalHeaders }`
  - Returns a promise resolving to `{ count, data }` (or a CSV string)
	```javascript
	tools.wallet.getWallets(1, 'eth', 'eth', null, true, 50, 1, 'created_at', 'desc', null, null, null)
		.then((data) => {
			/*
				{ count: 2, data: [ { user_id: 1, network_id: 'abc', currency: 'eth', address: '0xabc...', is_valid: true } ] }
			*/
		});
	```

- `calculateWithdrawalMax(user_id, currency, selectedNetwork)`
  - Computes the maximum withdrawable amount for a user, accounting for available balance, fees/markups, and daily/monthly tier limits.
  - `user_id` = kit id
  - `selectedNetwork` = network key the withdrawal would use (affects fee/markup)
  - Returns a promise resolving to `{ amount }`
	```javascript
	tools.wallet.calculateWithdrawalMax(1, 'eth', 'eth')
		.then((data) => {
			/*
				{ amount: 1.399 }
			*/
		});
	```

- `getUserWithdrawalCode()`
  - Returns the most recent (latest-timestamp) pending withdrawal request token stored in Redis.
  - Returns a promise resolving to the token string, or `null` if none exist
	```javascript
	tools.wallet.getUserWithdrawalCode()
		.then((token) => {
			/*
				'123456'
			*/
		});
	```

- `createUserWalletByNetworkId(networkId, currency, address [, opts])`
  - Creates/registers a wallet address for a user identified by network id.
  - `opts` = `{ network, skipValidate, additionalHeaders }`
  - Returns a promise resolving to the created wallet record
	```javascript
	tools.wallet.createUserWalletByNetworkId('abc123', 'eth', '0xabc...', { network: 'eth' })
		.then((data) => {
			/*
				{ user_id: 'abc123', currency: 'eth', address: '0xabc...', network: 'eth', is_valid: true }
			*/
		});
	```

- `createUserWalletByKitId(kitId, currency, address [, opts])`
  - Creates/registers a wallet address for a user identified by kit id (resolves the network id first).
  - `opts` = `{ network, skipValidate, additionalHeaders }`
  - Returns a promise resolving to the created wallet record
	```javascript
	tools.wallet.createUserWalletByKitId(1, 'eth', '0xabc...', { network: 'eth' })
		.then((data) => {
			/*
				{ user_id: 'abc123', currency: 'eth', address: '0xabc...', network: 'eth', is_valid: true }
			*/
		});
	```

##### Blacklisted address functions

These functions live in the blockchain module but are exposed through the `wallet` namespace.

- `normalizeAddress(address [, network])`
  - Normalizes an address for storage/comparison: trims whitespace, strips the `:tag`/`:memo` suffix for tag-based networks (XRP/XLM), and lowercases EVM-family addresses; case-sensitive chains (BTC, TRON) are preserved as-is.
  - `address` = the raw address string to normalize
  - `network` = optional network code; controls tag-suffix stripping (e.g. `xrp`, `xlm`)
  - Returns a string (the normalized address)
	```javascript
	const normalized = tools.wallet.normalizeAddress('0xAbC123...DEF', 'eth');
	/*
		'0xabc123...def'
	*/
	```

- `isAddressBlacklisted(address [, network])`
  - Checks whether an address is blacklisted for the given network; a blacklist entry with a null network blocks all networks, while a network-scoped entry only blocks that network.
  - `address` = the address to check
  - `network` = optional network code; null/empty checks against global (all-network) entries only
  - Returns a promise resolving to a boolean
	```javascript
	tools.wallet.isAddressBlacklisted('0xabc123...def', 'eth')
		.then((data) => {
			/*
				true
			*/
		});
	```

- `enforceAddressNotBlacklisted(address [, network, user])`
  - Chokepoint guard that throws `Withdrawal to this address is not allowed` if the destination is blacklisted; on a blocked attempt it logs the event and sends a throttled (per address+user) alert email to the exchange operator.
  - `address` = the destination withdrawal address
  - `network` = optional network code the withdrawal targets
  - `user` = optional user object (`{ id, network_id, email }`) used for logging and the operator alert
  - Returns a promise resolving to undefined when allowed; rejects/throws when the address is blacklisted
	```javascript
	tools.wallet.enforceAddressNotBlacklisted('0xabc123...def', 'eth', { id: 42, email: 'user@example.com' })
		.then(() => {
			/*
				resolves with no value -> address is allowed
			*/
		});
	```

- `createBlacklistedAddress(data)`
  - Creates a new blacklisted address entry (normalizing the address/network first), rejecting duplicates, and invalidates the blacklist cache on success.
  - `data` = object `{ address, network, label, reason, created_by }`; `address` is required, `network` defaults to null (all networks), the rest are optional metadata
  - Returns a promise resolving to the created blacklisted-address record
	```javascript
	tools.wallet.createBlacklistedAddress({
		address: '0xAbC123...DEF',
		network: 'eth',
		label: 'Sanctioned wallet',
		reason: 'OFAC list',
		created_by: 1
	})
		.then((data) => {
			/*
				{
					id: 7,
					address: '0xabc123...def',
					network: 'eth',
					label: 'Sanctioned wallet',
					reason: 'OFAC list',
					created_by: 1,
					created_at: '2026-06-06T12:00:00.000Z',
					updated_at: '2026-06-06T12:00:00.000Z'
				}
			*/
		});
	```

- `getBlacklistedAddresses([opts])`
  - Returns a paginated, optionally searchable and sortable list of blacklisted addresses.
  - `opts` = object `{ limit, page, order_by, order, search }`; `limit` defaults to 50 (max 100), `page` defaults to 1, `order_by` defaults to `created_at` (allowed fields: id, address, network, label, reason, created_by, created_at, updated_at), `order` defaults to `desc`, `search` matches address/network/label/reason
  - Returns a promise resolving to `{ count, data }`
	```javascript
	tools.wallet.getBlacklistedAddresses({ limit: 50, page: 1, search: 'OFAC' })
		.then((data) => {
			/*
				{
					count: 1,
					data: [
						{
							id: 7,
							address: '0xabc123...def',
							network: 'eth',
							label: 'Sanctioned wallet',
							reason: 'OFAC list',
							created_by: 1,
							created_at: '2026-06-06T12:00:00.000Z',
							updated_at: '2026-06-06T12:00:00.000Z'
						}
					]
				}
			*/
		});
	```

- `deleteBlacklistedAddress(id)`
  - Deletes the blacklisted address with the given id (throwing if not found) and invalidates the blacklist cache.
  - `id` = the id of the blacklisted-address entry to delete
  - Returns a promise resolving to the deleted record
	```javascript
	tools.wallet.deleteBlacklistedAddress(7)
		.then((data) => {
			/*
				{
					id: 7,
					address: '0xabc123...def',
					network: 'eth',
					label: 'Sanctioned wallet',
					reason: 'OFAC list',
					created_by: 1,
					created_at: '2026-06-06T12:00:00.000Z',
					updated_at: '2026-06-06T12:00:00.000Z'
				}
			*/
		});
	```

- `invalidateBlacklistCache()`
  - Clears the cached blacklist set in Redis so the next lookup rebuilds it from the database; failures are logged and swallowed.
  - Returns a promise resolving to undefined
	```javascript
	tools.wallet.invalidateBlacklistCache()
		.then(() => {
			/*
				resolves with no value -> blacklist cache cleared
			*/
		});
	```

#### Coin functions

- `subscribedToCoin(coin)`
  - Checks whether the exchange is subscribed to (has configured) the given coin symbol.
  - `coin` = coin symbol string (e.g. `'btc'`)
  - Returns boolean value
	```javascript
	const isSubscribed = tools.coin.subscribedToCoin('btc');
	/*
		true
	*/
	```

- `getKitCoin(coin)`
  - Returns the kit configuration object for a single coin symbol.
  - `coin` = coin symbol string (e.g. `'btc'`)
  - Returns the coin config object (or `undefined` if not configured)
	```javascript
	const coin = tools.coin.getKitCoin('btc');
	/*
		{
			id: 1,
			symbol: 'btc',
			fullname: 'Bitcoin',
			withdrawal_fee: 0.0005,
			min: 0.001,
			max: 100,
			increment_unit: 0.0001,
			active: true,
			...
		}
	*/
	```

- `getKitCoins()`
  - Returns the list of all coin symbols configured on the exchange.
  - Returns array of coin symbol strings
	```javascript
	const coins = tools.coin.getKitCoins();
	/*
		['btc', 'eth', 'usdt', ...]
	*/
	```

- `getKitCoinsConfig()`
  - Returns the full coins configuration object keyed by coin symbol.
  - Returns object mapping each coin symbol to its config object
	```javascript
	const coinsConfig = tools.coin.getKitCoinsConfig();
	/*
		{
			btc: { id: 1, symbol: 'btc', fullname: 'Bitcoin', ... },
			eth: { id: 2, symbol: 'eth', fullname: 'Ethereum', ... },
			...
		}
	*/
	```

- `createCoin(symbol, fullname [, opts])`
  - Creates a new coin on the network (symbol is trimmed and lowercased before sending).
  - `symbol` = coin symbol string (e.g. `'btc'`)
  - `fullname` = human-readable coin name (e.g. `'Bitcoin'`)
  - `opts` = optional fields: `code`, `withdrawalFee`, `min`, `max`, `incrementUnit`, `logo`, `meta`, `estimatedPrice`, `type`, `network`, `standard`, `allowDeposit`, `allowWithdrawal`, `additionalHeaders`
  - Returns a promise resolving to the created coin object
	```javascript
	tools.coin.createCoin('btc', 'Bitcoin', { withdrawalFee: 0.0005, min: 0.001, max: 100 })
		.then((data) => {
			/*
				{
					id: 1,
					symbol: 'btc',
					fullname: 'Bitcoin',
					withdrawal_fee: 0.0005,
					min: 0.001,
					max: 100,
					...
				}
			*/
		});
	```

- `updateCoin(code [, fields] [, opts])`
  - Updates the configuration of an existing coin identified by its code.
  - `code` = coin code/symbol identifying the coin to update
  - `fields` = fields to update: `fullname`, `withdrawalFee`, `description`, `withdrawalFees`, `depositFees`, `min`, `max`, `isPublic`, `incrementUnit`, `logo`, `meta`, `estimatedPrice`, `type`, `network`, `standard`, `allowDeposit`, `allowWithdrawal`, `category`, `isRisky`, `marketCap`
  - `opts` = optional `additionalHeaders`
  - Returns a promise resolving to the updated coin object
	```javascript
	tools.coin.updateCoin('btc', { withdrawalFee: 0.001, isPublic: true })
		.then((data) => {
			/*
				{
					id: 1,
					symbol: 'btc',
					withdrawal_fee: 0.001,
					is_public: true,
					...
				}
			*/
		});
	```

- `getNetworkCoins([opts])`
  - Retrieves the list of coins defined on the network.
  - `opts` = optional `search` (filter string) and `additionalHeaders`
  - Returns a promise resolving to the network coins result
	```javascript
	tools.coin.getNetworkCoins({ search: 'btc' })
		.then((data) => {
			/*
				{
					count: 1,
					data: [ { id: 1, symbol: 'btc', fullname: 'Bitcoin', ... } ]
				}
			*/
		});
	```

#### Pair functions

- `subscribedToPair(pair)`
  - Checks whether the exchange is subscribed to the given trading pair (includes quick-trade pairs).
  - `pair` = pair string (e.g. `'btc-usdt'`)
  - Returns boolean value
	```javascript
	const isSubscribed = tools.pair.subscribedToPair('btc-usdt');
	/*
		true
	*/
	```

- `getKitPair(pair)`
  - Returns the kit configuration object for a single trading pair.
  - `pair` = pair string (e.g. `'btc-usdt'`)
  - Returns the pair config object (or `undefined` if not configured)
	```javascript
	const pair = tools.pair.getKitPair('btc-usdt');
	/*
		{
			id: 1,
			name: 'btc-usdt',
			pair_base: 'btc',
			pair_2: 'usdt',
			min_size: 0.0001,
			max_size: 100,
			min_price: 1,
			max_price: 1000000,
			active: true,
			...
		}
	*/
	```

- `getKitPairs()`
  - Returns the list of all trading pair names configured on the exchange.
  - Returns array of pair name strings
	```javascript
	const pairs = tools.pair.getKitPairs();
	/*
		['btc-usdt', 'eth-usdt', ...]
	*/
	```

- `getKitPairsConfig()`
  - Returns the full pairs configuration object keyed by pair name.
  - Returns object mapping each pair name to its config object
	```javascript
	const pairsConfig = tools.pair.getKitPairsConfig();
	/*
		{
			'btc-usdt': { id: 1, name: 'btc-usdt', pair_base: 'btc', pair_2: 'usdt', ... },
			'eth-usdt': { id: 2, name: 'eth-usdt', pair_base: 'eth', pair_2: 'usdt', ... },
			...
		}
	*/
	```

- `createPair(name, baseCoin, quoteCoin [, opts])`
  - Creates a new trading pair on the network (name, baseCoin and quoteCoin are trimmed and lowercased before sending).
  - `name` = pair name string (e.g. `'btc-usdt'`)
  - `baseCoin` = base coin symbol (e.g. `'btc'`)
  - `quoteCoin` = quote coin symbol (e.g. `'usdt'`)
  - `opts` = optional fields: `code`, `active`, `minSize`, `maxSize`, `minPrice`, `maxPrice`, `incrementSize`, `incrementPrice`, `estimatedPrice`, `isPublic`, `status`, `additionalHeaders`
  - Returns a promise resolving to the created pair object
	```javascript
	tools.pair.createPair('btc-usdt', 'btc', 'usdt', { minSize: 0.0001, maxSize: 100 })
		.then((data) => {
			/*
				{
					id: 1,
					name: 'btc-usdt',
					pair_base: 'btc',
					pair_2: 'usdt',
					min_size: 0.0001,
					max_size: 100,
					...
				}
			*/
		});
	```

- `updatePair(code [, fields] [, opts])`
  - Updates the configuration of an existing trading pair identified by its code.
  - `code` = pair code identifying the pair to update
  - `fields` = fields to update: `minSize`, `maxSize`, `minPrice`, `maxPrice`, `incrementSize`, `incrementPrice`, `estimatedPrice`, `isPublic`, `circuitBreaker`, `status`
  - `opts` = optional `additionalHeaders`
  - Returns a promise resolving to the updated pair object
	```javascript
	tools.pair.updatePair('btc-usdt', { minSize: 0.001, isPublic: true })
		.then((data) => {
			/*
				{
					id: 1,
					name: 'btc-usdt',
					min_size: 0.001,
					is_public: true,
					...
				}
			*/
		});
	```

- `getNetworkPairs([opts])`
  - Retrieves the list of trading pairs defined on the network.
  - `opts` = optional `search` (filter string) and `additionalHeaders`
  - Returns a promise resolving to the network pairs result
	```javascript
	tools.pair.getNetworkPairs({ search: 'btc' })
		.then((data) => {
			/*
				{
					count: 1,
					data: [ { id: 1, name: 'btc-usdt', pair_base: 'btc', pair_2: 'usdt', ... } ]
				}
			*/
		});
	```

#### Exchange functions

- `getExchangeConfig([opts])`
  - Fetches the current exchange configuration from the HollaEx network node.
  - `opts` = optional settings object; `opts.additionalHeaders` lets you pass extra request headers
  - Returns a promise that resolves with the exchange configuration object.
	```javascript
	tools.exchange.getExchangeConfig()
		.then((data) => {
			/*
				{
					id: 1,
					name: 'My Exchange',
					display_name: 'My Exchange',
					type: 'Cloud',
					is_public: true,
					url: 'https://myexchange.com',
					info: { plan: 'fiat', status: true, active: true },
					business_info: {},
					pairs: ['btc-usdt', 'eth-usdt'],
					coins: ['btc', 'eth', 'usdt']
				}
			*/
		});
	```

- `updateExchangeConfig([fields [, opts]])`
  - Updates the exchange configuration on the network node and (unless skipped) publishes a refresh event so the running exchange reloads its config.
  - `fields` = object of exchange properties to update (e.g. `info`, `isPublic`, `type`, `name`, `displayName`, `url`, `businessInfo`, `pairs`, `coins`)
  - `opts` = optional settings; `opts.additionalHeaders` for extra request headers, `opts.skip_refresh` to skip publishing the `refreshInit` event on the init channel
  - Returns a promise that resolves with the updated exchange configuration object.
	```javascript
	tools.exchange.updateExchangeConfig(
		{ displayName: 'My Exchange', isPublic: true },
		{ skip_refresh: false }
	)
		.then((data) => {
			/*
				{
					id: 1,
					name: 'My Exchange',
					display_name: 'My Exchange',
					is_public: true,
					pairs: ['btc-usdt', 'eth-usdt'],
					coins: ['btc', 'eth', 'usdt']
				}
			*/
		});
	```

#### Plugin functions

- `getPaginatedPlugins(limit, page, search)`
  - Returns a paginated list of installed plugins, optionally filtered by name.
  - `limit` = maximum number of plugins per page
  - `page` = page number to fetch
  - `search` = optional substring matched against the plugin `name`
  - Returns a promise that resolves with `{ count, data }`, where each plugin includes an `enabled_admin_view` boolean (the `admin_view` field is removed).
	```javascript
	tools.plugin.getPaginatedPlugins(10, 1, 'sms')
		.then((data) => {
			/*
				{
					count: 1,
					data: [
						{
							name: 'sms',
							version: 1.2,
							enabled: true,
							author: 'HollaEx',
							description: 'SMS verification plugin',
							bio: '',
							url: '',
							type: 'phone',
							web_view: null,
							logo: '',
							icon: '',
							documentation: '',
							created_at: '2024-01-01T00:00:00.000Z',
							updated_at: '2024-01-01T00:00:00.000Z',
							public_meta: {},
							enabled_admin_view: false
						}
					]
				}
			*/
		});
	```

- `getPlugin(name [, opts])`
  - Fetches a single plugin record by its name.
  - `name` = the unique name of the plugin to look up
  - `opts` = optional Sequelize query options merged into the lookup (e.g. `attributes`, `raw`)
  - Returns a promise that resolves with the matching plugin instance, or `null` if not found.
	```javascript
	tools.plugin.getPlugin('sms', { raw: true })
		.then((data) => {
			/*
				{
					id: 3,
					name: 'sms',
					version: 1.2,
					enabled: true,
					type: 'phone',
					author: 'HollaEx',
					description: 'SMS verification plugin'
				}
			*/
		});
	```

- `isSmsPluginActive()`
  - Checks whether an enabled SMS (`phone` type) plugin is installed, caching the result for 60 seconds to avoid repeated database lookups.
  - Returns a promise that resolves with a boolean (`true` if an enabled phone plugin exists).
	```javascript
	tools.plugin.isSmsPluginActive()
		.then((data) => {
			/*
				true
			*/
		});
	```

#### Broker functions

- `createBrokerPair(brokerPair)`
  - Creates a new broker pair (manual or dynamic) after validating prices, sizes, plan, and formula.
  - `brokerPair` = object describing the pair (`symbol`, `type`, `buy_price`, `sell_price`, `min_size`, `max_size`, `spread`, `quote_expiry_time`, `formula`, `account`, `rebalancing_symbol`)
  - Throws if the symbol (or its reverse) already exists, on plan/formula/expiry errors; for `dynamic` type it auto-sets `refresh_interval` from the exchange plan
  - Returns a promise resolving to the created broker record
	```javascript
	tools.broker.createBrokerPair({
		symbol: 'btc-usdt',
		type: 'manual',
		buy_price: 60000,
		sell_price: 60500,
		min_size: 0.001,
		max_size: 10,
		quote_expiry_time: 30
	})
		.then((data) => {
			/*
				{
					id: 12,
					symbol: 'btc-usdt',
					type: 'manual',
					buy_price: 60000,
					sell_price: 60500,
					min_size: 0.001,
					max_size: 10,
					paused: false,
					quote_expiry_time: 30
				}
			*/
		});
	```

- `fetchBrokerPair(symbol)`
  - Fetches a single broker pair by its symbol.
  - `symbol` = market symbol of the broker pair (e.g. `'btc-usdt'`)
  - Returns a promise resolving to the broker record (or `null` if not found)
	```javascript
	tools.broker.fetchBrokerPair('btc-usdt')
		.then((data) => {
			/*
				{
					id: 12,
					symbol: 'btc-usdt',
					type: 'manual',
					buy_price: 60000,
					sell_price: 60500,
					min_size: 0.001,
					max_size: 10,
					paused: false
				}
			*/
		});
	```

- `fetchBrokerPairs(attributes)`
  - Fetches all broker pairs, masking each account's `apiKey`/`apiSecret`.
  - `attributes` = optional array of column names to limit the returned fields
  - Returns a promise resolving to an array of broker records with credentials masked
	```javascript
	tools.broker.fetchBrokerPairs(['id', 'symbol', 'type', 'paused'])
		.then((data) => {
			/*
				[
					{ id: 12, symbol: 'btc-usdt', type: 'manual', paused: false },
					{ id: 13, symbol: 'eth-usdt', type: 'dynamic', paused: true }
				]
			*/
		});
	```

- `updateBrokerPair(id, data)`
  - Updates an existing broker pair, re-validating plan, formula, expiry, and account credentials.
  - `id` = primary key of the broker pair to update
  - `data` = fields to update (only a fixed whitelist such as `buy_price`, `sell_price`, `min_size`, `max_size`, `paused`, `type`, `quote_expiry_time`, `rebalancing_symbol`, `account`, `formula`, `spread` is persisted); masked credentials are preserved from the stored record
  - Returns a promise resolving to the updated broker record
	```javascript
	tools.broker.updateBrokerPair(12, { paused: true, sell_price: 61000 })
		.then((data) => {
			/*
				{
					id: 12,
					symbol: 'btc-usdt',
					type: 'manual',
					sell_price: 61000,
					paused: true
				}
			*/
		});
	```

- `deleteBrokerPair(id)`
  - Deletes a broker pair; the pair must be paused first.
  - `id` = primary key of the broker pair to delete
  - Throws `BROKER_NOT_FOUND` if missing or `BROKER_ERROR_DELETE_UNPAUSED` if not paused
  - Returns a promise resolving when the record is destroyed
	```javascript
	tools.broker.deleteBrokerPair(12)
		.then((data) => {
			/*
				broker pair deleted
			*/
		});
	```

- `fetchBrokerQuote(brokerQuote)`
  - Computes a buy/sell quote (price, amounts, and an expiring token) for a broker pair.
  - `brokerQuote` = object with `symbol`, `side` (`'buy'`/`'sell'`), `orderData` (spending/receiving currency and amount), and optionally `bearerToken` + `ip` or `userInfo` to identify the user
  - When a user is resolved, a random `token` and `expiry` are attached for deal execution; routes to dynamic or manual quote logic based on broker type
  - Returns a promise resolving to a quote object (`price`, `receiving_amount`, `spending_amount`, and `token`/`expiry` if authenticated)
	```javascript
	tools.broker.fetchBrokerQuote({
		symbol: 'btc-usdt',
		side: 'buy',
		orderData: { spending_currency: 'usdt', receiving_currency: 'btc', spending_amount: 600 }
	})
		.then((data) => {
			/*
				{
					price: 60500,
					spending_amount: 600,
					receiving_amount: 0.00991735,
					token: 'a1B2c3...',
					expiry: '2026-06-06T12:00:30.000Z'
				}
			*/
		});
	```

- `reverseTransaction(orderData)`
  - Places a hedging order on the broker's connected exchange to offset an executed broker deal.
  - `orderData` = object with `symbol`, `side`, `size`, and `trade_id` (used as the exchange client order id)
  - Matches the broker by symbol (or reversed symbol); only acts when the broker is unpaused and has a configured `account`. Bybit uses a price-adjusted limit order, other exchanges use a market order; emails the broker owner on order failure
  - Returns a promise that resolves (no value) once the order is submitted, or returns early/`false` when conditions are not met
	```javascript
	tools.broker.reverseTransaction({
		symbol: 'btc-usdt',
		side: 'buy',
		size: 0.01,
		trade_id: 987654
	})
		.then(() => {
			/*
				hedging order submitted to the connected exchange (no return value)
			*/
		});
	```

- `testBroker(data)`
  - Tests a dynamic broker formula by computing a price and applying the spread.
  - `data` = object with `formula` (market-pair or JSON external-price formula) and `spread` (percent)
  - Throws if spread is missing or the resolved price is negative
  - Returns a promise resolving to `{ buy_price, sell_price }` rounded to the price's decimal precision
	```javascript
	tools.broker.testBroker({ formula: 'binance_btc-usdt', spread: 1 })
		.then((data) => {
			/*
				{
					buy_price: 59895,
					sell_price: 60505
				}
			*/
		});
	```

- `testRebalance(data)`
  - Connects to an external exchange with the given credentials and fetches the account balance.
  - `data` = object with `exchange_id`, `api_key`, `api_secret`, and optional `password`
  - Returns a promise resolving to the ccxt balance object for the account
	```javascript
	tools.broker.testRebalance({
		exchange_id: 'binance',
		api_key: 'KEY',
		api_secret: 'SECRET'
	})
		.then((data) => {
			/*
				{
					info: { ... },
					BTC: { free: 0.5, used: 0, total: 0.5 },
					USDT: { free: 1000, used: 0, total: 1000 }
				}
			*/
		});
	```

- `generateRandomToken(user_id, symbol, side, expiryTime, price, size, type)`
  - Generates a random 32-char token and stores the trade data in Redis with an expiry.
  - `user_id` = id of the user the quote belongs to
  - `symbol` = market symbol; `side` = `'buy'`/`'sell'`
  - `expiryTime` = TTL in seconds (default 30)
  - `price`, `size` = quote price and order size (both required, else throws `INVALID_PRICE`/`INVALID_SIZE`)
  - `type` = quote type tag (e.g. `'broker'`)
  - Returns the generated token string (synchronous; not a promise)
	```javascript
	const token = tools.broker.generateRandomToken(
		1,
		'btc-usdt',
		'buy',
		30,
		60500,
		0.01,
		'broker'
	);
	/*
		token => 'a1B2c3D4e5F6g7H8i9J0k1L2m3N4o5P6'
	*/
	```

- `fetchTrackedExchangeMarkets(exchange)`
  - Fetches the list of available markets from an external exchange via ccxt.
  - `exchange` = exchange id (e.g. `'binance'`)
  - Returns a promise resolving to the array of ccxt market objects
	```javascript
	tools.broker.fetchTrackedExchangeMarkets('binance')
		.then((data) => {
			/*
				[
					{ id: 'BTCUSDT', symbol: 'BTC/USDT', base: 'BTC', quote: 'USDT', spot: true },
					{ id: 'ETHUSDT', symbol: 'ETH/USDT', base: 'ETH', quote: 'USDT', spot: true }
				]
			*/
		});
	```

- `testBrokerUniswap(data)`
  - Tests a Uniswap (ParaSwap) based price for a coin pair and applies the spread.
  - `data` = object with `base_coin`, `quote_coin`, and `spread` (percent)
  - Throws `SYMBOL_NOT_FOUND` if the coins are not supported or `SPREAD_MISSING` if no spread
  - Returns a promise resolving to `{ buy_price, sell_price }`
	```javascript
	tools.broker.testBrokerUniswap({ base_coin: 'eth', quote_coin: 'usdt', spread: 1 })
		.then((data) => {
			/*
				{
					buy_price: 2970,
					sell_price: 3030
				}
			*/
		});
	```

- `isFairPriceForBroker(broker)`
  - Checks whether a dynamic broker's market-derived price is within 10% of the oracle price.
  - `broker` = broker record (must include `type`, `formula`, `id`); non-dynamic brokers are always considered fair
  - Returns a promise resolving to `true` if the price is fair (or oracle price unavailable), `false` if the difference exceeds 10%
	```javascript
	tools.broker.isFairPriceForBroker({ type: 'dynamic', formula: 'binance_btc-usdt', id: 12 })
		.then((data) => {
			/*
				true
			*/
		});
	```

- `calculatePrice(side, spread, formula, refresh_interval, brokerId [, isOracle])`
  - Resolves a price from a market-pair formula, an external JSON formula, or the oracle, then applies the spread.
  - `side` = `'buy'`/`'sell'`/`null`; buy adds spread, sell subtracts it, null leaves it raw
  - `spread` = spread percent applied to the base price
  - `formula` = arithmetic formula referencing `exchange_pair` variables (e.g. `'binance_btc-usdt'`) or a JSON object/string with `request`/`extract` for external prices
  - `refresh_interval` = Redis cache TTL in seconds for fetched prices
  - `brokerId` = identifier used for cache keys
  - `isOracle` = when true, prices come from the oracle (`getAssetsPrices`) instead of ccxt tickers (default false)
  - Returns a promise resolving to the computed price number (or `-1` if an oracle price is unavailable)
	```javascript
	tools.broker.calculatePrice('buy', 1, 'binance_btc-usdt', 5, 'test:broker')
		.then((data) => {
			/*
				60500
			*/
		});
	```

#### Stake functions

- `getExchangeStakePools([opts])`
  - Fetch a paginated (or CSV-exported) list of exchange stake pools, each augmented with its aggregated net reward.
  - `opts` = options object: `limit`, `page`, `order_by`, `order`, `start_date`, `end_date`, `status` (filter by pool status), `format` (e.g. `'csv'` to return a CSV string; otherwise paginated data)
  - Returns a promise resolving to `{ count, data }` (each pool has an added `reward` field summing stakers' rewards minus slashes), or a CSV string when `format` is `'csv'`
	```javascript
	tools.stake.getExchangeStakePools({ status: 'active', limit: 10 })
		.then((data) => {
			/*
				{
					count: 2,
					data: [
						{
							id: 1,
							name: 'BTC 30-day',
							currency: 'btc',
							reward_currency: 'btc',
							account_id: 1,
							apy: 5,
							duration: 30,
							status: 'active',
							onboarding: true,
							reward: 0.0042
						},
						// ...
					]
				}
			*/
		});
	```
- `createExchangeStakePool(stake)`
  - Create a new exchange stake pool after validating amounts/APY/slashing and verifying coins, oracle pricing, exchange plan, and funding account owner.
  - `stake` = pool definition object: `currency`, `reward_currency` (defaults to `currency` if omitted), `account_id` (funding account kit id), `apy`, `duration` (days, or `null` for perpetual), `min_amount`, `max_amount`, `slashing_principle_percentage`, `slashing_earning_percentage`, `early_unstake`, `status` (must be `'uninitialized'`), `onboarding` (must be falsy), `name`, `category`, `disclaimer`, etc.
  - Returns a promise resolving to the created stake pool record
	```javascript
	tools.stake.createExchangeStakePool({
		name: 'BTC 30-day',
		currency: 'btc',
		account_id: 1,
		apy: 5,
		duration: 30,
		min_amount: 0.001,
		max_amount: 1,
		status: 'uninitialized',
		onboarding: false
	})
		.then((data) => {
			/*
				{
					id: 3,
					name: 'BTC 30-day',
					currency: 'btc',
					reward_currency: 'btc',
					status: 'uninitialized',
					slashing: false,
					created_at: '2026-06-06T10:00:00.000Z'
				}
			*/
		});
	```
- `updateExchangeStakePool(id, data, auditInfo)`
  - Update an existing stake pool, enforcing valid state transitions (pause/terminate), distributing rewards to stakers on termination, and writing an audit log.
  - `id` = stake pool id
  - `data` = fields to update (e.g. `status`, `currency`, `reward_currency`, `account_id`, `apy`, `duration`, `min_amount`, `max_amount`, `onboarding`, slashing percentages); setting `status: 'paused'` stamps `paused_date`, and `status: 'terminated'` (only from `'paused'`) settles and pays out active/unstaking stakers
  - `auditInfo` = `{ userEmail, sessionId, apiPath, method }` used for the audit log
  - Returns a promise resolving to the updated stake pool record
	```javascript
	tools.stake.updateExchangeStakePool(
		3,
		{ status: 'paused' },
		{ userEmail: 'admin@hollaex.com', sessionId: 'abc', apiPath: '/admin/stake', method: 'PUT' }
	)
		.then((data) => {
			/*
				{
					id: 3,
					status: 'paused',
					paused_date: '2026-06-06T10:05:00.000Z'
				}
			*/
		});
	```
- `getExchangeStakers([opts])`
  - Fetch a paginated (or CSV-exported) list of stakers, each joined with its parent stake pool.
  - `opts` = options object: `user_id`, `stake_id`, `currency`, `status`, `limit`, `page`, `order_by`, `order`, `start_date`, `end_date`, `format` (`'csv'` for CSV string)
  - Returns a promise resolving to `{ count, data }` with each staker including an embedded `stake` object, or a CSV string when `format` is `'csv'`
	```javascript
	tools.stake.getExchangeStakers({ user_id: 42, status: 'staking' })
		.then((data) => {
			/*
				{
					count: 1,
					data: [
						{
							id: 7,
							user_id: 42,
							stake_id: 1,
							amount: 0.5,
							currency: 'btc',
							reward_currency: 'btc',
							status: 'staking',
							closing: '2026-07-06T10:00:00.000Z',
							stake: { id: 1, name: 'BTC 30-day', apy: 5 }
						}
					]
				}
			*/
		});
	```
- `createExchangeStaker(stake_id, amount, user_id)`
  - Stake a user's funds into a pool: validates the pool is active/onboarding, checks balance and min/max limits and the 12 active-stake cap, transfers funds to the pool account, creates the staker, publishes a websocket event, and emails the user.
  - `stake_id` = id of the target stake pool
  - `amount` = amount to stake (between the pool's `min_amount` and `max_amount`)
  - `user_id` = kit id of the staking user
  - Returns a promise resolving to the created staker record
	```javascript
	tools.stake.createExchangeStaker(1, 0.5, 42)
		.then((data) => {
			/*
				{
					id: 7,
					user_id: 42,
					stake_id: 1,
					amount: 0.5,
					nav: 0.5,
					currency: 'btc',
					reward_currency: 'btc',
					status: 'staking',
					closing: '2026-07-06T10:00:00.000Z'
				}
			*/
		});
	```
- `deleteExchangeStaker(staker_id, user_id)`
  - Unstake a user's active stake: validates pool state and maturity/early-unstake rules, applies any slashing to principle and earnings, sets the staker to `'unstaking'`, and publishes a websocket event.
  - `staker_id` = id of the staker record (must belong to the user and be in `'staking'` status)
  - `user_id` = kit id of the owning user
  - Returns a promise resolving to the updated staker record (now `'unstaking'`, with reduced `amount` and recorded `slashed`/`unstaked_date`)
	```javascript
	tools.stake.deleteExchangeStaker(7, 42)
		.then((data) => {
			/*
				{
					id: 7,
					user_id: 42,
					status: 'unstaking',
					amount: 0.49,
					slashed: 0.0001,
					unstaked_date: '2026-06-06T10:10:00.000Z'
				}
			*/
		});
	```
- `updateExchangeStaker(id [, data], auditInfo)`
  - Admin update of a staker record with validation of `nav`/`reward`/`status`, optional audit logging, and a websocket event on change.
  - `id` = staker record id
  - `data` = fields to update; only `nav` (finite number), `reward` (finite number), and `status` (`'staking'`, `'unstaking'`, or `'closed'`) are validated; returns the unchanged record if empty
  - `auditInfo` = optional `{ userEmail, sessionId, apiPath, method }`; audit log is written only when `userEmail` is present
  - Returns a promise resolving to the updated (or unchanged) staker record
	```javascript
	tools.stake.updateExchangeStaker(
		7,
		{ reward: 0.01, status: 'staking' },
		{ userEmail: 'admin@hollaex.com', sessionId: 'abc', apiPath: '/admin/staker', method: 'PUT' }
	)
		.then((data) => {
			/*
				{
					id: 7,
					reward: 0.01,
					status: 'staking'
				}
			*/
		});
	```
- `unstakeEstimateSlash(staker_id)`
  - Estimate the slashing that would apply if a specific staker unstaked now (early unstake before the closing date).
  - `staker_id` = id of the staker record
  - Returns a promise resolving to `{ slashingPrinciple, slashingEarning }` (both numbers; zero when not slashed or for perpetual pools)
	```javascript
	tools.stake.unstakeEstimateSlash(7)
		.then((data) => {
			/*
				{
					slashingPrinciple: 0.005,
					slashingEarning: 0.0001
				}
			*/
		});
	```
- `unstakeEstimateSlashAdmin(id)`
  - Compute the total net reward owed across a pool's active/unstaking stakers (used when an admin terminates the pool).
  - `id` = stake pool id
  - Returns a promise resolving to `{ reward }` (sum of stakers' rewards minus slashes)
	```javascript
	tools.stake.unstakeEstimateSlashAdmin(1)
		.then((data) => {
			/*
				{
					reward: 0.0042
				}
			*/
		});
	```
- `fetchStakeAnalytics()`
  - Aggregate total staked amounts per currency, both overall and for stakers currently in `'unstaking'` status.
  - Returns a promise resolving to `{ stakingAmount, unstakingAmount }`, each an array of `{ currency, total_amount }` rows grouped by currency
	```javascript
	tools.stake.fetchStakeAnalytics()
		.then((data) => {
			/*
				{
					stakingAmount: [
						{ currency: 'btc', total_amount: 12.5 },
						{ currency: 'eth', total_amount: 340 }
					],
					unstakingAmount: [
						{ currency: 'btc', total_amount: 0.5 }
					]
				}
			*/
		});
	```

#### P2P functions

- `createP2PDeal(data)`
  - Creates a new P2P deal (merchant offer) after validating plan, merchant tier, coins/pair, balance and order-value bounds.
  - `data` = object with `merchant_id`, `buying_asset`, `spending_asset`, `side`, `price_type` (`static`/`dynamic`), `exchange_rate`, `dynamic_pair`, `spread`, `total_order_amount`, `min_order_value`, `max_order_value`, `terms`, `auto_response`, `payment_methods`, `region`
  - Returns a promise resolving with the created p2pDeal record
	```javascript
	tools.p2p.createP2PDeal({
		merchant_id: 1,
		side: 'sell',
		price_type: 'static',
		buying_asset: 'usdt',
		spending_asset: 'usd',
		exchange_rate: 1,
		spread: 0.5,
		total_order_amount: 1000,
		min_order_value: 10,
		max_order_value: 500,
		payment_methods: [{ system_name: 'bank' }],
		region: 'US'
	})
		.then((data) => {
			/*
				{
					id: 12,
					merchant_id: 1,
					side: 'sell',
					price_type: 'static',
					buying_asset: 'usdt',
					spending_asset: 'usd',
					exchange_rate: 1,
					spread: 0.5,
					total_order_amount: 1000,
					min_order_value: 10,
					max_order_value: 500,
					status: true,
					created_at: '2026-06-06T10:00:00.000Z'
				}
			*/
		});
	```

- `createP2PTransaction(data)`
  - Creates a P2P transaction against a deal, computing price/amount, locking merchant balance and seeding the chat with the deal's auto-response.
  - `data` = object with `deal_id`, `user_id` (buyer kit id), `amount_fiat`, `side` (`buy`/`sell`), `payment_method_used`, `ip`
  - Returns a promise resolving with the created p2pTransaction record (also emails the merchant)
	```javascript
	tools.p2p.createP2PTransaction({
		deal_id: 12,
		user_id: 5,
		amount_fiat: 100,
		side: 'sell',
		payment_method_used: { system_name: 'bank' },
		ip: '1.2.3.4'
	})
		.then((data) => {
			/*
				{
					id: 88,
					transaction_id: 'a1b2c3d4-...',
					deal_id: 12,
					merchant_id: 1,
					user_id: 5,
					amount_digital_currency: 99.5,
					amount_fiat: 100,
					price: 1.005,
					user_status: 'pending',
					merchant_status: 'pending',
					transaction_status: 'active',
					transaction_duration: 30,
					locked_asset_id: 'lock-123',
					messages: [{ sender_id: 1, receiver_id: 5, message: 'Hi!', type: 'message' }]
				}
			*/
		});
	```

- `createP2pDispute(data)`
  - Creates a P2P dispute record (also called internally when a transaction is appealed).
  - `data` = object with `transaction_id`, `initiator_id`, `defendant_id`, `reason`, optional `resolution`; `status` is forced to `true`
  - Returns a promise resolving with the created p2pDispute record
	```javascript
	tools.p2p.createP2pDispute({
		transaction_id: 88,
		initiator_id: 5,
		defendant_id: 1,
		reason: 'Payment not received'
	})
		.then((data) => {
			/*
				{
					id: 3,
					transaction_id: 88,
					initiator_id: 5,
					defendant_id: 1,
					reason: 'Payment not received',
					status: true
				}
			*/
		});
	```

- `updateP2pTransaction(data)`
  - Updates buyer/merchant status on a transaction, enforcing role permissions and expiry, settling funds on mutual confirmation, opening disputes on appeal, unlocking on cancel, and appending chat/email notifications.
  - `data` = object with `id` (transaction id), `user_id` (acting user), `user_status` and/or `merchant_status` (`confirmed`/`cancelled`/`appeal`), `cancellation_reason`, `ip`
  - Returns a promise resolving with the updated p2pTransaction record
	```javascript
	tools.p2p.updateP2pTransaction({
		id: 88,
		user_id: 5,
		user_status: 'confirmed',
		ip: '1.2.3.4'
	})
		.then((data) => {
			/*
				{
					id: 88,
					user_status: 'confirmed',
					merchant_status: 'pending',
					transaction_status: 'active',
					messages: [ ... ]
				}
			*/
		});
	```

- `updateP2pDispute(data)`
  - Updates a dispute's resolution/status; when closed (`status: false`) it closes the linked transaction and posts a closing chat message plus emails.
  - `data` = object with `id` (dispute id), `resolution`, `status`
  - Returns a promise resolving with the updated p2pDispute record
	```javascript
	tools.p2p.updateP2pDispute({
		id: 3,
		resolution: 'Refunded buyer',
		status: false
	})
		.then((data) => {
			/*
				{
					id: 3,
					transaction_id: 88,
					resolution: 'Refunded buyer',
					status: false
				}
			*/
		});
	```

- `updateMerchantProfile(data)`
  - Upserts a merchant profile: creates a p2pMerchant record if none exists for the user, otherwise updates it.
  - `data` = object with `id`, `user_id`, `blocked_users` (array of blocked user ids)
  - Returns a promise resolving with the created p2pMerchant record (when newly created)
	```javascript
	tools.p2p.updateMerchantProfile({
		id: 1,
		user_id: 1,
		blocked_users: [42, 57]
	})
		.then((data) => {
			/*
				{
					id: 1,
					user_id: 1,
					blocked_users: [42, 57]
				}
			*/
		});
	```

- `createMerchantFeedback(data)`
  - Creates a feedback/rating for the counterparty of a completed transaction, validating authorization, single-feedback-per-user, and rating range (1-5).
  - `data` = object with `transaction_id`, `user_id` (rater), `rating` (1-5), `comment`; `merchant_id` (ratee) is derived automatically
  - Returns a promise resolving with the created P2pMerchantsFeedback record
	```javascript
	tools.p2p.createMerchantFeedback({
		transaction_id: 88,
		user_id: 5,
		rating: 5,
		comment: 'Fast and reliable'
	})
		.then((data) => {
			/*
				{
					id: 7,
					merchant_id: 1,
					user_id: 5,
					transaction_id: 88,
					rating: 5,
					comment: 'Fast and reliable'
				}
			*/
		});
	```

- `createP2pChatMessage(data)`
  - Appends a chat message to an active transaction, verifying the sender is the merchant or buyer.
  - `data` = object with `transaction_id`, `sender_id`, `receiver_id`, `message`
  - Returns a promise resolving with the updated p2pTransaction record (with the appended message)
	```javascript
	tools.p2p.createP2pChatMessage({
		transaction_id: 88,
		sender_id: 5,
		receiver_id: 1,
		message: 'I have sent the payment'
	})
		.then((data) => {
			/*
				{
					id: 88,
					messages: [
						{ sender_id: 1, receiver_id: 5, message: 'Hi!', type: 'message' },
						{ sender_id: 5, receiver_id: 1, message: 'I have sent the payment', type: 'message' }
					]
				}
			*/
		});
	```

- `fetchP2PDeals(opts)`
  - Lists P2P deals with optional merchant/status filters, pagination, ordering and timeframe; non-format results are Redis-cached for 30s and have dynamic-pair exchange rates computed.
  - `opts` = object with `user_id` (filters by merchant_id), `status`, `limit`, `page`, `order_by`, `order`, `start_date`, `end_date`, `format` (`csv` returns a CSV string)
  - Returns a promise resolving with `{ count, data }` (or a CSV string when `format` is `csv`)
	```javascript
	tools.p2p.fetchP2PDeals({ status: true, limit: 50 })
		.then((data) => {
			/*
				{
					count: 1,
					data: [
						{
							id: 12,
							merchant_id: 1,
							buying_asset: 'usdt',
							exchange_rate: 1,
							status: true,
							merchant: { id: 1, full_name: 'Acme Trader' }
						}
					]
				}
			*/
		});
	```

- `fetchP2PTransactions(user_id, opts)`
  - Lists transactions where the given user is merchant or buyer, with deal/merchant/buyer joins, optional id filter, pagination, ordering, timeframe and CSV export.
  - `user_id` = kit id to match against merchant_id or user_id
  - `opts` = object with `id`, `limit`, `page`, `order_by`, `order`, `start_date`, `end_date`, `format`
  - Returns a promise resolving with `{ count, data }` (or a CSV string when `format` is `csv`)
	```javascript
	tools.p2p.fetchP2PTransactions(5, { limit: 20 })
		.then((data) => {
			/*
				{
					count: 1,
					data: [
						{
							id: 88,
							transaction_status: 'active',
							amount_fiat: 100,
							deal: { id: 12, buying_asset: 'usdt' },
							merchant: { id: 1, full_name: 'Acme Trader' },
							buyer: { id: 5, full_name: 'Jane Doe' }
						}
					]
				}
			*/
		});
	```

- `fetchP2PDisputes(opts)`
  - Lists P2P disputes with optional initiator filter, pagination, ordering, timeframe and CSV export.
  - `opts` = object with `user_id` (filters by initiator_id), `limit`, `page`, `order_by`, `order`, `start_date`, `end_date`, `format`
  - Returns a promise resolving with `{ count, data }` (or a CSV string when `format` is `csv`)
	```javascript
	tools.p2p.fetchP2PDisputes({ limit: 10 })
		.then((data) => {
			/*
				{
					count: 1,
					data: [
						{
							id: 3,
							transaction_id: 88,
							initiator_id: 5,
							defendant_id: 1,
							reason: 'Payment not received',
							status: true
						}
					]
				}
			*/
		});
	```

- `updateP2PDeal(data)`
  - Updates a deal after re-validating ownership, coins/pair, balance and bounds; when `edited_ids` is supplied it bulk-updates `status` for those deals instead. Clears deal caches.
  - `data` = object with `id`, `merchant_id`, optional `edited_ids` (array for bulk status update) and the same fields as `createP2PDeal` plus `status`
  - Returns a promise resolving with the updated p2pDeal record (or `{ message: 'success' }` for a bulk `edited_ids` update)
	```javascript
	tools.p2p.updateP2PDeal({
		id: 12,
		merchant_id: 1,
		buying_asset: 'usdt',
		spending_asset: 'usd',
		price_type: 'static',
		exchange_rate: 1,
		spread: 0.5,
		total_order_amount: 1000,
		min_order_value: 10,
		max_order_value: 500,
		status: true
	})
		.then((data) => {
			/*
				{
					id: 12,
					merchant_id: 1,
					total_order_amount: 1000,
					status: true
				}
			*/
		});
	```

- `deleteP2PDeal(removed_ids, user_id)`
  - Deletes the merchant's own deals by id and clears the deal caches.
  - `removed_ids` = id or array of ids to delete
  - `user_id` = merchant kit id (only deals owned by this merchant are removed)
  - Returns a promise resolving with an array of destroy results
	```javascript
	tools.p2p.deleteP2PDeal([12, 13], 1)
		.then((data) => {
			/*
				[1, 1] // number of rows destroyed per deal
			*/
		});
	```

- `fetchP2PFeedbacks(opts)`
  - Lists merchant feedbacks with optional transaction/merchant/user filters, a user join, pagination, ordering, timeframe and CSV export.
  - `opts` = object with `transaction_id`, `merchant_id`, `user_id`, `limit`, `page`, `order_by`, `order`, `start_date`, `end_date`, `format`
  - Returns a promise resolving with `{ count, data }` (or a CSV string when `format` is `csv`)
	```javascript
	tools.p2p.fetchP2PFeedbacks({ merchant_id: 1 })
		.then((data) => {
			/*
				{
					count: 1,
					data: [
						{
							id: 7,
							merchant_id: 1,
							user_id: 5,
							transaction_id: 88,
							rating: 5,
							comment: 'Fast and reliable',
							user: { id: 5, full_name: 'Jane Doe' }
						}
					]
				}
			*/
		});
	```

- `fetchP2PProfile(user_id)`
  - Computes a merchant's reputation profile: total transactions, completion rate and positive/negative feedback stats.
  - `user_id` = merchant kit id
  - Returns a promise resolving with an object of aggregate stats
	```javascript
	tools.p2p.fetchP2PProfile(1)
		.then((data) => {
			/*
				{
					totalTransactions: 42,
					completionRate: 95.2,
					positiveFeedbackRate: 90,
					positiveFeedbackCount: 18,
					negativeFeedbackCount: 2
				}
			*/
		});
	```

#### Verification functions

- `parseRequestVerificationMethod(value)`
  - Normalizes a requested verification method into the canonical `'sms'` or `'email'` value
  - `value` = raw requested method (case-insensitive); `null`/empty returns `undefined`, anything other than `sms`/`email` throws
  - Returns `'sms'`, `'email'`, or `undefined` (synchronous; throws on invalid input)
	```javascript
	tools.verification.parseRequestVerificationMethod('SMS')
		.then((data) => {
			/*
				'sms'
			*/
		});
	```
- `assertEmailVerificationEligible(user [, options])`
  - Throws unless the user has a valid, real (non phone-signup) email, optionally requiring it to be verified
  - `user` = user object (uses `user.email`, `user.email_verified`, `user.meta.phone_signup`)
  - `options.requireVerified` = when `true`, also requires `user.email_verified` (default `false`)
  - Returns nothing on success (synchronous; throws an Error when the user is not eligible)
	```javascript
	tools.verification.assertEmailVerificationEligible(user, { requireVerified: true })
		.then((data) => {
			/*
				undefined (no error thrown means the user is eligible)
			*/
		});
	```
- `assertSmsVerificationEligible(user [, options [, deps]])`
  - Throws unless the user has a phone number and SMS verification is enabled and active on the exchange
  - `user` = user object (uses `user.phone_number`, `user.phone_number_verified`)
  - `options.requireVerified` = when `true`, also requires `user.phone_number_verified` (default `false`)
  - `deps` = optional dependency overrides (`getKitConfig`, `isSmsPluginActive`) mainly for testing
  - Returns a promise that resolves to `undefined` on success, or rejects with an Error when not eligible
	```javascript
	tools.verification.assertSmsVerificationEligible(user, { requireVerified: true })
		.then((data) => {
			/*
				undefined (resolves with no value when the user is eligible)
			*/
		});
	```
- `sendVerificationCode(user, options)`
  - Resolves the delivery channel (email vs SMS) and dispatches the verification code via email or by publishing an SMS event
  - `user` = user object (required; uses `id`, `email`, `phone_number`, `settings`)
  - `options.action_type` = action being verified, e.g. `'signup'`, `'reset_password'` (required; some actions skip the verified-contact check)
  - `options.verification_code` = the code to deliver (required)
  - `options.emailType` = email template/type passed to the mailer
  - `options.emailData` = data merged into the email template (default `{}`)
  - `options.domain` = exchange domain used when sending the email
  - `options.requestVerificationMethod` = optional forced method (`'sms'`/`'email'`); otherwise auto-selected
  - Returns a promise resolving to `{ method }` indicating the channel actually used
	```javascript
	tools.verification.sendVerificationCode(user, {
		action_type: 'login',
		verification_code: '123456',
		emailType: 'login_verification',
		domain: 'https://exchange.com'
	})
		.then((data) => {
			/*
				{ method: 'email' }
			*/
		});
	```

#### Security functions

- `checkCaptcha(captcha [, remoteip = ''] [, headers = {}])`
  - Verifies a Cloudflare Turnstile captcha response server-side; resolves silently when Turnstile is not configured.
  - `captcha` = the Turnstile token returned by the client widget
  - `remoteip` = the requester's IP, forwarded to Cloudflare for verification
  - `headers` = accepted for backward compatibility but intentionally ignored
  - Returns a promise that resolves (undefined) on success and rejects with `INVALID_CAPTCHA` on failure
	```javascript
	tools.security.checkCaptcha('0.Abc...turnstile-token', '192.168.0.1')
		.then(() => {
			/*
				resolves with undefined when the captcha is valid (or skipped)
			*/
		});
	```

- `resetUserPassword(resetPasswordCode, newPassword)`
  - Consumes a reset-password code to set a new password, then revokes all sessions and disables withdrawals for 24 hours.
  - `resetPasswordCode` = the one-time code previously stored in Redis
  - `newPassword` = the new password (must pass `isValidPassword`)
  - Returns a promise with the updated user model instance
	```javascript
	tools.security.resetUserPassword('a1b2c3d4e5f6...', 'NewPass123')
		.then((user) => {
			/*
				user => updated Sequelize user instance with the new (hashed) password
			*/
		});
	```

- `isValidPassword(value)`
  - Tests whether a password is at least 8 chars and contains both a letter and a digit.
  - `value` = the candidate password string
  - Returns boolean value
	```javascript
	const ok = tools.security.isValidPassword('NewPass123'); // true
	```

- `validatePassword(userPassword, inputPassword)`
  - Compares a plaintext input against a stored bcrypt hash.
  - `userPassword` = the stored bcrypt hash from the user record
  - `inputPassword` = the plaintext password to check
  - Returns a promise resolving to a boolean (true if they match)
	```javascript
	tools.security.validatePassword(user.password, 'NewPass123')
		.then((isValid) => {
			/*
				isValid => true when the input matches the stored hash
			*/
		});
	```

- `sendResetPasswordCode(identifier, captcha, ip, domain [, version] [, headers = {}] [, verification_method])`
  - Generates a reset-password code for a user (by email or phone), stores a freeze-account token, and emails the code.
  - `identifier` = the user's email or phone number
  - `captcha` = Turnstile token validated before sending
  - `ip` = requester IP, embedded in the email and freeze token
  - `domain` = base URL used to build the freeze-account link
  - `version` = code format ('v3'/'v4' use short codes, otherwise a hex code)
  - `verification_method` = preferred delivery method (email/sms)
  - Returns a promise that resolves once the verification code is sent
	```javascript
	tools.security.sendResetPasswordCode('user@example.com', 'turnstile-token', '192.168.0.1', 'https://exchange.com', 'v4')
		.then(() => {
			/*
				resolves with undefined after the reset code email/SMS is dispatched
			*/
		});
	```

- `changeUserPassword(email, oldPassword, newPassword, ip, domain, otpCode, version, verification_method)`
  - Validates the old password and OTP, then emails a confirmation code required to finalize the password change.
  - `email` = the user's email
  - `oldPassword` = current password (must match)
  - `newPassword` = the new password (must differ and be valid)
  - `ip` = requester IP shown in the email/freeze token
  - `domain` = base URL for the freeze-account link
  - `otpCode` = OTP code, verified if the user has OTP enabled
  - `version` = code format ('v3'/'v4' use short codes plus a freeze token)
  - `verification_method` = preferred delivery method
  - Returns a promise that resolves once the confirmation code is sent
	```javascript
	tools.security.changeUserPassword('user@example.com', 'OldPass123', 'NewPass123', '192.168.0.1', 'https://exchange.com', '123456', 'v4', 'email')
		.then(() => {
			/*
				resolves with undefined after the change-password confirmation is sent
			*/
		});
	```

- `setInitialUserPassword(email, password)`
  - Sets a password for a user whose password is still 'notset', enforcing email/phone verification when required.
  - `email` = the user's email
  - `password` = the initial password (must pass `isValidPassword`)
  - Returns a promise with the updated user model instance
	```javascript
	tools.security.setInitialUserPassword('user@example.com', 'NewPass123')
		.then((user) => {
			/*
				user => updated Sequelize user instance with the password set
			*/
		});
	```

- `confirmChangeUserPassword(code [, domain])`
  - Consumes a change-password code, applies the stored hashed password, revokes sessions, disables withdrawals, and emails confirmation.
  - `code` = the change-password code stored in Redis
  - `domain` = base URL passed to the confirmation email
  - Returns a promise that resolves once the password is applied and the email sent
	```javascript
	tools.security.confirmChangeUserPassword('AB-12345', 'https://exchange.com')
		.then(() => {
			/*
				resolves with undefined once the new password is committed
			*/
		});
	```

- `hasUserOtpEnabled(id)`
  - Looks up whether a user has OTP (2FA) enabled.
  - `id` = the user id
  - Returns a promise resolving to a boolean
	```javascript
	tools.security.hasUserOtpEnabled(42)
		.then((enabled) => {
			/*
				enabled => true when the user has OTP turned on
			*/
		});
	```

- `verifyOtpBeforeAction(user_id, otp_code)`
  - Verifies the OTP code if the user has OTP enabled; resolves true automatically when OTP is disabled.
  - `user_id` = the user id
  - `otp_code` = the 6-digit OTP code to verify
  - Returns a promise resolving to true (rejects with `INVALID_OTP_CODE` if wrong)
	```javascript
	tools.security.verifyOtpBeforeAction(42, '123456')
		.then((valid) => {
			/*
				valid => true when OTP is valid or not required
			*/
		});
	```

- `verifyOtp(userSecret, userDigits)`
  - Checks a TOTP code against the secret across a +/-30s window.
  - `userSecret` = the user's OTP secret
  - `userDigits` = the 6-digit code submitted by the user
  - Returns boolean value
	```javascript
	const valid = tools.security.verifyOtp('JBSWY3DPEHPK3PXP', '123456'); // true / false
	```

- `checkOtp(userId)`
  - Ensures OTP is not already enabled, then returns the user's pending (unused) OTP code row.
  - `userId` = the user id
  - Returns a promise with the unused otp code row (rejects if OTP already enabled)
	```javascript
	tools.security.checkOtp(42)
		.then((otpRow) => {
			/*
				otpRow => { id: 7, secret: 'JBSWY3DPEHPK3PXP' }
			*/
		});
	```

- `generateOtp(secret [, epoch = 0])`
  - Generates a TOTP code from a secret for a given time offset.
  - `secret` = the OTP secret
  - `epoch` = time offset in seconds (e.g. 30, -30) for window checks
  - Returns the TOTP string (synchronous)
	```javascript
	const code = tools.security.generateOtp('JBSWY3DPEHPK3PXP'); // e.g. '123456'
	```

- `generateOtpSecret()`
  - Generates a new random OTP secret seed.
  - Returns the secret string (synchronous)
	```javascript
	const secret = tools.security.generateOtpSecret(); // e.g. 'JBSWY3DPEHPK3PXP'
	```

- `getUserOtpCode(user_id [, usedParam = true])`
  - Fetches the user's most recent OTP code row and returns a current TOTP value for it.
  - `user_id` = the user id
  - `usedParam` = whether to match used (true) or unused (false) codes
  - Returns a promise resolving to a TOTP string
	```javascript
	tools.security.getUserOtpCode(42)
		.then((code) => {
			/*
				code => '654321'
			*/
		});
	```

- `findUserOtp(user_id)`
  - Finds the user's pending unused OTP code row.
  - `user_id` = the user id
  - Returns a promise with the otp code row ({ id, secret }) or null
	```javascript
	tools.security.findUserOtp(42)
		.then((otpRow) => {
			/*
				otpRow => { id: 7, secret: 'JBSWY3DPEHPK3PXP' }
			*/
		});
	```

- `setActiveUserOtp(user_id)`
  - In a transaction, marks the user's pending OTP code as used and enables OTP on the user.
  - `user_id` = the user id
  - Returns a promise with the updated user model instance
	```javascript
	tools.security.setActiveUserOtp(42)
		.then((user) => {
			/*
				user => updated user with otp_enabled set to true
			*/
		});
	```

- `updateUserOtpEnabled(id [, otp_enabled = false] [, transaction])`
  - Updates the user's `otp_enabled` flag.
  - `id` = the user id
  - `otp_enabled` = the new boolean value
  - `transaction` = optional Sequelize transaction to run within
  - Returns a promise with the updated user model instance
	```javascript
	tools.security.updateUserOtpEnabled(42, false)
		.then((user) => {
			/*
				user => updated user with otp_enabled set to false
			*/
		});
	```

- `createOtp(user_id)`
  - Creates a new OTP code record (with a fresh secret) for the user.
  - `user_id` = the user id
  - Returns a promise resolving to the generated OTP secret
	```javascript
	tools.security.createOtp(42)
		.then((secret) => {
			/*
				secret => 'JBSWY3DPEHPK3PXP'
			*/
		});
	```

- `userHasOtpEnabled(userId)`
  - Returns the user's `otp_enabled` flag, throwing if the user does not exist.
  - `userId` = the user id
  - Returns a promise resolving to a boolean (rejects with `USER_NOT_FOUND` if missing)
	```javascript
	tools.security.userHasOtpEnabled(42)
		.then((enabled) => {
			/*
				enabled => true / false
			*/
		});
	```

- `checkUserOtpActive(userId, otpCode)`
  - Asserts the user has OTP enabled and the supplied code is valid; otherwise throws.
  - `userId` = the user id
  - `otpCode` = the OTP code to validate
  - Returns a promise that resolves (undefined) when OTP is active and valid
	```javascript
	tools.security.checkUserOtpActive(42, '123456')
		.then(() => {
			/*
				resolves with undefined when OTP is enabled and the code is valid
			*/
		});
	```

- `verifyBearerTokenPromise(token, ip [, scopes = BASE_SCOPES])`
  - Verifies a Bearer JWT, checks scopes, issuer, frozen-user status, and an active session.
  - `token` = the full `Bearer <jwt>` header value
  - `ip` = requester IP (used for logging)
  - `scopes` = allowed scopes; rejects if none intersect the token scopes
  - Returns a promise resolving to the decoded token payload
	```javascript
	tools.security.verifyBearerTokenPromise('Bearer eyJhbGci...', '192.168.0.1', ['user'])
		.then((decoded) => {
			/*
				decoded => { sub: { id: 42, email: 'user@example.com', networkId: 7 }, scopes: ['user'], iss: '...' }
			*/
		});
	```

- `verifyHmacTokenPromise(apiKey, apiSignature, apiExpires, method, originalUrl, body [, permissions = []] [, ip])`
  - Validates an HMAC API key request: key lookup, IP whitelist, expiry, active flag, permissions, and signature.
  - `apiKey` = the public api-key header
  - `apiSignature` = the api-signature header
  - `apiExpires` = the api-expires header (unix seconds)
  - `method` = HTTP method
  - `originalUrl` = the request path used in the signature
  - `body` = the request body used in the signature
  - `permissions` = required token permissions (e.g. ['can_read'])
  - `ip` = requester IP, checked against the token whitelist
  - Returns a promise resolving to an auth object ({ sub, scopes, is_subaccount })
	```javascript
	tools.security.verifyHmacTokenPromise('apikey123', 'sig...', 1717689600, 'GET', '/v2/user', '', ['can_read'], '192.168.0.1')
		.then((auth) => {
			/*
				auth => { sub: { id: 42, email: 'user@example.com', networkId: 7 }, scopes: ['user'], is_subaccount: false }
			*/
		});
	```

- `verifyAuthTokenMiddleware(req, authOrSecDef, token, cb [, isSocket = false])`
  - Swagger security middleware that dispatches to Bearer or HMAC verification based on the request headers and endpoint security types.
  - `req` = the request object (with swagger metadata and headers)
  - `authOrSecDef` = the swagger security definition
  - `token` = the auth token being checked
  - `cb` = callback invoked with null on success
  - `isSocket` = whether the call is for a socket connection (changes error handling)
  - Returns nothing; invokes `cb` or sends an HTTP error response
	```javascript
	tools.security.verifyAuthTokenMiddleware(req, secDef, req.headers.authorization, (err) => {
		/*
			err is null when authentication succeeds
		*/
	});
	```

- `verifyBearerTokenMiddleware(req, authOrSecDef, token, cb [, isSocket = false])`
  - Verifies a Bearer JWT from request headers, enforcing single-auth-header, issuer, frozen-user, session, and permission checks.
  - `req` = the request object
  - `authOrSecDef` = the swagger security definition
  - `token` = the `Bearer <jwt>` header value
  - `cb` = callback invoked with null on success
  - `isSocket` = whether the call is for a socket connection
  - Returns nothing; invokes `cb(null)` or sends/returns an access-denied error
	```javascript
	tools.security.verifyBearerTokenMiddleware(req, secDef, req.headers.authorization, (err) => {
		/*
			err is null when the bearer token is valid
		*/
	});
	```

- `verifyHmacTokenMiddleware(req, definition, apiKey, cb [, isSocket = false])`
  - Verifies an HMAC api-key request from headers and attaches the resolved auth to `req.auth`.
  - `req` = the request object (headers, method, originalUrl, body, swagger)
  - `definition` = the swagger security definition
  - `apiKey` = the api-key header value
  - `cb` = callback invoked on success
  - `isSocket` = whether the call is for a socket connection
  - Returns nothing; invokes `cb()` or sends/returns an access-denied error
	```javascript
	tools.security.verifyHmacTokenMiddleware(req, secDef, req.headers['api-key'], (err) => {
		/*
			err is undefined and req.auth is set when the HMAC key is valid
		*/
	});
	```

- `verifyNetworkHmacToken(req)`
  - Validates an HMAC request signed with the network operator key/secret.
  - `req` = the request object (api-key, api-signature, api-expires headers, method, originalUrl, body)
  - Returns a promise that resolves (undefined) when the network signature is valid
	```javascript
	tools.security.verifyNetworkHmacToken(req)
		.then(() => {
			/*
				resolves with undefined when the network HMAC token is valid
			*/
		});
	```

- `userScopeIsValid(endpointScopes, userScopes)`
  - Checks whether the user's scopes intersect the endpoint's authorized scopes.
  - `endpointScopes` = array of scopes allowed for the endpoint
  - `userScopes` = array of the user's scopes
  - Returns boolean value
	```javascript
	const allowed = tools.security.userScopeIsValid(['admin'], ['user']); // false
	```

- `userIsDeactivated(deactivatedUsers, userId)`
  - Checks whether a user id appears in the deactivated-users map.
  - `deactivatedUsers` = object/map keyed by deactivated user ids
  - `userId` = the user id to check
  - Returns boolean value
	```javascript
	const deactivated = tools.security.userIsDeactivated({ 42: true }, 42); // true
	```

- `findToken(query)`
  - Finds a single token record matching the given Sequelize query.
  - `query` = the Sequelize query object (e.g. `{ where: { id, user_id } }`)
  - Returns a promise with the token model instance or null
	```javascript
	tools.security.findToken({ where: { id: 5, user_id: 42 } })
		.then((token) => {
			/*
				token => Sequelize token instance or null
			*/
		});
	```

- `issueToken(id, networkId, email, ip [, expiresIn] [, lang = 'en'] [, permissions = []] [, configs = []] [, role = 'user'] [, extra = {}])`
  - Signs and returns a JWT for the user, adding the role scope when the IP is admin-whitelisted.
  - `id` = the user id
  - `networkId` = the network user id
  - `email` = the user's email
  - `ip` = requester IP (checked against the admin whitelist for scope elevation)
  - `expiresIn` = token lifetime (defaults to the configured token time)
  - `lang` = language stored in the token subject
  - `role` = user role, normalized to 'user' when empty
  - `extra` = additional claims merged into the token payload
  - Returns the signed JWT string (synchronous)
	```javascript
	const token = tools.security.issueToken(42, 7, 'user@example.com', '192.168.0.1');
	// token => 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...'
	```

- `getUserKitHmacTokens(userId)`
  - Lists a user's active HMAC tokens with masked secrets.
  - `userId` = the user id
  - Returns a promise resolving to `{ count, data }` of formatted token objects
	```javascript
	tools.security.getUserKitHmacTokens(42)
		.then((result) => {
			/*
				result => {
					count: 1,
					data: [{ id: 5, name: 'bot', apiKey: 'abc...', secret: 'def********', active: true, can_read: true, ... }]
				}
			*/
		});
	```

- `createUserKitHmacToken(userId, otpCode, ip, name [, role = ROLES.USER] [, whitelisted_ips])`
  - Creates a new HMAC API token after OTP verification; admin-role tokens require a whitelist and admin user.
  - `userId` = the user id
  - `otpCode` = OTP code, validated via `checkUserOtpActive`
  - `ip` = IP recorded on the token
  - `name` = a label for the token
  - `role` = token role ('user' or 'admin')
  - `whitelisted_ips` = required IP whitelist when role is admin
  - Returns a promise with the created token model instance
	```javascript
	tools.security.createUserKitHmacToken(42, '123456', '192.168.0.1', 'trading-bot')
		.then((token) => {
			/*
				token => created Sequelize token with key, secret, expiry, can_read: true
			*/
		});
	```

- `updateUserKitHmacToken(userId, otpCode, ip, token_id, name, permissions, whitelisted_ips, whitelisting_enabled)`
  - Updates an existing HMAC token's name, permissions, and whitelist after OTP verification.
  - `userId` = the user id (owner of the token)
  - `otpCode` = OTP code, validated via `checkUserOtpActive`
  - `token_id` = id of the token to update
  - `name` = new token name
  - `permissions` = object of permission flags (can_read/can_trade/can_withdraw)
  - `whitelisted_ips` = new IP whitelist (cannot be emptied for admin tokens)
  - `whitelisting_enabled` = toggle whitelisting (cannot be disabled for admin tokens)
  - Returns a promise resolving to the formatted token object
	```javascript
	tools.security.updateUserKitHmacToken(42, '123456', '192.168.0.1', 5, 'bot', { can_trade: true }, ['192.168.0.1'], true)
		.then((token) => {
			/*
				token => { id: 5, name: 'bot', apiKey: 'abc...', secret: 'def********', can_trade: true, ... }
			*/
		});
	```

- `deleteUserKitHmacToken(userId, otpCode, tokenId)`
  - Deactivates and revokes a user's HMAC token after OTP verification, clearing it from the Redis cache.
  - `userId` = the user id (owner of the token)
  - `otpCode` = OTP code, validated via `checkUserOtpActive`
  - `tokenId` = id of the token to revoke
  - Returns a promise resolving to the formatted (now revoked) token object
	```javascript
	tools.security.deleteUserKitHmacToken(42, '123456', 5)
		.then((token) => {
			/*
				token => { id: 5, active: false, revoked: true, ... }
			*/
		});
	```

- `checkHmacSignature(secret, { body, headers, method, originalUrl })`
  - Recomputes the HMAC signature for a request and compares it to the supplied `api-signature` header.
  - `secret` = the token's secret used for signing
  - `body` / `headers` / `method` / `originalUrl` = request parts (headers must include api-signature and api-expires)
  - Returns boolean value
	```javascript
	const valid = tools.security.checkHmacSignature('tokensecret', {
		body: '',
		headers: { 'api-signature': 'abc...', 'api-expires': 1717689600 },
		method: 'GET',
		originalUrl: '/v2/user'
	}); // true / false
	```

- `createHmacSignature(secret, verb, path, expires [, data = ''])`
  - Computes an HMAC-SHA256 signature over verb + path + expires + data.
  - `secret` = the signing secret
  - `verb` = HTTP method
  - `path` = request path
  - `expires` = expiry (unix seconds) included in the signed string
  - `data` = request body (string or object, stringified)
  - Returns the hex signature string (synchronous)
	```javascript
	const sig = tools.security.createHmacSignature('tokensecret', 'GET', '/v2/user', 1717689600);
	// sig => 'a1b2c3...'
	```

- `isValidScope(endpointScopes, userScopes)`
  - Checks whether the user's scopes intersect the endpoint's scopes.
  - `endpointScopes` = array of scopes allowed for the endpoint
  - `userScopes` = array of the user's scopes
  - Returns boolean value
	```javascript
	const allowed = tools.security.isValidScope(['user'], ['user']); // true
	```

- `verifyBearerTokenExpressMiddleware([scopes = BASE_SCOPES])`
  - Returns an Express middleware that verifies a Bearer JWT, scope, issuer, frozen-user, session, and permission checks.
  - `scopes` = allowed scopes for the route (defaults to base scopes)
  - Returns an Express middleware `(req, res, next)`
	```javascript
	app.get('/protected', tools.security.verifyBearerTokenExpressMiddleware(['admin']), (req, res) => {
		/*
			req.auth holds the decoded token when authentication passes
		*/
	});
	```

- `getPasskeyConfig(req)`
  - Builds WebAuthn/passkey config (relying-party id/name and allowed origins) from the request, kit config, and allowed domains.
  - `req` = the request object (origin/x-real-origin headers used to derive rpID)
  - Returns `{ rpName, rpID, allowedOrigins }` (synchronous)
	```javascript
	const cfg = tools.security.getPasskeyConfig(req);
	/*
		cfg => { rpName: 'HollaEx', rpID: 'exchange.com', allowedOrigins: ['https://exchange.com', ...] }
	*/
	```

- `getCountryFromIp(ip [, headers = {}])`
  - Resolves a 2-letter country code, preferring a trusted Cloudflare header, then GeoIP lookup.
  - `ip` = the IP address to geolocate
  - `headers` = request headers (checked for a trusted cf-ipcountry value)
  - Returns the country code string (synchronous, '' if unknown)
	```javascript
	const country = tools.security.getCountryFromIp('8.8.8.8'); // 'US'
	```

- `getCountryFromHeaders([headers = {}])`
  - Returns the Cloudflare-provided country code, but only when the operator has enabled trusting that header.
  - `headers` = request headers containing `cf-ipcountry`
  - Returns the uppercase country code string (synchronous, '' if disabled/unknown)
	```javascript
	const country = tools.security.getCountryFromHeaders({ 'cf-ipcountry': 'us' }); // 'US' or ''
	```

- `checkIp([remoteip = ''] [, headers = {}])`
  - Throws if the request's resolved country is in the kit's blacklisted-countries geofence.
  - `remoteip` = the requester IP
  - `headers` = request headers used for country resolution
  - Returns a promise that resolves (undefined) when the IP is allowed (rejects with 'ERROR IP LOCATION' if blocked)
	```javascript
	tools.security.checkIp('8.8.8.8', req.headers)
		.then(() => {
			/*
				resolves with undefined when the IP's country is not blacklisted
			*/
		});
	```

- `sendConfirmationEmail(userId, domain)`
  - Generates a random confirmation code (5-min TTL in Redis) and emails it to the user.
  - `userId` = the user id
  - `domain` = domain passed to the verification email
  - Returns a promise that resolves once the confirmation email is sent (rejects with `USER_NOT_FOUND` if missing)
	```javascript
	tools.security.sendConfirmationEmail(42, 'https://exchange.com')
		.then(() => {
			/*
				resolves with undefined after the confirmation email is dispatched
			*/
		});
	```

- `confirmByEmail(userId, givenCode)`
  - Timing-safe compares a submitted code against the stored confirmation code and clears it on success.
  - `userId` = the user id
  - `givenCode` = the code submitted by the user
  - Returns a promise resolving to a boolean (true if the code matches)
	```javascript
	tools.security.confirmByEmail(42, 'abc123def456')
		.then((confirmed) => {
			/*
				confirmed => true when the code matches
			*/
		});
	```

- `calculateSignature([secret = ''], verb, path, nonce [, data = ''])`
  - Computes an HMAC-SHA256 signature over verb + path + nonce + data.
  - `secret` = the signing secret
  - `verb` = HTTP method
  - `path` = request path
  - `nonce` = the api-expires/nonce value included in the signed string
  - `data` = request body (string or object, stringified)
  - Returns the hex signature string (synchronous)
	```javascript
	const sig = tools.security.calculateSignature('tokensecret', 'GET', '/v2/user', 1717689600);
	// sig => 'a1b2c3...'
	```

- `generateDashToken([opts = { additionalHeaders: null }])`
  - Delegates to the network library to generate a dash token.
  - `opts.additionalHeaders` = optional extra headers passed to the network lib
  - Returns a promise resolving to the dash token
	```javascript
	tools.security.generateDashToken({ additionalHeaders: null })
		.then((token) => {
			/*
				token => network-issued dash token
			*/
		});
	```

- `createSession(token, loginId, userId [, expiry = null] [, meta = {}])`
  - Creates a session record keyed by an md5 hash of the JWT, with expiry derived from the token's `exp` claim.
  - `token` = the JWT whose payload provides the expiry
  - `loginId` = the associated login id
  - `userId` = the user id (role read from the user record)
  - `meta` = optional metadata stored on the session
  - Returns a promise with the created session model instance
	```javascript
	tools.security.createSession('eyJhbGci...', 1001, 42)
		.then((session) => {
			/*
				session => { id: 9, token: '<md5hash>', role: 'user', login_id: 1001, status: true, expiry_date: ... }
			*/
		});
	```

- `verifySession(token)`
  - Looks up a session by token hash and validates status, expiry, and refreshes last_seen (and Redis cache) when stale.
  - `token` = the JWT whose hash identifies the session
  - Returns a promise resolving to the session object (rejects with `SESSION_NOT_FOUND`, `TOKEN_REVOKED`, or `TOKEN_EXPIRED`)
	```javascript
	tools.security.verifySession('eyJhbGci...')
		.then((session) => {
			/*
				session => { id: 9, status: true, expiry_date: ..., last_seen: ... }
			*/
		});
	```

- `findSession(token)`
  - Finds a session by md5 token hash, checking Redis first and falling back to the database (caching the result).
  - `token` = the JWT whose hash identifies the session
  - Returns a promise resolving to the session object (or null if not found)
	```javascript
	tools.security.findSession('eyJhbGci...')
		.then((session) => {
			/*
				session => { id: 9, token: '<md5hash>', status: true, expiry_date: ... } or null
			*/
		});
	```

#### Tier functions

- `findTier(level)`
  - Finds a single tier by its level (id), throwing if it does not exist.
  - `level` = tier id/level to look up
  - Returns a promise resolving to the tier record (rejects if the tier does not exist)
	```javascript
	tools.tier.findTier(1)
		.then((data) => {
			/*
				{
					id: 1,
					name: 'Tier 1',
					icon: '',
					description: 'Basic tier',
					deposit_limit: 0,
					withdrawal_limit: 0,
					fees: { maker: { 'xht-usdt': 0.1 }, taker: { 'xht-usdt': 0.1 } },
					note: '',
					native_currency_limit: true
				}
			*/
		});
	```

- `createTier(level, name, icon, description [, fees = {}, note = ''])`
  - Creates a new tier with per-pair maker/taker fees, validating subscribed pairs and minimum fees.
  - `level` = tier id/level for the new tier (must not already exist)
  - `fees` = object with `maker` and `taker` maps keyed by pair, each supporting a `default` value applied to unspecified pairs
  - `note` = optional internal note for the tier
  - Returns a promise resolving to the created tier record (rejects on duplicate level, unsubscribed pair, or fee below minimum)
	```javascript
	tools.tier.createTier(
		3,
		'VIP',
		'',
		'VIP tier',
		{ maker: { default: 0.05 }, taker: { default: 0.1 } },
		'high volume'
	)
		.then((data) => {
			/*
				{
					id: 3,
					name: 'VIP',
					icon: '',
					description: 'VIP tier',
					fees: {
						maker: { 'xht-usdt': 0.05 },
						taker: { 'xht-usdt': 0.1 }
					},
					note: 'high volume'
				}
			*/
		});
	```

- `updateTier(level, updateData, auditInfo)`
  - Updates a tier's metadata (name, icon, note, description, native_currency_limit); fees cannot be changed here.
  - `level` = tier id/level to update (must exist)
  - `updateData` = object of fields to change; `fees` is rejected, other fields validated by type
  - `auditInfo` = `{ userEmail, sessionId, apiPath, method }` used to record an audit log entry
  - Returns a promise resolving to the updated tier record (rejects if tier missing or `fees` is supplied)
	```javascript
	tools.tier.updateTier(
		2,
		{ name: 'Silver', description: 'Updated description' },
		{ userEmail: 'admin@example.com', sessionId: 'abc', apiPath: '/tier', method: 'PUT' }
	)
		.then((data) => {
			/*
				{
					id: 2,
					name: 'Silver',
					description: 'Updated description',
					...
				}
			*/
		});
	```

- `updatePairFees(feesByPair, auditInfo)`
  - Updates maker/taker fees for specific pairs across one or more tiers within a transaction.
  - `feesByPair` = object keyed by pair, each mapping tier id to `{ maker, taker }` fee values
  - `auditInfo` = `{ userEmail, sessionId, apiPath, method }` used to record an audit log entry
  - Returns a promise resolving to a map of updated tier records keyed by tier id (rejects on no pairs, invalid pair, invalid tier, or fee below minimum)
	```javascript
	tools.tier.updatePairFees(
		{ 'xht-usdt': { '1': { maker: 0.1, taker: 0.2 } } },
		{ userEmail: 'admin@example.com', sessionId: 'abc', apiPath: '/tier/fees', method: 'PUT' }
	)
		.then((data) => {
			/*
				{
					'1': {
						id: 1,
						fees: {
							maker: { 'xht-usdt': 0.1 },
							taker: { 'xht-usdt': 0.2 }
						},
						...
					}
				}
			*/
		});
	```

- `updateTiersLimits(limits)`
  - Updates deposit and withdrawal limits for one or more tiers within a transaction and broadcasts the change.
  - `limits` = object keyed by tier level, each mapping to `{ deposit_limit, withdrawal_limit }` (values must be -1 or >= 0)
  - Returns a promise that resolves once all tier limits are updated and published (no resolved value; rejects on invalid tier level or limit)
	```javascript
	tools.tier.updateTiersLimits({
		'1': { deposit_limit: 1000, withdrawal_limit: 500 },
		'2': { deposit_limit: -1, withdrawal_limit: -1 }
	})
		.then(() => {
			/*
				resolves with no value once limits are saved
			*/
		});
	```

- `updateTransactionLimit(id, data)`
  - Creates or updates a withdrawal transaction limit, validating coins, tier, amounts, and uniqueness per tier/currency/type.
  - `id` = existing transaction limit id to update; omit/falsy to create a new record
  - `data` = `{ tier, currency, amount, limit_currency, type, monthly_amount }`; `limit_currency` must be `'default'` or equal to `currency`; `type` 'deposit' is not supported
  - Returns a promise resolving to the created or updated transaction limit record (rejects on invalid coin, negative values, conflicting amounts, or duplicate record)
	```javascript
	tools.tier.updateTransactionLimit(null, {
		tier: 1,
		currency: 'usdt',
		amount: 1000,
		limit_currency: 'default',
		type: 'withdrawal',
		monthly_amount: 10000
	})
		.then((data) => {
			/*
				{
					id: 5,
					tier: 1,
					amount: 1000,
					monthly_amount: 10000,
					currency: 'usdt',
					limit_currency: 'default',
					type: 'withdrawal'
				}
			*/
		});
	```

- `getTransactionLimits()`
  - Retrieves all transaction limit records with a total count.
  - Returns a promise resolving to `{ count, data }` where `data` is the array of transaction limit records
	```javascript
	tools.tier.getTransactionLimits()
		.then((data) => {
			/*
				{
					count: 2,
					data: [
						{ id: 1, tier: 1, amount: 1000, monthly_amount: 10000, currency: 'usdt', limit_currency: 'default', type: 'withdrawal' },
						{ id: 2, tier: 2, amount: -1, monthly_amount: -1, currency: 'usdt', limit_currency: 'default', type: 'withdrawal' }
					]
				}
			*/
		});
	```

- `findTransactionLimit([opts = { id, tier, amount, currency, limit_currency, type, monthly_amount }])`
  - Finds a single transaction limit matching the provided (truthy) filter fields.
  - `opts` = object of optional filters; only truthy keys are applied to the query
  - Returns a promise resolving to the matching transaction limit record, or null if none found
	```javascript
	tools.tier.findTransactionLimit({ tier: 1, limit_currency: 'default', type: 'withdrawal' })
		.then((data) => {
			/*
				{
					id: 1,
					tier: 1,
					amount: 1000,
					monthly_amount: 10000,
					currency: 'usdt',
					limit_currency: 'default',
					type: 'withdrawal'
				}
			*/
		});
	```

- `findTransactionLimitPerTier(tier, type)`
  - Finds all transaction limits for a given tier and transaction type.
  - `tier` = tier level to filter by
  - `type` = transaction type (e.g. `'withdrawal'`)
  - Returns a promise resolving to an array of matching transaction limit records
	```javascript
	tools.tier.findTransactionLimitPerTier(1, 'withdrawal')
		.then((data) => {
			/*
				[
					{ id: 1, tier: 1, amount: 1000, monthly_amount: 10000, currency: 'usdt', limit_currency: 'default', type: 'withdrawal' }
				]
			*/
		});
	```

- `deleteTransactionLimit(id)`
  - Deletes a transaction limit by id, unless it is the only limit remaining for its tier and type.
  - `id` = transaction limit id to delete
  - Returns a promise resolving to the destroyed record (rejects if the record does not exist or is the last limit for its tier/type)
	```javascript
	tools.tier.deleteTransactionLimit(2)
		.then((data) => {
			/*
				resolves with the deleted transaction limit instance
			*/
		});
	```

#### Database functions

- These functions are basically Sequelize functionalities

- `getModel(table)`
  - Get the Sequelize model for a given table name.
  - Returns the Sequelize model object.
	```javascript
	tools.database.getModel('user');
	```

- `create(table, query = {}, options = {})`
  - Create a new record in the table.
  - Returns a promise with the created Sequelize object.
	```javascript
	tools.database.create('user', { email: 'test@hollaex.com' })
		.then((data) => {
			// data
		});
	```

- `destroy(table, query = {}, options = {})`
  - Delete record(s) from the table.
  - Returns a promise with the number of destroyed rows.
	```javascript
	tools.database.destroy('user', { where: { id: 1 } })
		.then((data) => {
			// data
		});
	```

- `update(table, query = {}, options = {})`
  - Update record(s) in the table.
  - Returns a promise with the number of affected rows.
	```javascript
	tools.database.update('user', { verification_level: 2 }, { where: { id: 1 } })
		.then((data) => {
			// data
		});
	```

- `createModel(name, properties = {}, options = { timestamps: true, underscored: true })`
  - Define a new Sequelize model with the given properties (an auto-incrementing primary key `id` is always added).
  - Returns the Sequelize model object.
	```javascript
	tools.database.createModel('custom table', { name: { type: 'string' } });
	```

- `associateModel(model, association, associatedModel, options = {})`
  - Create a Sequelize association (e.g. hasOne, belongsTo) between a model and another model.
  - Returns undefined.
	```javascript
	tools.database.associateModel(model, 'belongsTo', 'user');
	```

- `findOne(table, query = {}, model)`
  - Find a single record matching the query.
  - Returns a promise with the Sequelize object (or null).
	```javascript
	tools.database.findOne('user', { where: { id: 1 } })
		.then((data) => {
			// data
		});
	```

- `findAll(table, query = {}, model)`
  - Find all records matching the query.
  - Returns a promise with an array of Sequelize objects.
	```javascript
	tools.database.findAll('user', { where: { verification_level: 1 } })
		.then((data) => {
			// data
		});
	```

- `findAndCountAll(table, query = {}, model)`
  - Find and count all records matching the query.
  - Returns a promise with a Sequelize object in `{ count, rows }` format.
	```javascript
	tools.database.findAndCountAll('user', { where: { verification_level: 1 } })
		.then((data) => {
			// data
		});
	```

- `findAndCountAllWithRows(table, query = {}, model)`
  - Find and count all records matching the query, formatted into `count`/`data` format.
  - Returns a promise with an object in `{ count, data }` format.
	```javascript
	tools.database.findAndCountAllWithRows('user', { where: { verification_level: 1 } })
		.then((data) => {
			// data
		});
	```

- `fetchAllRecords(table, query, opts = {})`
  - Stream and fetch all records matching the query using a streamed Postgres query (handles `created_at`/`timestamp` ranges and supports an `onRow` callback for streaming). Throws if no table name is provided.
  - Returns a promise with an object in `{ count, data }` format.
	```javascript
	tools.database.fetchAllRecords('user', { where: { verification_level: 1 } })
		.then((data) => {
			// data
		});
	```

- `paginationQuery(limit = 50, page = 1)`
  - Build a Sequelize pagination object (max limit of 50). Default is `{ limit: 50, offset: 0 }`.
  - Returns an object with `limit` and `offset` keys.
	```javascript
	const pagination = tools.database.paginationQuery(50, 2);
	```

- `timeframeQuery(startDate = 0, endDate = moment().valueOf())`
  - Build a Sequelize timeframe object to filter a column between two timestamps (ISO 8601).
  - Returns a Sequelize timeframe object with `[Op.gte]` and `[Op.lte]` keys.
	```javascript
	const timeframe = tools.database.timeframeQuery('2020-01-01T00:00:00.000Z', '2020-12-31T00:00:00.000Z');
	```

- `orderingQuery(orderBy = 'id', order = 'desc')`
  - Build a Sequelize ordering array. Default is `['id', 'desc']`.
  - Returns a Sequelize ordering array.
	```javascript
	const ordering = tools.database.orderingQuery('created_at', 'asc');
	```

- `convertSequelizeCountAndRows(data)`
  - Format the result of a Sequelize `findAndCountAll` query (`{ count, rows }`) into `count`/`data` format.
  - Returns an object in `{ count, data }` format.
	```javascript
	const formatted = tools.database.convertSequelizeCountAndRows(data);
	```

- `models`
  - The collection of all defined Sequelize models (including the `sequelize` instance).
	```javascript
	tools.database.models.User;
	```

- `Redis`
  - The tools library also includes a redis client, publisher, and subscriber. They can be accessed like below.

- `tools.database.client`
  - Redis client for setting and getting key/value data.
	```javascript
	tools.database.client.setAsync('key', 'value');
	```

- `tools.database.publisher`
  - Redis publisher for publishing messages to channels.
	```javascript
	tools.database.publisher.publish('channel', 'message');
	```

- `tools.database.subscriber`
  - Redis subscriber for subscribing to channels and receiving messages.
	```javascript
	tools.database.subscriber.subscribe('channel');
	```

