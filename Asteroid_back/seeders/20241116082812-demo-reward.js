'use strict';

/** @type {import('sequelize-cli').Migration} */
module.exports = {
  async up(queryInterface, Sequelize) {
    await queryInterface.bulkInsert("Rewards", [
      {
        challenge_id: 2,
        user_id: 5,
        credit: 10,
        createdAt: new Date(),
        updatedAt: new Date(),
      },
      {
        challenge_id: 2,
        user_id: 1,
        credit: 0,
        createdAt: new Date(),
        updatedAt: new Date(),
      },
      {
        challenge_id: 2,
        user_id: 2,
        credit: 0,
        createdAt: new Date(),
        updatedAt: new Date(),
      },
      {
        challenge_id: 2,
        user_id: 6,
        credit: 0,
        createdAt: new Date(),
        updatedAt: new Date(),
      },
      {
        challenge_id: 2,
        user_id: 10,
        credit: 0,
        createdAt: new Date(),
        updatedAt: new Date(),
      },
      {
        challenge_id: 2,
        user_id: 13,
        credit: 0,
        createdAt: new Date(),
        updatedAt: new Date(),
      },
      {
        challenge_id: 2,
        user_id: 14,
        credit: 0,
        createdAt: new Date(),
        updatedAt: new Date(),
      },
      {
        challenge_id: 2,
        user_id: 15,
        credit: 0,
        createdAt: new Date(),
        updatedAt: new Date(),
      },
      {
        challenge_id: 2,
        user_id: 18,
        credit: 0,
        createdAt: new Date(),
        updatedAt: new Date(),
      },
      {
        challenge_id: 9,
        user_id: 2,
        credit: 0,
        createdAt: new Date(),
        updatedAt: new Date(),
      },
      {
        challenge_id: 2,
        user_id: 2,
        credit: 0,
        createdAt: new Date(),
        updatedAt: new Date(),
      },
      {
        challenge_id: 2,
        user_id: 24,
        credit: 0,
        createdAt: new Date(),
        updatedAt: new Date(),
      },
      {
        challenge_id: 1,
        user_id: 5,
        credit: 0,
        createdAt: new Date(),
        updatedAt: new Date(),
      },
      {
        challenge_id: 1,
        user_id: 6,
        credit: 0,
        createdAt: new Date(),
        updatedAt: new Date(),
      },
      {
        challenge_id: 1,
        user_id: 12,
        credit: 0,
        createdAt: new Date(),
        updatedAt: new Date(),
      },
      {
        challenge_id: 1,
        user_id: 18,
        credit: 0,
        createdAt: new Date(),
        updatedAt: new Date(),
      },
      {
        challenge_id: 3,
        user_id: 12,
        credit: 0,
        createdAt: new Date(),
        updatedAt: new Date(),
      },
      {
        challenge_id: 4,
        user_id: 3,
        credit: 0,
        createdAt: new Date(),
        updatedAt: new Date(),
      },
      {
        challenge_id: 4,
        user_id: 6,
        credit: 0,
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
