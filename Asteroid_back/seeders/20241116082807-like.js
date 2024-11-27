'use strict';

/** @type {import('sequelize-cli').Migration} */
module.exports = {
  async up(queryInterface, Sequelize) {
    await queryInterface.bulkInsert("Likes", [
      {
        user_id: 1,
        target_type: "P", // 예: Post
        target_id: 1,
        createdAt: new Date(),
        updatedAt: new Date(),
      },

      {
        user_id: 3,
        target_type: "P", // 예: Post
        target_id: 2,
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
