'use strict';

module.exports = function (sequelize, DataTypes) {
	const BlacklistedAddress = sequelize.define(
		'BlacklistedAddress',
		{
			id: {
				type: DataTypes.INTEGER,
				allowNull: false,
				autoIncrement: true,
				primaryKey: true
			},
			address: {
				type: DataTypes.STRING,
				allowNull: false
			},
			network: {
				type: DataTypes.STRING,
				allowNull: true
			},
			label: {
				type: DataTypes.STRING,
				allowNull: true
			},
			reason: {
				type: DataTypes.STRING,
				allowNull: true
			},
			created_by: {
				type: DataTypes.INTEGER,
				allowNull: true,
				references: {
					model: 'Users',
					key: 'id'
				}
			}
		},
		{
			timestamps: true,
			underscored: true,
			tableName: 'BlacklistedAddresses'
		}
	);

	BlacklistedAddress.associate = (models) => {
		BlacklistedAddress.belongsTo(models.User, {
			onDelete: 'SET NULL',
			foreignKey: 'created_by',
			targetKey: 'id'
		});
	};

	return BlacklistedAddress;
};
