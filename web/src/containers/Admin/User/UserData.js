import React from 'react';
import moment from 'moment';
import { connect } from 'react-redux';
import { SubmissionError } from 'redux-form';
import { updateUserData } from './actions';
import { AdminHocForm } from '../../../components';
import { COUNTRIES_OPTIONS } from 'utils/countries';

const Form = AdminHocForm('USER_DATA', 'user_data');

const AddressFields = {
	country: {
		type: 'select',
		label: 'Country',
		options: COUNTRIES_OPTIONS,
	},
	address: {
		type: 'text',
		label: 'Address',
	},
	postal_code: {
		type: 'text',
		label: 'Postal Code',
	},
	city: {
		type: 'text',
		label: 'City',
	},
};

const BaseDataFields = {
	email: {
		type: 'text',
		label: 'Email',
		disabled: true,
	},
	full_name: {
		type: 'text',
		label: 'Full Name',
	},
	gender: {
		type: 'select',
		label: 'Gender',
		options: ['Man', 'Woman'],
	},
	nationality: {
		type: 'select',
		label: 'nationality',
		options: COUNTRIES_OPTIONS,
	},
	dob: {
		type: 'date',
		label: 'Date of birth',
		showTime: { format: 'HH:mm' },
		dateFormat: 'YYYY/MM/DD HH:mm',
	},
	phone_number: {
		type: 'text',
		label: 'Phone Number',
	},
};

const onSubmit = (dataFields, onChangeSuccess, handleClose) => (values) => {
	const submitData = {
		id: values.id,
		address: {},
	};

	Object.keys(dataFields).forEach((key) => {
		if (key === 'gender') {
			submitData[key] = values[key] === 'Woman';
		} else if (key === 'dob' && values[key]) {
			const momentValue = moment.isMoment(values[key])
				? values[key]
				: moment(String(values[key]), dataFields?.dob?.dateFormat);
			submitData[key] = momentValue.toISOString();
		} else {
			submitData[key] = values[key];
		}
	});
	Object.keys(AddressFields).forEach((key) => {
		submitData.address[key] = values[key];
	});
	return updateUserData(submitData)
		.then((data) => {
			if (onChangeSuccess) {
				onChangeSuccess({
					...values,
					...submitData,
					...data,
				});
			}
			handleClose();
		})
		.catch((err) => {
			throw new SubmissionError({ _error: err.data.message });
		});
};

const generateInitialValues = (initialValues) => {
	const { dob = '' } = initialValues;
	return {
		...initialValues,
		...initialValues.address,
		gender: initialValues.gender ? 'Woman' : 'Man',
		dob: dob ? moment(dob) : dob,
	};
};

const UserData = ({
	initialValues,
	readOnly = false,
	onChangeSuccess,
	handleClose,
	handleNav,
}) => {
	const renderEditPopup = () => {
		return (
			<span className="text-underline" onClick={() => handleNav('email')}>
				Edit
			</span>
		);
	};

	const dataFields = { ...BaseDataFields };

	const fieldsData = {
		...dataFields,
		...AddressFields,
		email: {
			...dataFields.email,
			suffix: renderEditPopup(),
		},
	};

	return (
		<Form
			onSubmit={onSubmit(dataFields, onChangeSuccess, handleClose)}
			buttonText="SAVE"
			fields={fieldsData}
			initialValues={generateInitialValues(initialValues)}
			buttonClass="green-btn"
		/>
	);
};

const mapStateToProps = (state) => ({
	features: state.app.features,
	plugins: state.app.plugins,
});

export default connect(mapStateToProps)(UserData);
