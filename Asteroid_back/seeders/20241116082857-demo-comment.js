"use strict";

/** @type {import('sequelize-cli').Seed} */
module.exports = {
  async up(queryInterface, Sequelize) {
    await queryInterface.bulkInsert("Comments", [
      {
        content: "좋은 지출에 대해 칭찬합니다! 저도 이렇게 해보고 싶네요.",
        created_at: new Date(),
        user_id: 2,
        post_id: 1,
        parent_comment_id: null,
        likes: 0,
        updatedAt: new Date(),
      },
      {
        content: "소소한 성과지만 멋져요! 저도 운동을 시작해야겠어요.",
        created_at: new Date(),
        user_id: 3,
        post_id: 1,
        parent_comment_id: null,
        likes: 0,
        updatedAt: new Date(),
      },
      {
        content: "오늘 하루도 정말 힘드셨군요. 모두가 이런 날이 있죠.",
        created_at: new Date(),
        user_id: 4,
        post_id: 3,
        parent_comment_id: null,
        likes: 0,
        updatedAt: new Date(),
      },
      {
        content: "저도 아침에 명상하는데, 점점 편안해져요. 힘내세요!",
        created_at: new Date(),
        user_id: 2,
        post_id: 2,
        parent_comment_id: null,
        likes: 0,
        updatedAt: new Date(),
      },
      {
        content: "팀 프로젝트가 잘 끝나서 기쁩니다. 모두가 대단해요!",
        created_at: new Date(),
        user_id: 4,
        post_id: 2,
        parent_comment_id: null,
        likes: 0,
        updatedAt: new Date(),
      },
      {
        content: "이번 주 추천작 정말 궁금하네요! 꼭 보겠습니다.",
        created_at: new Date(),
        user_id: 2,
        post_id: 4,
        parent_comment_id: null,
        likes: 0,
        updatedAt: new Date(),
      },
    ]);
  },

  async down(queryInterface, Sequelize) {
    await queryInterface.bulkDelete("Comments", null, {});
  },
};
