"use strict";

/** @type {import('sequelize-cli').Seed} */
module.exports = {
  async up(queryInterface, Sequelize) {
    await queryInterface.bulkInsert("Messages", [
      {
        content:
          "안녕하세요, 관리자가 보내는 공지사항입니다. 중요한 사항 확인해주세요.",
        sender_user_id: 1,
        receiver_user_id: 3,
        is_read: false,
        createdAt: new Date(),
        updatedAt: new Date(),
      },
      {
        content:
          "안녕하세요, 관리자가 보내는 공지사항입니다. 중요한 사항 확인해주세요.",
        sender_user_id: 1,
        receiver_user_id: 4,
        is_read: false,
        createdAt: new Date(),
        updatedAt: new Date(),
      },
      {
        content:
          "안녕하세요, 관리자가 보내는 공지사항입니다. 중요한 사항 확인해주세요.",
        sender_user_id: 1,
        receiver_user_id: 5,
        is_read: false,
        createdAt: new Date(),
        updatedAt: new Date(),
      },
      {
        content:
          "안녕하세요, 관리자가 보내는 공지사항입니다. 중요한 사항 확인해주세요.",
        sender_user_id: 1,
        receiver_user_id: 6,
        is_read: true,
        createdAt: new Date(),
        updatedAt: new Date(),
      },
      {
        content:
          "안녕하세요, 관리자가 보내는 공지사항입니다. 중요한 사항 확인해주세요.",
        sender_user_id: 1,
        receiver_user_id: 7,
        is_read: true,
        createdAt: new Date(),
        updatedAt: new Date(),
      },
      {
        content:
          "안녕하세요, 관리자가 보내는 공지사항입니다. 중요한 사항 확인해주세요.",
        sender_user_id: 1,
        receiver_user_id: 8,
        is_read: false,
        createdAt: new Date(),
        updatedAt: new Date(),
      },
      {
        content:
          "안녕하세요, 관리자가 보내는 공지사항입니다. 중요한 사항 확인해주세요.",
        sender_user_id: 1,
        receiver_user_id: 9,
        is_read: false,
        createdAt: new Date(),
        updatedAt: new Date(),
      },
      {
        content:
          "안녕하세요, 관리자가 보내는 공지사항입니다. 중요한 사항 확인해주세요.",
        sender_user_id: 1,
        receiver_user_id: 10,
        is_read: false,
        createdAt: new Date(),
        updatedAt: new Date(),
      },
      {
        content:
          "안녕하세요, 관리자가 보내는 공지사항입니다. 중요한 사항 확인해주세요.",
        sender_user_id: 1,
        receiver_user_id: 37,
        is_read: false,
        createdAt: new Date(),
        updatedAt: new Date(),
      },
      {
        content: "안녕하세요! 궁금한 점이 있어 쪽지 남깁니다.",
        sender_user_id: 37,
        receiver_user_id: 3,
        is_read: false,
        createdAt: new Date(),
        updatedAt: new Date(),
      },
      {
        content: "안녕하세요 답변드립니다. 더 궁금한 점 있으면 알려주세요.",
        sender_user_id: 3,
        receiver_user_id: 37,
        is_read: false,
        createdAt: new Date(),
        updatedAt: new Date(),
      },
      {
        content:
          "다시 한 번 물어봅니다. 이 부분에 대한 설명을 추가로 듣고 싶어요.",
        sender_user_id: 37,
        receiver_user_id: 3,
        is_read: false,
        createdAt: new Date(),
        updatedAt: new Date(),
      },
      {
        content: "알겠습니다! 다시 설명드리겠습니다. 이해가 되셨으면 좋겠네요.",
        sender_user_id: 3,
        receiver_user_id: 37,
        is_read: false,
        createdAt: new Date(),
        updatedAt: new Date(),
      },
    ]);
  },

  async down(queryInterface, Sequelize) {
    await queryInterface.bulkDelete("Messages", null, {});
  },
};
