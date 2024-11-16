"use strict";

/** @type {import('sequelize-cli').Seed} */
module.exports = {
  async up(queryInterface, Sequelize) {
    await queryInterface.bulkInsert("Posts", [
      {
        title: "[공지사항]당근과 채찍 규칙 정독",
        content: "규칙 지키세요.",
        category_id: 1,
        user_id: 1,
        createdAt: new Date(),
        updatedAt: new Date(),
      },
      {
        title: "[공지사항]칭찬합시다 규칙 정독",
        content: "규칙 지키세요.",
        category_id: 2,
        user_id: 1,
        createdAt: new Date(),
        updatedAt: new Date(),
      },
      {
        title: "[공지사항]자유 게시판 규칙 정독",
        content: "규칙 지키세요.",
        category_id: 4,
        user_id: 1,
        createdAt: new Date(),
        updatedAt: new Date(),
      },
      {
        title: "지출 계획 실패... 채찍 맞고 반성합니다.",
        content:
          "계획대로 지출을 줄이지 못해서 너무 속상해요. 다음 주에는 꼭 개선할 거예요.",
        category_id: 1,
        user_id: 2,
        createdAt: new Date(),
        updatedAt: new Date(),
      },
      {
        title: "정리 정돈도 중요한 소비 습관",
        content:
          "오늘은 불필요한 물건들을 정리했어요. 나만의 소비 습관을 다시 점검할 수 있었습니다.",
        category_id: 1,
        user_id: 3,
        createdAt: new Date(),
        updatedAt: new Date(),
      },
      {
        title: "소비 습관을 바꿨더니 기분이 좋아요! 당근!",
        content:
          "매일 10,000원 이하로만 소비하기 챌린지 성공! 조금 더 절약하려고 노력하니 마음이 편안해졌어요. 당근 주세요!",
        category_id: 1,
        user_id: 4,
        createdAt: new Date(),
        updatedAt: new Date(),
      },
      {
        title: "대박! 이번 달 목표 초과 달성! 당근 주세요!",
        content:
          "이번 달 소비 목표를 넘겼어요. 적은 금액이지만 큰 의미가 있어요. 덕분에 마음의 여유가 생겼어요. 계속 이렇게 할 수 있도록 응원해주세요.",
        category_id: 1,
        user_id: 5,
        createdAt: new Date(),
        updatedAt: new Date(),
      },
      {
        title: "저축 목표가 너무 어려워요... 채찍!",
        content:
          "저축을 하려고 했지만, 생각보다 어려워요. 매일 조금씩 저축하는 게 중요하다는 걸 알지만, 자꾸 다른 소비를 하고 말아요. 채찍 맞고 다시 시작할게요!",
        category_id: 1,
        user_id: 6,
        createdAt: new Date(),
        updatedAt: new Date(),
      },
      {
        title: "소소한 성공! 소비를 줄였어요. 당근!",
        content:
          "이번 주에는 예상보다 더 절약할 수 있었어요! 커피숍에서 2번만 갔고, 배달음식도 안 시켰어요. 작은 성공이지만 계속 이렇게 해볼게요.",
        category_id: 1,
        user_id: 7,
        createdAt: new Date(),
        updatedAt: new Date(),
      },
      {
        title: "이번 주 나의 성과! 칭찬받고 싶어요!",
        content:
          "매일 30분씩 운동했어요! 작은 성과지만 기쁩니다. 칭찬해 주세요!",
        category_id: 2,
        user_id: 4,
        createdAt: new Date(),
        updatedAt: new Date(),
      },
      {
        title: "첫 시도! 금연 성공!",
        content:
          "오늘 첫 금연 1일 성공! 여러분의 칭찬이 큰 힘이 됩니다. 계속 할 수 있을까요?",
        category_id: 2,
        user_id: 5,
        createdAt: new Date(),
        updatedAt: new Date(),
      },
      {
        title: "절약 목표 달성! 이제 더 나은 소비를 할 거예요.",
        content: "한 달 동안 지출을 20% 줄였어요! 칭찬해 주세요!",
        category_id: 2,
        user_id: 6,
        createdAt: new Date(),
        updatedAt: new Date(),
      },

      {
        title: "최근 읽은 책 추천합니다!",
        content:
          "이번에 읽은 책이 정말 좋았어요. 여러분도 꼭 읽어보세요. 어떤 책을 읽고 계신가요?",
        category_id: 4,
        user_id: 7,
        createdAt: new Date(),
        updatedAt: new Date(),
      },
      {
        title: "나만의 저녁 레시피 공개",
        content:
          "저녁으로 간단히 만들 수 있는 김치찌개 레시피를 공유할게요. 간단하고 맛있어요!",
        category_id: 4,
        user_id: 8,
        createdAt: new Date(),
        updatedAt: new Date(),
      },
      {
        title: "혼자서 보내는 주말, 어떻게 보내세요?",
        content:
          "혼자 있는 주말이 지루할 때가 많아요. 여러분은 어떻게 주말을 보내세요?",
        category_id: 4,
        user_id: 9,
        createdAt: new Date(),
        updatedAt: new Date(),
      },
    ]);
  },

  async down(queryInterface, Sequelize) {
    await queryInterface.bulkDelete("Posts", null, {});
  },
};
