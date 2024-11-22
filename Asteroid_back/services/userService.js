const models = require("../models");

// 회원가입
const createUser = async (data) => {
  return await models.User.create(data);
};

const findAllUsers = async () => {
  return await models.User.findAll();
};

// 유저 프로필 설정 (최초도 포함)
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

// 비밀번호 재설정 
const updatePassword = async (email, newPassword) => {
  const user = await db.User.findOne({ where: { email } });
  if (user) {
    await user.update({ password: newPassword });
  }
};


module.exports = {
  createUser,
  findAllUsers,
  updateUser, // 최초 닉네임, 소비좌우명 설정도 포함
  findUserByEmail,
  updatePassword,
};
