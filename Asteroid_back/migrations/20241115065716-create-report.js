"use strict";

/** @type {import('sequelize-cli').Migration} */
module.exports = {
  async up(queryInterface, Sequelize) {
    await queryInterface.createTable("Reports", {
      id: {
        allowNull: false,
        autoIncrement: true,
        primaryKey: true,
        type: Sequelize.INTEGER,
      },
      target_type: {
        type: Sequelize.STRING(1),
        allowNull: false,
      },
      target_id: {
        type: Sequelize.INTEGER,
        allowNull: false,
      },
      target_user_id: {
        type: Sequelize.INTEGER,
        allowNull: false,
        references: {
          model: "Users",
          key: "id",
        },
        onDelete: "CASCADE",
      },
      reporting_user_id: {
        type: Sequelize.INTEGER,
        allowNull: false,
        references: {
          model: "Users",
          key: "id",
        },
        onDelete: "CASCADE",
      },
      report_reason: {
        type: Sequelize.STRING,
        allowNull: true,
      },
      report_type: {
        type: Sequelize.SMALLINT,
        allowNull: false,
        comment:
          "0=스팸홍보/광고,1=음란물,2=부적절한_내용,3=욕설/불쾌한_표현,4=도배,5=사회분위기_훼손,6=불법정보_포함,7=청소년_유해_내용,8=명예훼손/저작권_침해,9=기타",
        validate: {
          isIn: [[0, 1, 2, 3, 4, 5, 6, 7, 8, 9]], // 허용되는 값 제한
        },
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
    await queryInterface.dropTable("Reports");
  },
};
