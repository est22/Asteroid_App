'use strict';

/** @type {import('sequelize-cli').Migration} */
module.exports = {
  async up(queryInterface, Sequelize) {
    await queryInterface.bulkInsert("Reports", [
      // Post 신고
      {
        target_type: "P",
        target_id: 1,
        user_id: 1,
        report_type: 4, // 도배
        report_reason: null,
        createdAt: new Date(),
        updatedAt: new Date(),
      },
      {
        target_type: "P",
        target_id: 2,
        user_id: 1,
        report_type: 4, // 도배
        report_reason: null,
        createdAt: new Date(),
        updatedAt: new Date(),
      },
      // Comment 신고
      {
        target_type: "C",
        target_id: 4,
        user_id: 1,
        report_type: 9, // 기타(서술형)
        report_reason: "부적절한 금전 요구",
        createdAt: new Date(),
        updatedAt: new Date(),
      },
      {
        target_type: "C",
        target_id: 3,
        user_id: 1,
        report_type: 3, // 욕설/불쾌한 표현
        report_reason: null,
        createdAt: new Date(),
        updatedAt: new Date(),
      },

      // User 신고
      {
        target_type: "U",
        target_id: 6,
        user_id: 2,
        report_type: 9, // 기타(서술형)
        report_reason: "자꾸 문자보내요",
        createdAt: new Date(),
        updatedAt: new Date(),
      },
      {
        target_type: "U",
        target_id: 2,
        user_id: 1,
        report_type: 7, // 청소년 유해 내용 
        report_reason: null,
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
