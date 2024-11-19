'use strict';

/** @type {import('sequelize-cli').Migration} */
module.exports = {
  async up(queryInterface, Sequelize) {
    await queryInterface.bulkInsert("ChallengeImages", [
      // 인기 챌린지 "3000원 이하 커피 마시기" (20명 참여)
      { image_url: "https://images.unsplash.com/photo-1616566455425-869e3e5fbc9b", user_id: 3, challenge_id: 2, createdAt: new Date(), updatedAt: new Date() },
      { image_url: "https://images.unsplash.com/photo-1551292060-d18fcdb5cb91", user_id: 5, challenge_id: 2, createdAt: new Date(), updatedAt: new Date() },
      { image_url: "https://images.unsplash.com/photo-1616566455425-869e3e5fbc9b", user_id: 8, challenge_id: 2, createdAt: new Date(), updatedAt: new Date() },
      { image_url: "https://images.unsplash.com/photo-1551292060-d18fcdb5cb91", user_id: 1, challenge_id: 2, createdAt: new Date(), updatedAt: new Date() },
      { image_url: "https://images.unsplash.com/photo-1616566455425-869e3e5fbc9b", user_id: 2, challenge_id: 2, createdAt: new Date(), updatedAt: new Date() },
      { image_url: "https://images.unsplash.com/photo-1551292060-d18fcdb5cb91", user_id: 6, challenge_id: 2, createdAt: new Date(), updatedAt: new Date() },
      { image_url: "https://images.unsplash.com/photo-1616566455425-869e3e5fbc9b", user_id: 10, challenge_id: 2, createdAt: new Date(), updatedAt: new Date() },
      { image_url: "https://images.unsplash.com/photo-1551292060-d18fcdb5cb91", user_id: 13, challenge_id: 2, createdAt: new Date(), updatedAt: new Date() },
      { image_url: "https://images.unsplash.com/photo-1616566455425-869e3e5fbc9b", user_id: 14, challenge_id: 2, createdAt: new Date(), updatedAt: new Date() },
      { image_url: "https://images.unsplash.com/photo-1616566455425-869e3e5fbc9b", user_id: 15, challenge_id: 2, createdAt: new Date(), updatedAt: new Date() },
      { image_url: "https://images.unsplash.com/photo-1551292060-d18fcdb5cb91", user_id: 17, challenge_id: 2, createdAt: new Date(), updatedAt: new Date() },
      { image_url: "https://images.unsplash.com/photo-1616566455425-869e3e5fbc9b", user_id: 18, challenge_id: 2, createdAt: new Date(), updatedAt: new Date() },
      { image_url: "https://images.unsplash.com/photo-1616566455425-869e3e5fbc9b", user_id: 19, challenge_id: 2, createdAt: new Date(), updatedAt: new Date() },
      { image_url: "https://images.unsplash.com/photo-1616566455425-869e3e5fbc9b", user_id: 20, challenge_id: 2, createdAt: new Date(), updatedAt: new Date() },
      { image_url: "https://images.unsplash.com/photo-1616566455425-869e3e5fbc9b", user_id: 9, challenge_id: 2, createdAt: new Date(), updatedAt: new Date() },
      { image_url: "https://images.unsplash.com/photo-1616566455425-869e3e5fbc9b", user_id: 21, challenge_id: 2, createdAt: new Date(), updatedAt: new Date() },
      { image_url: "https://images.unsplash.com/photo-1616566455425-869e3e5fbc9b", user_id: 22, challenge_id: 2, createdAt: new Date(), updatedAt: new Date() },
      { image_url: "https://images.unsplash.com/photo-1616566455425-869e3e5fbc9b", user_id: 23, challenge_id: 2, createdAt: new Date(), updatedAt: new Date() },
      { image_url: "https://images.unsplash.com/photo-1616566455425-869e3e5fbc9b", user_id: 24, challenge_id: 2, createdAt: new Date(), updatedAt: new Date() },
      
      // 하루 3만원 이하로 소비하기 (10명 참여)
      { image_url: "https://images.unsplash.com/photo-1616566455425-869e3e5fbc9b", user_id: 3, challenge_id: 1, createdAt: new Date(), updatedAt: new Date() },
      { image_url: "https://images.unsplash.com/photo-1551292060-d18fcdb5cb91", user_id: 5, challenge_id: 1, createdAt: new Date(), updatedAt: new Date() },
      { image_url: "https://images.unsplash.com/photo-1616566455425-869e3e5fbc9b", user_id: 8, challenge_id: 1, createdAt: new Date(), updatedAt: new Date() },
      { image_url: "https://images.unsplash.com/photo-1551292060-d18fcdb5cb91", user_id: 6, challenge_id: 1, createdAt: new Date(), updatedAt: new Date() },
      { image_url: "https://images.unsplash.com/photo-1616566455425-869e3e5fbc9b", user_id: 10, challenge_id: 1, createdAt: new Date(), updatedAt: new Date() },
      { image_url: "https://images.unsplash.com/photo-1551292060-d18fcdb5cb91", user_id: 2, challenge_id: 1, createdAt: new Date(), updatedAt: new Date() },
      { image_url: "https://images.unsplash.com/photo-1616566455425-869e3e5fbc9b", user_id: 12, challenge_id: 1, createdAt: new Date(), updatedAt: new Date() },
      { image_url: "https://images.unsplash.com/photo-1616566455425-869e3e5fbc9b", user_id: 14, challenge_id: 1, createdAt: new Date(), updatedAt: new Date() },
      { image_url: "https://images.unsplash.com/photo-1616566455425-869e3e5fbc9b", user_id: 18, challenge_id: 1, createdAt: new Date(), updatedAt: new Date() },
      { image_url: "https://images.unsplash.com/photo-1616566455425-869e3e5fbc9b", user_id: 19, challenge_id: 1, createdAt: new Date(), updatedAt: new Date() },

      // 일주일 외식 안 하기 (6명 참여)
      { image_url: "https://images.unsplash.com/photo-1616566455425-869e3e5fbc9b", user_id: 1, challenge_id: 3, createdAt: new Date(), updatedAt: new Date() },
      { image_url: "https://images.unsplash.com/photo-1616566455425-869e3e5fbc9b", user_id: 4, challenge_id: 3, createdAt: new Date(), updatedAt: new Date() },
      { image_url: "https://images.unsplash.com/photo-1551292060-d18fcdb5cb91", user_id: 7, challenge_id: 3, createdAt: new Date(), updatedAt: new Date() },
      { image_url: "https://images.unsplash.com/photo-1616566455425-869e3e5fbc9b", user_id: 9, challenge_id: 3, createdAt: new Date(), updatedAt: new Date() },
      { image_url: "https://images.unsplash.com/photo-1616566455425-869e3e5fbc9b", user_id: 11, challenge_id: 3, createdAt: new Date(), updatedAt: new Date() },
      { image_url: "https://images.unsplash.com/photo-1616566455425-869e3e5fbc9b", user_id: 13, challenge_id: 3, createdAt: new Date(), updatedAt: new Date() },

      // 하루 10만원 이하로 소비하기 (5명 참여)
      { image_url: "https://images.unsplash.com/photo-1616566455425-869e3e5fbc9b", user_id: 2, challenge_id: 4, createdAt: new Date(), updatedAt: new Date() },
      { image_url: "https://images.unsplash.com/photo-1616566455425-869e3e5fbc9b", user_id: 6, challenge_id: 4, createdAt: new Date(), updatedAt: new Date() },
      { image_url: "https://images.unsplash.com/photo-1551292060-d18fcdb5cb91", user_id: 3, challenge_id: 4, createdAt: new Date(), updatedAt: new Date() },
      { image_url: "https://images.unsplash.com/photo-1616566455425-869e3e5fbc9b", user_id: 8, challenge_id: 4, createdAt: new Date(), updatedAt: new Date() },
      { image_url: "https://images.unsplash.com/photo-1616566455425-869e3e5fbc9b", user_id: 9, challenge_id: 4, createdAt: new Date(), updatedAt: new Date() },
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
