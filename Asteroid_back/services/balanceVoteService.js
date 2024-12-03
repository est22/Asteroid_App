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
  const { title, description, user_id, images } = data;

  // 투표 글 업로드
  return (newData = await models.BalanceVote.create({
    title,
    description,
    user_id,
    image1: images[0]?.buffer,
    image2: images[1]?.buffer,
  }));
};

// 밸런스 투표 수정
const updateVote = async (data) => {
  const { voteId, userId } = data;

  // 밸런스 투표 존재 여부 확인
  const voteCheck = await models.BalanceVote.findOne({
    where: { id: voteId, user_id: userId, isShow: true },
  });

  // 업데이트
  const newData = await voteCheck.update(data);
  console.log("$%$%   newData", newData);

  return newData;
};

// 밸런스 투표 삭제
const deleteVote = async (data) => {
  console.log("$$$$  ", data);
  const { voteId, userId } = data;

  const vote = await models.BalanceVote.findOne({
    where: { id: voteId, user_id: userId, isShow: true },
  });

  if (!vote) {
    throw new Error("존재하지 않는 투표입니다");
  }

  // 숨겨서 삭제처럼 보이게 하기, 이미지는 삭제
  return await vote.update({ isShow: false, image1: "", image2: "" });
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
