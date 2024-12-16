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

const findUserByAppleId = async (appleId) => {
  return await models.User.findOne({
    where: { apple_id: appleId },
  });
};

const createAppleUser = async (data) => {
  return await models.User.create({
    apple_id: data.apple_id,
    email: data.email, // 이메일이 제공된 경우에만 저장됨
    status: "A", // Active 상태로 생성
  });
};

// 닉네임으로 사용자 찾기
const findUserByNickname = async (nickname) => {
  try {
    const user = await models.User.findOne({
      where: {
        nickname: nickname,
      },
    });
    return user;
  } catch (error) {
    throw error;
  }
};

const findUserByKakaoId = async (kakaoId) => {
  return await models.User.findOne({
    where: { kakao_id: kakaoId.toString() },
  });
};

const createKakaoUser = async (userData) => {
  return await models.User.create({
    kakao_id: userData.kakao_id.toString(),
    nickname: null,
    motto: null,
    profile_photo: null,
  });
};

const findUserByKakaoId = async (kakaoId) => {
    return await models.User.findOne({ 
        where: { kakao_id: kakaoId.toString() } 
    });
};

const createKakaoUser = async (userData) => {
    return await models.User.create({
        kakao_id: userData.kakao_id.toString(),
        nickname: null,
        motto: null,
        profile_photo: null
    });
};

module.exports = {
  createUser,
  findAllUsers,
  updateUser, // 최초 닉네임, 소비좌우명 설정도 포함
  findUserByEmail,
  findUserByAppleId,
  createAppleUser,
  findUserByNickname,
  findUserByKakaoId,
  createKakaoUser,
};
