"use strict";

/** @type {import('sequelize-cli').Seed} */
module.exports = {
  async up(queryInterface, Sequelize) {
    await queryInterface.bulkInsert(
      "Users",
      [
        {
          email: "admin@example.com",
          password: "admin",
          nickname: "관리자",
          motto: "나 관리자",
          createdAt: new Date(),
          updatedAt: new Date(),
        },
        {
          email: "banana1@example.com",
          password: "password",
          nickname: "갓흥민",
          motto: "절약도 예술임",
          createdAt: new Date(),
          updatedAt: new Date(),
        },
        {
          email: "coffee2@example.com",
          password: "password",
          nickname: "짠테크왕",
          motto: "오늘도 커피값 아낌",
          createdAt: new Date(),
          updatedAt: new Date(),
        },
        {
          email: "star3@example.com",
          password: "password",
          nickname: "김플렉스",
          motto: "작은 사치부터 시작",
          createdAt: new Date(),
          updatedAt: new Date(),
        },
        {
          email: "shine4@example.com",
          password: "password",
          nickname: "재벌꿈나무",
          motto: "소비는 전략이다",
          createdAt: new Date(),
          updatedAt: new Date(),
        },
        {
          email: "random5@example.com",
          password: "password",
          nickname: "돌멩이",
          motto: "나는 나다",
          createdAt: new Date(),
          updatedAt: new Date(),
        },
        {
          email: "tree6@example.com",
          password: "password",
          nickname: "동그라미",
          motto: "심플 이즈 베스트",
          createdAt: new Date(),
          updatedAt: new Date(),
        },
        {
          email: "turtle7@example.com",
          password: "password",
          nickname: "바다거북",
          motto: "천천히, 꾸준히",
          createdAt: new Date(),
          updatedAt: new Date(),
        },
        {
          email: "youth8@example.com",
          password: "password",
          nickname: "돈길만걷자",
          motto: "티끌 모아 플렉스",
          createdAt: new Date(),
          updatedAt: new Date(),
        },
        {
          email: "cloud9@example.com",
          password: "password",
          nickname: "구름이",
          motto: "늘 자유롭게",
          createdAt: new Date(),
          updatedAt: new Date(),
        },
        {
          email: "lamp10@example.com",
          password: "password",
          nickname: "램프요정",
          motto: "너의 소원을 말해봐",
          createdAt: new Date(),
          updatedAt: new Date(),
        },
        {
          email: "legend11@example.com",
          password: "password",
          nickname: "무지개",
          motto: "빛나는 삶을 꿈꾼다",
          createdAt: new Date(),
          updatedAt: new Date(),
        },
        {
          email: "money12@example.com",
          password: "password",
          nickname: "짠돌잉",
          motto: "짠테크는 멋짐",
          createdAt: new Date(),
          updatedAt: new Date(),
        },
        {
          email: "ocean13@example.com",
          password: "password",
          nickname: "푸른심장",
          motto: "바다를 닮은 마음",
          createdAt: new Date(),
          updatedAt: new Date(),
        },
        {
          email: "fast14@example.com",
          password: "password",
          nickname: "런닝맨",
          motto: "달리는 자가 승리한다",
          createdAt: new Date(),
          updatedAt: new Date(),
        },
        {
          email: "music15@example.com",
          password: "password",
          nickname: "비트메이커",
          motto: "리듬 속에 살다",
          createdAt: new Date(),
          updatedAt: new Date(),
        },
        {
          email: "sky16@example.com",
          password: "password",
          nickname: "바람돌이",
          motto: "마음 가는 대로",
          createdAt: new Date(),
          updatedAt: new Date(),
        },
        {
          email: "random17@example.com",
          password: "password",
          nickname: "허니버터칩",
          motto: "달콤한 인생",
          createdAt: new Date(),
          updatedAt: new Date(),
        },
        {
          email: "space18@example.com",
          password: "password",
          nickname: "우주인",
          motto: "나만의 별을 찾아서",
          createdAt: new Date(),
          updatedAt: new Date(),
        },
        {
          email: "flower19@example.com",
          password: "password",
          nickname: "민들레",
          motto: "작지만 강하게",
          createdAt: new Date(),
          updatedAt: new Date(),
        },
        {
          email: "zebra20@example.com",
          password: "password",
          nickname: "지브라",
          motto: "모든 길을 개척한다",
          createdAt: new Date(),
          updatedAt: new Date(),
        },
        {
          email: "adventure21@example.com",
          password: "password",
          nickname: "탐험가",
          motto: "새로운 것을 두려워하지 않기",
          createdAt: new Date(),
          updatedAt: new Date(),
        },
        {
          email: "dream22@example.com",
          password: "password",
          nickname: "몽상가",
          motto: "꿈은 이루어진다",
          createdAt: new Date(),
          updatedAt: new Date(),
        },
        {
          email: "cat23@example.com",
          password: "password",
          nickname: "고양이",
          motto: "느긋하게 살자",
          createdAt: new Date(),
          updatedAt: new Date(),
        },
        {
          email: "panda24@example.com",
          password: "password",
          nickname: "판다링",
          motto: "달콤한 나태함",
          createdAt: new Date(),
          updatedAt: new Date(),
        },
        {
          email: "bear25@example.com",
          password: "password",
          nickname: "곰돌이",
          motto: "꾸준한 삶",
          createdAt: new Date(),
          updatedAt: new Date(),
        },
        {
          email: "duck26@example.com",
          password: "password",
          nickname: "오리날다",
          motto: "한계를 넘어서",
          createdAt: new Date(),
          updatedAt: new Date(),
        },
        {
          email: "peach27@example.com",
          password: "password",
          nickname: "복숭아",
          motto: "부드럽게, 확실하게",
          createdAt: new Date(),
          updatedAt: new Date(),
        },
        {
          email: "tiger28@example.com",
          password: "password",
          nickname: "호랑이",
          motto: "기백으로 살아가자",
          createdAt: new Date(),
          updatedAt: new Date(),
        },
        {
          email: "rabbit29@example.com",
          password: "password",
          nickname: "토끼달림",
          motto: "빠르게, 신중하게",
          createdAt: new Date(),
          updatedAt: new Date(),
        },
        {
          email: "fox30@example.com",
          password: "password",
          nickname: "여우눈빛",
          motto: "날카로운 관찰자",
          createdAt: new Date(),
          updatedAt: new Date(),
        },
        {
          email: "random31@example.com",
          password: "password",
          nickname: "한강물",
          motto: "흘러가자",
          createdAt: new Date(),
          updatedAt: new Date(),
        },
        {
          email: "wind32@example.com",
          password: "password",
          nickname: "바람숲",
          motto: "자연과 함께",
          createdAt: new Date(),
          updatedAt: new Date(),
        },
        {
          email: "spark33@example.com",
          password: "password",
          nickname: "불꽃놀이",
          motto: "순간을 즐기다",
          createdAt: new Date(),
          updatedAt: new Date(),
        },
        {
          email: "mist34@example.com",
          password: "password",
          nickname: "안개숲",
          motto: "신비로운 삶",
          createdAt: new Date(),
          updatedAt: new Date(),
        },
        {
          email: "rose35@example.com",
          password: "password",
          nickname: "장미가시",
          motto: "강인함을 품다",
          createdAt: new Date(),
          updatedAt: new Date(),
        },
      ],
      {}
    );
    await queryInterface.bulkUpdate(
      "Users",
      { status: "A" },
      {} // 조건 없음
    );
  },

  async down(queryInterface, Sequelize) {
    await queryInterface.bulkDelete("Users", null, {});
  },
};
