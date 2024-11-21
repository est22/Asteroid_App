'use strict';

/** @type {import('sequelize-cli').Migration} */
module.exports = {
  async up(queryInterface, Sequelize) {
    await queryInterface.bulkInsert(
      "ChallengeParticipations",
      [
        // 인기 챌린지 "3000원 이하 커피 마시기" (20명 참여)
        {
          user_id: 3,
          challenge_id: 2,
          status: "진행중",
          start_date: new Date("2024-11-01"),
          end_date: new Date("2024-11-15"),
          challenge_reported_count: 0,
          createdAt: new Date(),
          updatedAt: new Date(),
        },
        {
          user_id: 5,
          challenge_id: 2,
          status: "완료",
          start_date: new Date("2024-11-02"),
          end_date: new Date("2024-11-16"),
          challenge_reported_count: 1,
          createdAt: new Date(),
          updatedAt: new Date(),
        },
        {
          user_id: 8,
          challenge_id: 2,
          status: "진행중",
          start_date: new Date("2024-11-03"),
          end_date: null,
          challenge_reported_count: 0,
          createdAt: new Date(),
          updatedAt: new Date(),
        },
        {
          user_id: 1,
          challenge_id: 2,
          status: "완료",
          start_date: new Date("2024-11-01"),
          end_date: new Date("2024-11-15"),
          challenge_reported_count: 2,
          createdAt: new Date(),
          updatedAt: new Date(),
        },
        {
          user_id: 2,
          challenge_id: 2,
          status: "완료",
          start_date: new Date("2024-11-05"),
          end_date: new Date("2024-11-19"),
          challenge_reported_count: 1,
          createdAt: new Date(),
          updatedAt: new Date(),
        },
        {
          user_id: 6,
          challenge_id: 2,
          status: "진행중",
          start_date: new Date("2024-11-06"),
          end_date: null,
          challenge_reported_count: 1,
          createdAt: new Date(),
          updatedAt: new Date(),
        },
        {
          user_id: 10,
          challenge_id: 2,
          status: "진행중",
          start_date: new Date("2024-11-07"),
          end_date: null,
          challenge_reported_count: 0,
          createdAt: new Date(),
          updatedAt: new Date(),
        },
        {
          user_id: 13,
          challenge_id: 2,
          status: "진행중",
          start_date: new Date("2024-11-01"),
          end_date: null,
          challenge_reported_count: 0,
          createdAt: new Date(),
          updatedAt: new Date(),
        },
        {
          user_id: 14,
          challenge_id: 2,
          status: "완료",
          start_date: new Date("2024-11-02"),
          end_date: new Date("2024-11-16"),
          challenge_reported_count: 2,
          createdAt: new Date(),
          updatedAt: new Date(),
        },
        {
          user_id: 15,
          challenge_id: 2,
          status: "완료",
          start_date: new Date("2024-11-04"),
          end_date: new Date("2024-11-18"),
          challenge_reported_count: 1,
          createdAt: new Date(),
          updatedAt: new Date(),
        },
        {
          user_id: 17,
          challenge_id: 2,
          status: "진행중",
          start_date: new Date("2024-11-18"),
          end_date: null,
          challenge_reported_count: 0,
          createdAt: new Date(),
          updatedAt: new Date(),
        },
        {
          user_id: 18,
          challenge_id: 2,
          status: "완료",
          start_date: new Date("2024-11-02"),
          end_date: new Date("2024-11-16"),
          challenge_reported_count: 1,
          createdAt: new Date(),
          updatedAt: new Date(),
        },
        {
          user_id: 19,
          challenge_id: 2,
          status: "진행중",
          start_date: new Date("2024-11-06"),
          end_date: null,
          challenge_reported_count: 0,
          createdAt: new Date(),
          updatedAt: new Date(),
        },
        {
          user_id: 20,
          challenge_id: 2,
          status: "진행중",
          start_date: new Date("2024-11-17"),
          end_date: null,
          challenge_reported_count: 0,
          createdAt: new Date(),
          updatedAt: new Date(),
        },
        {
          user_id: 9,
          challenge_id: 2,
          status: "완료",
          start_date: new Date("2024-11-04"),
          end_date: new Date("2024-11-18"),
          challenge_reported_count: 1,
          createdAt: new Date(),
          updatedAt: new Date(),
        },
        {
          user_id: 21,
          challenge_id: 2,
          status: "진행중",
          start_date: new Date("2024-11-05"),
          end_date: null,
          challenge_reported_count: 0,
          createdAt: new Date(),
          updatedAt: new Date(),
        },
        {
          user_id: 22,
          challenge_id: 2,
          status: "완료",
          start_date: new Date("2024-11-02"),
          end_date: new Date("2024-11-16"),
          challenge_reported_count: 1,
          createdAt: new Date(),
          updatedAt: new Date(),
        },
        {
          user_id: 23,
          challenge_id: 2,
          status: "진행중",
          start_date: new Date("2024-11-01"),
          end_date: null,
          challenge_reported_count: 0,
          createdAt: new Date(),
          updatedAt: new Date(),
        },
        {
          user_id: 24,
          challenge_id: 2,
          status: "완료",
          start_date: new Date("2024-11-01"),
          end_date: new Date("2024-11-15"),
          challenge_reported_count: 1,
          createdAt: new Date(),
          updatedAt: new Date(),
        },

        // 하루 3만원 이하로 소비하기 (10명 참여)
        {
          user_id: 3,
          challenge_id: 1,
          status: "진행중",
          start_date: new Date("2024-11-01"),
          end_date: null,
          challenge_reported_count: 0,
          createdAt: new Date(),
          updatedAt: new Date(),
        },
        {
          user_id: 5,
          challenge_id: 1,
          status: "완료",
          start_date: new Date("2024-11-02"),
          end_date: new Date("2024-11-16"),
          challenge_reported_count: 1,
          createdAt: new Date(),
          updatedAt: new Date(),
        },
        {
          user_id: 8,
          challenge_id: 1,
          status: "진행중",
          start_date: new Date("2024-11-03"),
          end_date: null,
          challenge_reported_count: 0,
          createdAt: new Date(),
          updatedAt: new Date(),
        },
        {
          user_id: 6,
          challenge_id: 1,
          status: "완료",
          start_date: new Date("2024-11-04"),
          end_date: new Date("2024-11-18"),
          challenge_reported_count: 1,
          createdAt: new Date(),
          updatedAt: new Date(),
        },
        {
          user_id: 10,
          challenge_id: 1,
          status: "진행중",
          start_date: new Date("2024-11-05"),
          end_date: null,
          challenge_reported_count: 0,
          createdAt: new Date(),
          updatedAt: new Date(),
        },
        {
          user_id: 2,
          challenge_id: 1,
          status: "진행중",
          start_date: new Date("2024-11-06"),
          end_date: null,
          challenge_reported_count: 0,
          createdAt: new Date(),
          updatedAt: new Date(),
        },
        {
          user_id: 12,
          challenge_id: 1,
          status: "완료",
          start_date: new Date("2024-11-02"),
          end_date: new Date("2024-11-16"),
          challenge_reported_count: 1,
          createdAt: new Date(),
          updatedAt: new Date(),
        },
        {
          user_id: 14,
          challenge_id: 1,
          status: "진행중",
          start_date: new Date("2024-11-03"),
          end_date: null,
          challenge_reported_count: 0,
          createdAt: new Date(),
          updatedAt: new Date(),
        },
        {
          user_id: 18,
          challenge_id: 1,
          status: "완료",
          start_date: new Date("2024-11-01"),
          end_date: new Date("2024-11-15"),
          challenge_reported_count: 1,
          createdAt: new Date(),
          updatedAt: new Date(),
        },
        {
          user_id: 19,
          challenge_id: 1,
          status: "진행중",
          start_date: new Date("2024-11-06"),
          end_date: null,
          challenge_reported_count: 0,
          createdAt: new Date(),
          updatedAt: new Date(),
        },

        // 일주일 외식 안 하기 (6명 참여)
        {
          user_id: 1,
          challenge_id: 3,
          status: "완료",
          start_date: new Date("2024-11-01"),
          end_date: new Date("2024-11-07"),
          challenge_reported_count: 1,
          createdAt: new Date(),
          updatedAt: new Date(),
        },
        {
          user_id: 2,
          challenge_id: 3,
          status: "진행중",
          start_date: new Date("2024-11-02"),
          end_date: null,
          challenge_reported_count: 0,
          createdAt: new Date(),
          updatedAt: new Date(),
        },
        {
          user_id: 6,
          challenge_id: 3,
          status: "진행중",
          start_date: new Date("2024-11-03"),
          end_date: null,
          challenge_reported_count: 0,
          createdAt: new Date(),
          updatedAt: new Date(),
        },
        {
          user_id: 12,
          challenge_id: 3,
          status: "완료",
          start_date: new Date("2024-11-01"),
          end_date: new Date("2024-11-07"),
          challenge_reported_count: 1,
          createdAt: new Date(),
          updatedAt: new Date(),
        },
        {
          user_id: 16,
          challenge_id: 3,
          status: "진행중",
          start_date: new Date("2024-11-04"),
          end_date: null,
          challenge_reported_count: 0,
          createdAt: new Date(),
          updatedAt: new Date(),
        },
        {
          user_id: 18,
          challenge_id: 3,
          status: "진행중",
          start_date: new Date("2024-11-06"),
          end_date: null,
          challenge_reported_count: 0,
          createdAt: new Date(),
          updatedAt: new Date(),
        },

        // 하루 10만원 이하로 소비하기 (4명 참여)
        {
          user_id: 3,
          challenge_id: 4,
          status: "완료",
          start_date: new Date("2024-11-02"),
          end_date: new Date("2024-11-16"),
          challenge_reported_count: 1,
          createdAt: new Date(),
          updatedAt: new Date(),
        },
        {
          user_id: 5,
          challenge_id: 4,
          status: "진행중",
          start_date: new Date("2024-11-03"),
          end_date: null,
          challenge_reported_count: 0,
          createdAt: new Date(),
          updatedAt: new Date(),
        },
        {
          user_id: 6,
          challenge_id: 4,
          status: "완료",
          start_date: new Date("2024-11-01"),
          end_date: new Date("2024-11-15"),
          challenge_reported_count: 1,
          createdAt: new Date(),
          updatedAt: new Date(),
        },
        {
          user_id: 10,
          challenge_id: 4,
          status: "신고 접수",
          start_date: new Date("2024-11-04"),
          end_date: null,
          challenge_reported_count: 1,
          createdAt: new Date(),
          updatedAt: new Date(),
        },
      ],
      {}
    );
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
