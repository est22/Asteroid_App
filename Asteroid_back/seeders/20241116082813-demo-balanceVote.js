"use strict";

/** @type {import('sequelize-cli').Seed} */
module.exports = {
  async up(queryInterface, Sequelize) {
    await queryInterface.bulkInsert("BalanceVotes", [
      {
        title: "고양이짱",
        description: "누가 더 귀여움?",
        user_id: 3,
        image1:
          "https://flexible.img.hani.co.kr/flexible/normal/970/777/imgdb/resize/2019/0926/00501881_20190926.JPG",
        image2:
          "https://dimg.donga.com/wps/NEWS/IMAGE/2023/05/12/119255016.1.jpg",
        vote1_count: 0,
        vote2_count: 0,
        isShow: true,
        createdAt: new Date(),
        updatedAt: new Date(),
      },
      {
        title: "고양이 최고",
        description: "누가 더 귀여움?",
        user_id: 3,
        image1:
          "https://flexible.img.hani.co.kr/flexible/normal/970/777/imgdb/resize/2019/0926/00501881_20190926.JPG",
        image2:
          "https://dimg.donga.com/wps/NEWS/IMAGE/2023/05/12/119255016.1.jpg",
        vote1_count: 0,
        vote2_count: 0,
        isShow: true,
        createdAt: new Date(),
        updatedAt: new Date(),
      },
      {
        title: "고양이 따봉",
        description: "누가 더 귀여움?",
        user_id: 3,
        image1:
          "https://flexible.img.hani.co.kr/flexible/normal/970/777/imgdb/resize/2019/0926/00501881_20190926.JPG",
        image2:
          "https://dimg.donga.com/wps/NEWS/IMAGE/2023/05/12/119255016.1.jpg",
        vote1_count: 0,
        vote2_count: 0,
        isShow: true,
        createdAt: new Date(),
        updatedAt: new Date(),
      },
      {
        title: "디아루가 vs 펄기아",
        description: "둘 다 멋있는데 난 못 고르겠어~",
        user_id: 4,
        image1:
          "https://static.wikia.nocookie.net/pokemon/images/c/cf/디아루가_브다샤펄_공식_일러스트.png/revision/latest/scale-to-width-down/1200?cb=20210227134625&path-prefix=ko",
        image2:
          "https://static.wikia.nocookie.net/pokemon/images/0/01/펄기아_공식_일러스트.png/revision/latest?cb=20190606084124&path-prefix=ko",
        vote1_count: 0,
        vote2_count: 0,
        isShow: true,
        createdAt: new Date(),
        updatedAt: new Date(),
      },
    ]);
  },

  async down(queryInterface, Sequelize) {
    await queryInterface.bulkDelete("BalanceVotes", null, {});
  },
};
