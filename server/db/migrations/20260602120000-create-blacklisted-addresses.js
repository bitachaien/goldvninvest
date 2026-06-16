'use strict';

const TABLE_NAME = 'BlacklistedAddresses';

module.exports = {
	up: (queryInterface, Sequelize) => {
		return queryInterface.createTable(TABLE_NAME, {
			id: {
				allowNull: false,
				autoIncrement: true,
				primaryKey: true,
				type: Sequelize.INTEGER
			},
			address: {
				type: Sequelize.STRING,
				allowNull: false
			},
			network: {
				type: Sequelize.STRING,
				allowNull: true
			},
			label: {
				type: Sequelize.STRING,
				allowNull: true
			},
			reason: {
				type: Sequelize.STRING,
				allowNull: true
			},
			created_by: {
				type: Sequelize.INTEGER,
				allowNull: true,
				onDelete: 'SET NULL',
				references: {
					model: 'Users',
					key: 'id'
				}
			},
			created_at: {
				allowNull: false,
				type: Sequelize.DATE,
				defaultValue: Sequelize.literal('NOW()')
			},
			updated_at: {
				allowNull: false,
				type: Sequelize.DATE,
				defaultValue: Sequelize.literal('NOW()')
			}
		},
		{
			timestamps: true,
			underscored: true
		}).then(() => {
			return queryInterface.addIndex(TABLE_NAME, ['address']);
		}).then(() => {
			return queryInterface.addIndex(TABLE_NAME, ['address', 'network'], { unique: true });
		});
	},
	down: (queryInterface) => queryInterface.dropTable(TABLE_NAME)
};
