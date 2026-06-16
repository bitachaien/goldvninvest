const {
    request,
    generateFuzz,
    loginAs,
    getAdminUser
} = require('../helpers');
const tools = require('hollaex-tools-lib');
const { DEFAULT_ORDER_RISK_PERCENTAGE } = require('../../constants');


describe('tests for /user/settings', function () {

    let user, bearerToken;
    before(async () => {
        user = await tools.user.getUserByEmail(getAdminUser().email);
        user.should.be.an('object');
        bearerToken = await loginAs(user);
        bearerToken.should.be.a('string');
    });


    it('Integration Test -should respond 200 for "Success"', async () => {

        const responseFirst = await request()
        .put('/v2/user/settings')
        .set('Authorization', `Bearer ${bearerToken}`)
        .send({ 
            "risk": {
            "order_portfolio_percentage": 80
        }});

        responseFirst.should.have.status(200);
        responseFirst.should.be.json;

        responseFirst.body.settings.risk.order_portfolio_percentage.should.equal(80);

        const responseSecond = await request()
        .put('/v2/user/settings')
        .set('Authorization', `Bearer ${bearerToken}`)
        .send({ 
            "risk": {
            "order_portfolio_percentage": 90
        }});

        responseSecond.should.have.status(200);
        responseSecond.should.be.json;

        responseSecond.body.settings.risk.order_portfolio_percentage.should.equal(90)
    });

    it('Integration Test - should update date and time format preferences', async () => {
        const response = await request()
            .put('/v2/user/settings')
            .set('Authorization', `Bearer ${bearerToken}`)
            .send({
                interface: {
                    date_format: 'DD/MM/YYYY',
                    time_format: '24h'
                }
            });

        response.should.have.status(200);
        response.should.be.json;
        response.body.settings.interface.date_format.should.equal('DD/MM/YYYY');
        response.body.settings.interface.time_format.should.equal('24h');
    });

    it('Integration Test - should ignore verification_method in user settings', async () => {
        const response = await request()
            .put('/v2/user/settings')
            .set('Authorization', `Bearer ${bearerToken}`)
            .send({ verification_method: 'email' });

        response.should.have.status(200);
        response.should.be.json;
        response.body.settings.should.not.have.property('verification_method');
    });

    it('Integration Test - should fill legacy settings with missing nested fields', async () => {
        const User = tools.database.getModel('user');
        const originalUser = await tools.user.getUserByEmail(user.email);
        const legacySettings = {
            chat: {
                set_username: true
            },
            audio: {
                all: false,
                order_placed: true,
                public_trade: false,
                click_amounts: true,
                order_canceled: true,
                order_completed: true,
                quick_trade_success: true,
                quick_trade_timeout: true,
                get_quote_quick_trade: true,
                order_partially_completed: true
            },
            language: 'fa',
            interface: {
                theme: 'dark',
                order_book_levels: 20
            }
        };

        try {
            await User.update({ settings: legacySettings }, { where: { id: user.id } });

            const getResponse = await request()
                .get('/v2/user')
                .set('Authorization', `Bearer ${bearerToken}`);

            getResponse.should.have.status(200);
            getResponse.body.settings.notification.popup_order_confirmation.should.equal(true);
            getResponse.body.settings.notification.popup_order_completed.should.equal(true);
            getResponse.body.settings.notification.popup_order_partially_filled.should.equal(true);
            getResponse.body.settings.interface.date_format.should.equal('MM/DD/YYYY');
            getResponse.body.settings.interface.time_format.should.equal('12h');
            getResponse.body.settings.risk.order_portfolio_percentage.should.equal(DEFAULT_ORDER_RISK_PERCENTAGE);

            const updateResponse = await request()
                .put('/v2/user/settings')
                .set('Authorization', `Bearer ${bearerToken}`)
                .send({
                    notification: {
                        popup_order_completed: false
                    },
                    risk: {
                        popup_warning: false
                    }
                });

            updateResponse.should.have.status(200);
            updateResponse.body.settings.notification.popup_order_completed.should.equal(false);
            updateResponse.body.settings.notification.popup_order_confirmation.should.equal(true);
            updateResponse.body.settings.notification.popup_order_partially_filled.should.equal(true);
            updateResponse.body.settings.interface.date_format.should.equal('MM/DD/YYYY');
            updateResponse.body.settings.interface.time_format.should.equal('12h');
            updateResponse.body.settings.risk.popup_warning.should.equal(false);
            updateResponse.body.settings.risk.order_portfolio_percentage.should.equal(DEFAULT_ORDER_RISK_PERCENTAGE);
        } finally {
            await User.update({ settings: originalUser.settings }, { where: { id: user.id } });
        }
    });

    it('Integration Test - should reject invalid date and time formats', async () => {
        const dateResponse = await request()
            .put('/v2/user/settings')
            .set('Authorization', `Bearer ${bearerToken}`)
            .send({
                interface: {
                    date_format: 'YYYY/MM/DD'
                }
            });

        dateResponse.should.have.status(400);

        const timeResponse = await request()
            .put('/v2/user/settings')
            .set('Authorization', `Bearer ${bearerToken}`)
            .send({
                interface: {
                    time_format: '12 Hours'
                }
            });

        timeResponse.should.have.status(400);
    });

});