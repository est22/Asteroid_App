const { where } = require("sequelize");
const models = require("../models");

// 밸런스 투표화면 및 결과 목록
const findAllVote = async (limit, offset) => {
  return await models.BalanceVote.findAndCountAll({
    limit,
    offset,
    order: [["id", "DESC"]],
    include: {
      model: models.User,
      attributes: ["nickname", "profile_picture"],
    },
  });
};

// 밸런스 투표 생성
const createVote = async (data) => {
  return await models.BalanceVote.create(data);
};

// 밸런스 투표 수정
const updateVote = async (id, data) => {
  return await models.BalanceVote.update(data, {
    where: { id },
  });
};

// 밸런스 투표 삭제
const deleteVote = async (id) => {
  return await models.BalanceVote.destroy({
    where: { id },
  });
};

// 밸런스 투표 참여 결과 반영
const submitVote = async (id, voteResult) => {
  return await models.BalanceVote.increment(voteResult, { where: { id } });
};

module.exports = {
  findAllVote,
  createVote,
  updateVote,
  deleteVote,
  submitVote,
};
