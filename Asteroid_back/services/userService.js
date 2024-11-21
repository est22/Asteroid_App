const models = require("../models");

// 회원가입
const createUser = async (data) => {
  return await models.User.create(data);
};

const findAllUsers = async () => {
  return await models.User.findAll();
};

const updateUser = async (id, data) => {
  return await models.User.update(data, {
    where: { id },
  });
};

// 로그인
const findUserByEmail = async (email) => {
  return await models.User.findOne({
    where: { email },
  });
};

module.exports = {
  createUser,
  findAllUsers,
  updateUser,
  findUserByEmail,
};
