import React from 'react';
import { reduxForm } from 'redux-form';
import { required, email, normalizeEmail } from 'components/Form/validations';
import { AuthForm } from 'components';
import STRINGS from 'config/localizedStrings';

export const FORM_NAME = 'LoginForm';

const Form = (props) => {
	const { turnstileEnabled } = props;
	const FormFields = {
		email: {
			type: 'email',
			validate: [required, email],
			fullWidth: true,
			normalize: normalizeEmail,
			label: STRINGS['FORM_FIELDS.EMAIL_LABEL'],
			placeholder: STRINGS['FORM_FIELDS.EMAIL_PLACEHOLDER'],
		},
		// Login intentionally validates only `required` on the password
		// field. The signup-time complexity validator (one letter + one digit
		// + min 8 chars) used to be applied here too, which blocked legacy
		// users with older/imported passwords from even submitting the form.
		password: {
			type: 'password',
			validate: [required],
			fullWidth: true,
			label: STRINGS['FORM_FIELDS.PASSWORD_LABEL'],
			placeholder: STRINGS['FORM_FIELDS.PASSWORD_PLACEHOLDER'],
		},
		...(turnstileEnabled
			? {
					captcha: {
						type: 'hidden',
						validate: [required],
					},
			  }
			: {}),
	};

	return (
		<AuthForm
			{...props}
			formFields={FormFields}
			buttonLabel={STRINGS['LOGIN_TEXT']}
		/>
	);
};
export default reduxForm({
	form: FORM_NAME,
})(Form);
