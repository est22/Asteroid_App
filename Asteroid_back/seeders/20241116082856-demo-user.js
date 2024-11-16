"use strict";

/** @type {import('sequelize-cli').Seed} */
module.exports = {
  async up(queryInterface, Sequelize) {
    await queryInterface.bulkInsert("Users", [
      {
        email: "admin",
        password: "admin",
        nickname: "admin",
        motto: "나 관리자",
        created_at: new Date(),
        updatedAt: new Date(),
      },
      {
        email: "user1@example.com",
        password: "user1",
        nickname: "user1nickname",
        created_at: new Date(),
        updatedAt: new Date(),
      },
      {
        email: "user2@example.com",
        password: "user2",
        nickname: "user2nickname",
        created_at: new Date(),
        updatedAt: new Date(),
      },
      {
        email: "user3@example.com",
        password: "user2",
        nickname: "user3nickname",
        created_at: new Date(),
        updatedAt: new Date(),
      },
    ]);
  },

  async down(queryInterface, Sequelize) {
    await queryInterface.bulkDelete("Users", null, {});
  },
};
