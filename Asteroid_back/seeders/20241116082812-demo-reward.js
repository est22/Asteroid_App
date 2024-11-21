'use strict';

/** @type {import('sequelize-cli').Migration} */
module.exports = {
  async up(queryInterface, Sequelize) {
    await queryInterface.bulkInsert("Rewards", [
      {
        challenge_id: 2,
        user_id: 5,
        reward_count: 1,
        createdAt: new Date(),
        updatedAt: new Date(),
      },
      {
        challenge_id: 2,
        user_id: 1,
        reward_count: 0,
        createdAt: new Date(),
        updatedAt: new Date(),
      },
      {
        challenge_id: 2,
        user_id: 2,
        reward_count: 0,
        createdAt: new Date(),
        updatedAt: new Date(),
      },
      {
        challenge_id: 2,
        user_id: 6,
        reward_count: 0,
        createdAt: new Date(),
        updatedAt: new Date(),
      },
      {
        challenge_id: 2,
        user_id: 10,
        reward_count: 0,
        createdAt: new Date(),
        updatedAt: new Date(),
      },
      {
        challenge_id: 2,
        user_id: 13,
        reward_count: 0,
        createdAt: new Date(),
        updatedAt: new Date(),
      },
      {
        challenge_id: 2,
        user_id: 14,
        reward_count: 0,
        createdAt: new Date(),
        updatedAt: new Date(),
      },
      {
        challenge_id: 2,
        user_id: 15,
        reward_count: 0,
        createdAt: new Date(),
        updatedAt: new Date(),
      },
      {
        challenge_id: 2,
        user_id: 18,
        reward_count: 0,
        createdAt: new Date(),
        updatedAt: new Date(),
      },
      {
        challenge_id: 9,
        user_id: 2,
        reward_count: 0,
        createdAt: new Date(),
        updatedAt: new Date(),
      },
      {
        challenge_id: 2,
        user_id: 2,
        reward_count: 0,
        createdAt: new Date(),
        updatedAt: new Date(),
      },
      {
        challenge_id: 2,
        user_id: 24,
        reward_count: 0,
        createdAt: new Date(),
        updatedAt: new Date(),
      },
      {
        challenge_id: 1,
        user_id: 5,
        reward_count: 0,
        createdAt: new Date(),
        updatedAt: new Date(),
      },
      {
        challenge_id: 1,
        user_id: 6,
        reward_count: 0,
        createdAt: new Date(),
        updatedAt: new Date(),
      },
      {
        challenge_id: 1,
        user_id: 12,
        reward_count: 0,
        createdAt: new Date(),
        updatedAt: new Date(),
      },
      {
        challenge_id: 1,
        user_id: 18,
        reward_count: 0,
        createdAt: new Date(),
        updatedAt: new Date(),
      },
      {
        challenge_id: 3,
        user_id: 12,
        reward_count: 0,
        createdAt: new Date(),
        updatedAt: new Date(),
      },
      {
        challenge_id: 4,
        user_id: 3,
        reward_count: 0,
        createdAt: new Date(),
        updatedAt: new Date(),
      },
      {
        challenge_id: 4,
        user_id: 6,
        reward_count: 0,
        createdAt: new Date(),
        updatedAt: new Date(),
      },
    ]);
  },

  async down(queryInterface, Sequelize) {
    /**
     * Add commands to revert seed here.
     *
     * Example:
     * await queryInterface.bulkDelete('People', null, {});
     */
  },
};
