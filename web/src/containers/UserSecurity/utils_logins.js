import React from 'react';
import { getFormatTimestamp } from 'utils/utils';
import STRINGS from 'config/localizedStrings';
import { Button } from 'components';

export const generateLogins = () => {
	return [
		{
			label: STRINGS['ACCOUNT_SECURITY.LOGIN.IP_ADDRESS'],
			key: 'ip',
			renderCell: ({ ip }, key, index) => {
				return <td key={index}>{ip}</td>;
			},
		},
		{
			label: STRINGS['ACCOUNT_SECURITY.LOGIN.TIME'],
			key: 'timestamp',
			renderCell: ({ timestamp }, key, index) => {
				return <td key={index}>{getFormatTimestamp(timestamp)}</td>;
			},
		},
	];
};

export const RenderBtn = ({ closeDialog, setStep, step, goBack, label }) => {
	return (
		<div className="btn-wrapper">
			<Button
				onClick={() => {
					closeDialog ? closeDialog() : setStep(goBack);
				}}
				className="back-btn"
				label={STRINGS['ACCOUNT_SECURITY.OTP.BACK']}
				stringId="ACCOUNT_SECURITY.OTP.BACK"
				type="button"
			/>
			<Button
				onClick={() => {
					setStep(step);
				}}
				className="proceed-btn"
				label={STRINGS[label]}
				stringId={label}
				type="button"
			/>
		</div>
	);
};

export const RenderBackBtn = ({ setStep, setErrorMsg, setOtpValue, step }) => {
	return (
		<Button
			onClick={() => {
				setStep(step);
				setErrorMsg('');
				setOtpValue('');
			}}
			className="back-btn"
			label={STRINGS['ACCOUNT_SECURITY.OTP.BACK']}
			stringId="ACCOUNT_SECURITY.OTP.BACK"
			type="button"
		/>
	);
};
