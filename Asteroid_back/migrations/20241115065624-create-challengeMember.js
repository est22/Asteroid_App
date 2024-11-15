"use strict";

/** @type {import('sequelize-cli').Migration} */
module.exports = {
  async up(queryInterface, Sequelize) {
    await queryInterface.createTable("ChallengeMembers", {
      id: {
        type: Sequelize.INTEGER,
        allowNull: false,
        autoIncrement: true,
        primaryKey: true,
      },
      user_id: {
        type: Sequelize.INTEGER,
        allowNull: false,
        references: {
          model: "Users", // 참조할 테이블 이름
          key: "id",
        },
        onDelete: "CASCADE",
      },
      challenge_id: {
        type: Sequelize.INTEGER,
        allowNull: false,
        references: {
          model: "Challenges", // 참조할 테이블 이름
          key: "id",
        },
        onDelete: "CASCADE",
      },
      status: {
        type: Sequelize.STRING,
        allowNull: true,
      },
      start_date: {
        type: Sequelize.DATE,
        allowNull: false,
      },
      end_date: {
        type: Sequelize.DATE,
        allowNull: true,
      },
      completed: {
        type: Sequelize.BOOLEAN,
        defaultValue: false,
      },
      challenge_reported_count: {
        type: Sequelize.INTEGER,
        defaultValue: 0,
      },
      createdAt: {
        type: Sequelize.DATE,
        allowNull: false,
        defaultValue: Sequelize.NOW,
      },
      updatedAt: {
        type: Sequelize.DATE,
        allowNull: false,
        defaultValue: Sequelize.NOW,
      },
    });
  },

  async down(queryInterface, Sequelize) {
    /**
     * Add reverting commands here.
     *
     * Example:
     * await queryInterface.dropTable('users');
     */
  },
};
