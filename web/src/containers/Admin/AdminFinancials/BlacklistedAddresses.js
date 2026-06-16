import React, { useEffect, useState } from 'react';
import { message, Table, Button, Spin, Input, Modal } from 'antd';
import moment from 'moment';
import {
	getBlacklistedAddresses,
	addBlacklistedAddress,
	removeBlacklistedAddress,
} from './action';

const DEFAULT_LIMIT = 10;

const BlacklistedAddresses = () => {
	const [addresses, setAddresses] = useState([]);
	const [total, setTotal] = useState(0);
	const [page, setPage] = useState(1);
	const [limit, setLimit] = useState(DEFAULT_LIMIT);
	const [search, setSearch] = useState('');
	const [searchInput, setSearchInput] = useState('');
	const [isLoading, setIsLoading] = useState(false);

	const [isModalVisible, setIsModalVisible] = useState(false);
	const [addressInput, setAddressInput] = useState('');
	const [networkInput, setNetworkInput] = useState('');
	const [labelInput, setLabelInput] = useState('');

	const [removeTarget, setRemoveTarget] = useState(null);

	const fetchAddresses = (params = {}) => {
		const nextLimit = params.limit || limit;
		const nextPage = params.page || page;
		const nextSearch = params.search !== undefined ? params.search : search;
		const trimmedSearch = nextSearch ? nextSearch.trim() : '';

		setIsLoading(true);
		getBlacklistedAddresses({
			limit: nextLimit,
			page: nextPage,
			...(trimmedSearch && { search: trimmedSearch }),
		})
			.then((res) => {
				const count = res?.count || 0;
				const data = res?.data || [];
				const maxPage = Math.max(1, Math.ceil(count / nextLimit));
				if (nextPage > maxPage) {
					fetchAddresses({
						limit: nextLimit,
						page: maxPage,
						search: trimmedSearch,
					});
					return;
				}
				setAddresses(data);
				setTotal(count);
				setPage(nextPage);
				setLimit(nextLimit);
				setSearch(trimmedSearch);
				setIsLoading(false);
			})
			.catch((err) => {
				setIsLoading(false);
				const _error =
					err.data && err.data.message ? err.data.message : err.message;
				message.error(_error);
			});
	};

	useEffect(() => {
		fetchAddresses();
		// eslint-disable-next-line react-hooks/exhaustive-deps
	}, []);

	const handleSearchChange = (e) => {
		const value = e.target.value;
		setSearchInput(value);
		if (!value && search) {
			fetchAddresses({ page: 1, search: '' });
		}
	};

	const handleSearch = (value) => {
		const trimmed = value ? value.trim() : '';
		setSearchInput(trimmed);
		fetchAddresses({ page: 1, search: trimmed });
	};

	const handleTableChange = (pagination) => {
		const limitChanged = pagination.pageSize !== limit;
		fetchAddresses({
			page: limitChanged ? 1 : pagination.current,
			limit: pagination.pageSize,
		});
	};

	const openModal = () => {
		setAddressInput('');
		setNetworkInput('');
		setLabelInput('');
		setIsModalVisible(true);
	};

	const closeModal = () => {
		setIsModalVisible(false);
	};

	const handleAdd = () => {
		if (!addressInput || !addressInput.trim()) {
			message.error('Address is required');
			return;
		}
		setIsLoading(true);
		addBlacklistedAddress({
			address: addressInput.trim(),
			...(networkInput && { network: networkInput.trim() }),
			...(labelInput && { label: labelInput.trim() }),
		})
			.then(() => {
				message.success('Address added to blacklist');
				setIsModalVisible(false);
				fetchAddresses({ page: 1 });
			})
			.catch((err) => {
				setIsLoading(false);
				const _error =
					err.data && err.data.message ? err.data.message : err.message;
				message.error(_error);
			});
	};

	const openRemoveModal = (record) => {
		setRemoveTarget(record);
	};

	const closeRemoveModal = () => {
		setRemoveTarget(null);
	};

	const handleRemove = () => {
		if (!removeTarget) {
			return;
		}
		const id = removeTarget.id;
		setIsLoading(true);
		setRemoveTarget(null);
		removeBlacklistedAddress(id)
			.then(() => {
				message.success('Address removed from blacklist');
				fetchAddresses();
			})
			.catch((err) => {
				setIsLoading(false);
				const _error =
					err.data && err.data.message ? err.data.message : err.message;
				message.error(_error);
			});
	};

	const columns = [
		{
			title: 'Address',
			dataIndex: 'address',
			key: 'address',
			render: (address) => <div className="break-word">{address}</div>,
		},
		{
			title: 'Network',
			dataIndex: 'network',
			key: 'network',
			render: (network) => network || 'All networks',
		},
		{
			title: 'Label',
			dataIndex: 'label',
			key: 'label',
			render: (label) => label || '-',
		},
		{
			title: 'Reason',
			dataIndex: 'reason',
			key: 'reason',
			render: (reason) => reason || '-',
		},
		{
			title: 'Added',
			dataIndex: 'created_at',
			key: 'created_at',
			render: (created_at) =>
				created_at ? moment(created_at).format('YYYY-MM-DD HH:mm') : '-',
		},
		{
			title: '',
			key: 'action',
			render: (_, record) => (
				<span
					className="anchor underline-text cursor-pointer"
					style={{ cursor: 'pointer' }}
					onClick={() => openRemoveModal(record)}
				>
					Remove
				</span>
			),
		},
	];

	return (
		<div className="blacklist-addresses-wrapper">
			<div className="header-txt">Blacklisted addresses</div>
			<div className="description mt-2">
				Add a blockchain address to block withdrawals to it. Any withdrawal to a
				blacklisted address will be rejected.
			</div>
			<div className="blacklist-tools mt-4">
				<Input.Search
					allowClear
					placeholder="Search address, network, label, reason"
					value={searchInput}
					onChange={handleSearchChange}
					onSearch={handleSearch}
					style={{ width: 320 }}
				/>
				<Button type="primary" onClick={openModal} className="green-btn ml-3">
					Add
				</Button>
			</div>
			<div className="mt-4">
				<Spin spinning={isLoading}>
					<Table
						columns={columns}
						dataSource={addresses}
						rowKey="id"
						onChange={handleTableChange}
						pagination={{
							current: page,
							pageSize: limit,
							total,
							pageSizeOptions: ['10', '25', '50', '100'],
							showSizeChanger: true,
						}}
					/>
				</Spin>
			</div>
			<Modal visible={isModalVisible} footer={null} onCancel={closeModal}>
				<div className="general-geo-wrapper">
					<div className="title">Blacklist a withdrawal address</div>
					<div>Withdrawals to this address will be blocked.</div>
					<div className="mt-4">Address</div>
					<Input
						placeholder="Enter blockchain address"
						value={addressInput}
						onChange={(e) => setAddressInput(e.target.value)}
					/>
					<div className="mt-3">Network (optional)</div>
					<Input
						placeholder="e.g. eth, trx — leave empty to block all networks"
						value={networkInput}
						onChange={(e) => setNetworkInput(e.target.value)}
					/>
					<div className="mt-3">Label (optional)</div>
					<Input
						placeholder="Note / reason"
						value={labelInput}
						onChange={(e) => setLabelInput(e.target.value)}
					/>
					<div className="btn-wrapper mt-4">
						<Button type="primary" onClick={closeModal}>
							Back
						</Button>
						<div className="separator"></div>
						<Button type="primary" onClick={handleAdd} disabled={!addressInput}>
							Add
						</Button>
					</div>
				</div>
			</Modal>
			<Modal visible={!!removeTarget} footer={null} onCancel={closeRemoveModal}>
				<div className="general-geo-wrapper">
					<div className="title">Remove blacklisted address</div>
					<div>
						Are you sure you want to remove this address from the blacklist?
						Withdrawals to it will no longer be blocked.
					</div>
					{removeTarget && (
						<div className="mt-4">
							<div className="mt-2">
								<span className="bold">Address: </span>
								<span className="break-word">{removeTarget.address}</span>
							</div>
							<div className="mt-2">
								<span className="bold">Network: </span>
								<span>{removeTarget.network || 'All networks'}</span>
							</div>
							<div className="mt-2">
								<span className="bold">Label: </span>
								<span>{removeTarget.label || '-'}</span>
							</div>
							<div className="mt-2">
								<span className="bold">Reason: </span>
								<span>{removeTarget.reason || '-'}</span>
							</div>
							<div className="mt-2">
								<span className="bold">Added: </span>
								<span>
									{removeTarget.created_at
										? moment(removeTarget.created_at).format('YYYY-MM-DD HH:mm')
										: '-'}
								</span>
							</div>
						</div>
					)}
					<div className="btn-wrapper mt-4">
						<Button type="primary" onClick={closeRemoveModal}>
							Back
						</Button>
						<div className="separator"></div>
						<Button type="primary" danger onClick={handleRemove}>
							Remove
						</Button>
					</div>
				</div>
			</Modal>
		</div>
	);
};

export default BlacklistedAddresses;
