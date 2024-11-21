"use strict";

/** @type {import('sequelize-cli').Seed} */
module.exports = {
  async up(queryInterface, Sequelize) {
    await queryInterface.bulkInsert("PostImages", [
      {
        image_url: "https://cdn.ibos.kr/og-BD6140-56017.gif?v=1628498102",
        post_id: 1,
        createdAt: new Date(),
        updatedAt: new Date(),
      },
      {
        image_url: "https://cdn.ibos.kr/og-BD6140-56017.gif?v=1628498102",
        post_id: 2,
        createdAt: new Date(),
        updatedAt: new Date(),
      },
      {
        image_url: "https://cdn.ibos.kr/og-BD6140-56017.gif?v=1628498102",
        post_id: 3,
        createdAt: new Date(),
        updatedAt: new Date(),
      },
    ]);
  },

  async down(queryInterface, Sequelize) {
    await queryInterface.bulkDelete("PostImages", null, {});
  },
};
