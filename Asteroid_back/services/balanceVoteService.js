const models = require("../models");
const fileUploadService = require("../services/fileUploadService");

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
  const transaction = await models.sequelize.transaction();
  const { title, description, user_id, images } = data;

  try {
    // 이미지 제외하고 데이터 생성
    const newData = await models.BalanceVote.create(
      {
        title,
        description,
        user_id,
      },
      { transaction }
    );

    // 이미지 업로드
    if (images && images.length > 0) {
      await fileUploadService.saveVoteImagesToDB(images, newData.id, {
        transaction,
      });
    }

    await transaction.commit();
    return newData;
  } catch (error) {
    await transaction.rollback();
    throw error;
  }
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
  deleteVote,
  submitVote,
};
