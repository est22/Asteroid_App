'use strict';

/** @type {import('sequelize-cli').Migration} */
module.exports = {
  async up (queryInterface, Sequelize) {
    await queryInterface.bulkInsert(
      "Categories",
      [
        {
          category_name: "당근과채찍",
          createdAt: new Date(),
          updatedAt: new Date(),
        },
        {
          category_name: "칭찬합시다",
          createdAt: new Date(),
          updatedAt: new Date(),
        },
        {
          category_name: "밸런스투표",
          createdAt: new Date(),
          updatedAt: new Date(),
        },
        {
          category_name: "자유게시판",
          createdAt: new Date(),
          updatedAt: new Date(),
        }
      ],
      {}
    );
  },

  async down (queryInterface, Sequelize) {
    /**
     * Add commands to revert seed here.
     *
     * Example:
     * await queryInterface.bulkDelete('People', null, {});
     */
  }
};
