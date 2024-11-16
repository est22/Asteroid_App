'use strict';

/** @type {import('sequelize-cli').Migration} */
module.exports = {
  async up(queryInterface, Sequelize) {
    await queryInterface.bulkInsert("Rewards", [
      {
        challenge_id: 2,
        user_id: 3,
        createdAt: new Date(),
        updatedAt: new Date(),
      },
      {
        challenge_id: 1,
        user_id: 5,
        createdAt: new Date(),
        updatedAt: new Date(),
      },
      {
        challenge_id: 3,
        user_id: 7,
        createdAt: new Date(),
        updatedAt: new Date(),
      },
      {
        challenge_id: 4,
        user_id: 9,
        createdAt: new Date(),
        updatedAt: new Date(),
      },
      {
        challenge_id: 2,
        user_id: 8,
        createdAt: new Date(),
        updatedAt: new Date(),
      },
      {
        challenge_id: 1,
        user_id: 2,
        createdAt: new Date(),
        updatedAt: new Date(),
      },
      {
        challenge_id: 4,
        user_id: 6,
        createdAt: new Date(),
        updatedAt: new Date(),
      },
      {
        challenge_id: 3,
        user_id: 13,
        createdAt: new Date(),
        updatedAt: new Date(),
      },
      {
        challenge_id: 2,
        user_id: 10,
        createdAt: new Date(),
        updatedAt: new Date(),
      },
      {
        challenge_id: 1,
        user_id: 12,
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
