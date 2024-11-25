"use strict";

/** @type {import('sequelize-cli').Seed} */
module.exports = {
  async up(queryInterface, Sequelize) {
    await queryInterface.bulkInsert("MessageRooms", [
      {
        user1_id: 1,
        user2_id: 3,
        user1_left_at: null,
        user2_left_at: null,
        createdAt: new Date(),
        updatedAt: new Date(),
      },
      {
        user1_id: 1,
        user2_id: 4,
        user1_left_at: null,
        user2_left_at: null,
        createdAt: new Date(),
        updatedAt: new Date(),
      },
      {
        user1_id: 1,
        user2_id: 5,
        user1_left_at: null,
        user2_left_at: null,
        createdAt: new Date(),
        updatedAt: new Date(),
      },
      {
        user1_id: 1,
        user2_id: 6,
        user1_left_at: null,
        user2_left_at: null,
        createdAt: new Date(),
        updatedAt: new Date(),
      },
      {
        user1_id: 1,
        user2_id: 7,
        user1_left_at: null,
        user2_left_at: null,
        createdAt: new Date(),
        updatedAt: new Date(),
      },
      {
        user1_id: 1,
        user2_id: 8,
        user1_left_at: null,
        user2_left_at: null,
        createdAt: new Date(),
        updatedAt: new Date(),
      },
      {
        user1_id: 1,
        user2_id: 9,
        user1_left_at: null,
        user2_left_at: null,
        createdAt: new Date(),
        updatedAt: new Date(),
      },
      {
        user1_id: 1,
        user2_id: 10,
        user1_left_at: null,
        user2_left_at: null,
        createdAt: new Date(),
        updatedAt: new Date(),
      },
      {
        user1_id: 1,
        user2_id: 37,
        user1_left_at: null,
        user2_left_at: null,
        createdAt: new Date(),
        updatedAt: new Date(),
      },
      {
        user1_id: 3,
        user2_id: 37,
        user1_left_at: null,
        user2_left_at: null,
        createdAt: new Date(),
        updatedAt: new Date(),
      },
    ]);
  },

  async down(queryInterface, Sequelize) {
    await queryInterface.bulkDelete("MessageRooms", null, {});
  },
};
