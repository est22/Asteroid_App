"use strict";

/** @type {import('sequelize-cli').Seed} */
module.exports = {
  async up(queryInterface, Sequelize) {
    await queryInterface.bulkInsert("BalanceVotes", [
      {
        title: "고양이짱",
        description: "누가누가 더 귀여움?",
        user_id: 3,
        image1:
          "https://flexible.img.hani.co.kr/flexible/normal/970/777/imgdb/resize/2019/0926/00501881_20190926.JPG",
        image2:
          "https://dimg.donga.com/wps/NEWS/IMAGE/2023/05/12/119255016.1.jpg",
        vote1_count: 0,
        vote2_count: 0,
        createdAt: new Date(),
        updatedAt: new Date(),
      },
      {
        title: "고양이짱",
        description: "누가누가 더 귀여움?",
        user_id: 3,
        image1:
          "https://flexible.img.hani.co.kr/flexible/normal/970/777/imgdb/resize/2019/0926/00501881_20190926.JPG",
        image2:
          "https://dimg.donga.com/wps/NEWS/IMAGE/2023/05/12/119255016.1.jpg",
        vote1_count: 0,
        vote2_count: 0,
        createdAt: new Date(),
        updatedAt: new Date(),
      },
      {
        title: "고양이짱",
        description: "누가누가 더 귀여움?",
        user_id: 3,
        image1:
          "https://flexible.img.hani.co.kr/flexible/normal/970/777/imgdb/resize/2019/0926/00501881_20190926.JPG",
        image2:
          "https://dimg.donga.com/wps/NEWS/IMAGE/2023/05/12/119255016.1.jpg",
        vote1_count: 0,
        vote2_count: 0,
        createdAt: new Date(),
        updatedAt: new Date(),
      },
      {
        title: "고양이짱",
        description: "누가누가 더 귀여움?",
        user_id: 3,
        image1:
          "https://flexible.img.hani.co.kr/flexible/normal/970/777/imgdb/resize/2019/0926/00501881_20190926.JPG",
        image2:
          "https://dimg.donga.com/wps/NEWS/IMAGE/2023/05/12/119255016.1.jpg",
        vote1_count: 0,
        vote2_count: 0,
        createdAt: new Date(),
        updatedAt: new Date(),
      },
      {
        title: "고양이짱",
        description: "누가누가 더 귀여움?",
        user_id: 3,
        image1:
          "https://flexible.img.hani.co.kr/flexible/normal/970/777/imgdb/resize/2019/0926/00501881_20190926.JPG",
        image2:
          "https://dimg.donga.com/wps/NEWS/IMAGE/2023/05/12/119255016.1.jpg",
        vote1_count: 0,
        vote2_count: 0,
        createdAt: new Date(),
        updatedAt: new Date(),
      },
    ]);
  },

  async down(queryInterface, Sequelize) {
    await queryInterface.bulkDelete("BalanceVotes", null, {});
  },
};
