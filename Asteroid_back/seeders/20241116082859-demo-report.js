'use strict';

/** @type {import('sequelize-cli').Migration} */
module.exports = {
  async up(queryInterface, Sequelize) {
    await queryInterface.bulkInsert("Reports", [
      // Post 신고
      {
        report_target_type: "Post",
        reported_target_id: 5,
        user_id: 1,
        report_reason: "글 도배",
        createdAt: new Date(),
        updatedAt: new Date(),
      },
      {
        report_target_type: "Post",
        reported_target_id: 3,
        user_id: 2,
        report_reason: "욕설 포함",
        createdAt: new Date(),
        updatedAt: new Date(),
      },
      {
        report_target_type: "Post",
        reported_target_id: 7,
        user_id: 3,
        report_reason: "스팸성 내용",
        createdAt: new Date(),
        updatedAt: new Date(),
      },

      // User 신고
      {
        report_target_type: "User",
        reported_target_id: 4,
        user_id: 5,
        report_reason: "부적절한 금전 요구",
        createdAt: new Date(),
        updatedAt: new Date(),
      },
      {
        report_target_type: "User",
        reported_target_id: 6,
        user_id: 8,
        report_reason: "자꾸 문자보내요",
        createdAt: new Date(),
        updatedAt: new Date(),
      },
      {
        report_target_type: "User",
        reported_target_id: 2,
        user_id: 7,
        report_reason: "부적절한 언행",
        createdAt: new Date(),
        updatedAt: new Date(),
      },

      // Challenge 신고
      {
        report_target_type: "Challenge",
        reported_target_id: 1,
        user_id: 9,
        report_reason: "부정 행위",
        createdAt: new Date(),
        updatedAt: new Date(),
      },
      {
        report_target_type: "Challenge",
        reported_target_id: 3,
        user_id: 10,
        report_reason: "규칙에 안맞는 사진 업로드",
        createdAt: new Date(),
        updatedAt: new Date(),
      },

      // 추가적인 신고 항목
      {
        report_target_type: "Post",
        reported_target_id: 10,
        user_id: 11,
        report_reason: "음란물 포함",
        createdAt: new Date(),
        updatedAt: new Date(),
      },
      {
        report_target_type: "User",
        reported_target_id: 8,
        user_id: 12,
        report_reason: "불법 행위",
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
