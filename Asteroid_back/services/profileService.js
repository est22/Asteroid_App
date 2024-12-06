const models = require("../models");

// 닉네임 중복 검사
const findUserByNickname = async (nickname, id) => {
  return await models.User.findOne({
    where: {
      nickname,
      id: { [models.Sequelize.Op.ne]: id }, // 현재 사용자 제외 (WHERE nickname = <user input nickname> AND id != <user id>;와 같음)
    },
  });
}

// 사용자 프로필 업데이트 (닉네임, 좌우명)
const updateUserProfile = async (id, data) => {
  return await models.User.update(data, {
    where: { id },
  });
};

const getUserProfile = async (userId) => {
  return await models.User.findOne({
    where: { id: userId },
    attributes: ['nickname', 'motto', 'profile_picture'],
  });
};

module.exports = {
  findUserByNickname,
  updateUserProfile,
  getUserProfile,
};