"use strict";

/** @type {import('sequelize-cli').Migration} */
module.exports = {
  async up(queryInterface, Sequelize) {
    await queryInterface.bulkInsert("Reports", [
      // Post 신고
      {
        target_type: "P",
        target_id: 1,
        target_user_id: 2, // Post 작성자의 ID
        reporting_user_id: 1, // 신고한 유저의 ID
        report_type: 4, // 도배
        report_reason: null,
        createdAt: new Date(),
        updatedAt: new Date(),
      },
      {
        target_type: "P",
        target_id: 2,
        target_user_id: 3, // Post 작성자의 ID
        reporting_user_id: 1, // 신고한 유저의 ID
        report_type: 4, // 도배
        report_reason: null,
        createdAt: new Date(),
        updatedAt: new Date(),
      },
      // Comment 신고
      {
        target_type: "C",
        target_id: 4,
        target_user_id: 3, // Comment 작성자의 ID
        reporting_user_id: 1, // 신고한 유저의 ID
        report_type: 9, // 기타(서술형)
        report_reason: "부적절한 금전 요구",
        createdAt: new Date(),
        updatedAt: new Date(),
      },
      {
        target_type: "C",
        target_id: 3,
        target_user_id: 2, // Comment 작성자의 ID
        reporting_user_id: 1, // 신고한 유저의 ID
        report_type: 3, // 욕설/불쾌한 표현
        report_reason: null,
        createdAt: new Date(),
        updatedAt: new Date(),
      },
      // User 신고
      {
        target_type: "U",
        target_id: 6,
        target_user_id: 6, // 신고된 유저의 ID
        reporting_user_id: 2, // 신고한 유저의 ID
        report_type: 9, // 기타(서술형)
        report_reason: "자꾸 문자보내요",
        createdAt: new Date(),
        updatedAt: new Date(),
      },
      {
        target_type: "U",
        target_id: 2,
        target_user_id: 2, // 신고된 유저의 ID
        reporting_user_id: 1, // 신고한 유저의 ID
        report_type: 7, // 청소년 유해 내용
        report_reason: null,
        createdAt: new Date(),
        updatedAt: new Date(),
      },
      // Challenge 신고
      {
        target_type: "L",
        target_id: 2,
        target_user_id: 4, // Challenge 작성자의 ID
        reporting_user_id: 1, // 신고한 유저의 ID
        report_type: 7, // 청소년 유해 내용
        report_reason: null,
        createdAt: new Date(),
        updatedAt: new Date(),
      },
    ]);
  },

  async down(queryInterface, Sequelize) {
    await queryInterface.bulkDelete("Reports", null, {});
  },
};
