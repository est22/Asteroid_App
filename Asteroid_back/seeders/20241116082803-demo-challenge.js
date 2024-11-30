'use strict';

/** @type {import('sequelize-cli').Migration} */
module.exports = {
  async up(queryInterface, Sequelize) {
    await queryInterface.bulkInsert(
      "Challenges",
      [
        {
          name: "하루 3만원 이하로 소비하기",
          period: 14,
          status: "O",
          description: "하루 지출을 3만원 이하로 제한해보세요.",
          reward_name: "알뜰한 소행성",
          reward_image_url:
            "https://t4.ftcdn.net/jpg/02/38/89/45/240_F_238894523_AppCGf61ebqIYZNWJOf0M0m9APW02Rj3.jpg",
          createdAt: new Date(),
          updatedAt: new Date(),
        },
        {
          name: "3000원 이하 커피 마시기",
          period: 14,
          status: "O",
          description: "저렴하고 맛있는 커피 찾기!",
          reward_name: "커피맛 소행성",
          reward_image_url:
            "https://stock.adobe.com/kr/images/full-disk-of-planet-pluto-globe-from-space-isolated-on-white-background-elements-of-this-image-furnished-by-nasa/248279954",
          createdAt: new Date(),
          updatedAt: new Date(),
        },
        {
          name: "일주일 외식 안 하기",
          period: 7,
          status: "O",
          description: "직접 요리해서 소비 줄이기 도전!",
          reward_name: "흑백 소행성",
          reward_image_url:
            "https://t4.ftcdn.net/jpg/06/24/71/67/240_F_624716702_E4DEc0nj3IEQo7BhvVuDbAXVAldvHWNf.jpg",
          createdAt: new Date(),
          updatedAt: new Date(),
        },
        {
          name: "하루 10만원 이하로 소비하기",
          period: 14,
          status: "O",
          description: "불필요한 지출을 줄이고 나의 예산 안에서 살기.",
          reward_name: "검소한 소행성",
          reward_image_url:
            "https://t4.ftcdn.net/jpg/08/15/16/87/240_F_815168702_r5dGfBLfIGF6DLVEjtewumQ87K9uzUyP.jpg",
          createdAt: new Date(),
          updatedAt: new Date(),
        },
        {
          name: "2주간 충동구매 안 하기",
          period: 14,
          status: "O",
          description: "계획적인 소비 생활 실천!",
          reward_name: "차분한 소행성",
          reward_image_url:
            "https://t3.ftcdn.net/jpg/01/50/14/60/240_F_150146076_vzkYLzjyBMXLFi80e3fQoXYn8jNkCI0y.jpg",
          createdAt: new Date(),
          updatedAt: new Date(),
        },
        {
          name: "홈카페 실천하기",
          period: 7,
          status: "O",
          description: "집에서 커피 내려 마시기.",
          reward_name: "집돌이 소행성",
          reward_image_url:
            "https://t4.ftcdn.net/jpg/06/18/52/09/240_F_618520988_ctyuQjnNNCahgYBgK0A5GoBtKw5cbU9W.jpg",
          createdAt: new Date(),
          updatedAt: new Date(),
        },
        {
          name: "중고 거래로만 구매하기",
          period: 7,
          status: "O",
          description: "필요한 물건은 중고로 해결하기!",
          reward_name: "지구같은 소행성",
          reward_image_url:
            "https://t3.ftcdn.net/jpg/08/23/84/28/240_F_823842824_zL6qcYOSEO0E6pqv83UXYGgYxggnfVm3.jpg",
          createdAt: new Date(),
          updatedAt: new Date(),
        },
        {
          name: "1주일 편의점 안 가기",
          period: 7,
          status: "O",
          description: "대형마트나 시장 이용으로 소비 줄이기.",
          reward_name: "편리한 소행성",
          reward_image_url:
            "https://t4.ftcdn.net/jpg/05/31/85/69/240_F_531856941_IhciHWfkotFgdbeFtrOW3czc6WA5p0om.jpg",
          createdAt: new Date(),
          updatedAt: new Date(),
        },
        {
          name: "불필요한 구독 해지하기",
          period: 14,
          status: "O",
          description: "필요하지 않은 구독 서비스를 정리하세요.",
          reward_name: "구독해방 소행성",
          reward_image_url:
            "https://t3.ftcdn.net/jpg/07/03/37/56/240_F_703375696_y10cGrpcZdAYa0wqcBXoGANEJIUKK7yn.jpg",
          createdAt: new Date(),
          updatedAt: new Date(),
        },
        {
          name: "3일 동안 현금만 사용하기",
          period: 3,
          status: "O",
          description: "카드 사용을 멈추고 현금으로만 소비해보기.",
          reward_name: "소금맛 소행성",
          reward_image_url:
            "https://t4.ftcdn.net/jpg/06/24/71/65/240_F_624716525_XkfWN871xs5Rvi9MQr0oXBapAX5d2yH9.jpg",
          createdAt: new Date(),
          updatedAt: new Date(),
        },
        // 챌린지 보상 테스트용 seed data
        {
          name: "하루만 절약하기",
          period: 1,
          status: "O",
          description: "하루동안 최대한 절약해보기",
          reward_name: "하루 소행성",
          reward_image_url:
            "https://t4.ftcdn.net/jpg/06/24/71/65/240_F_624716525_XkfWN871xs5Rvi9MQr0oXBapAX5d2yH9.jpg",
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
