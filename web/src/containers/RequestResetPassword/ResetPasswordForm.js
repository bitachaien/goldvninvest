import React from 'react';
import { reduxForm } from 'redux-form';
import {
	requiredWithCustomMessage,
	emailOrPhone,
} from 'components/Form/validations';
import { AuthForm } from 'components';
import STRINGS from 'config/localizedStrings';

export const FORM_NAME = 'ResetPasswordForm';

export const generateFormFields = (theme) => ({
	value: {
		type: 'text',
		validate: [
			requiredWithCustomMessage(STRINGS['VALIDATIONS.REQUIRED']),
			emailOrPhone,
		],
		fullWidth: true,
		label: 'Email or phone number',
		placeholder: 'Email or phone number',
	},
});

const Form = (props) => (
	<AuthForm {...props} buttonLabel={STRINGS['REQUEST_RESET_PASSWORD.BUTTON']} />
);

export default reduxForm({
	form: FORM_NAME,
})(Form);
