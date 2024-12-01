const models = require("../models");

// 댓글 조회 (계층형)
const findCommentById = async (id) => {
  return await models.Comment.findAll({
    where: { post_id: id, isShow: true, parent_comment_id: null },
    include: [
      {
        // 대댓글 정보
        model: models.Comment,
        where: { isShow: true },
        required: false,
        include: [
          {
            model: models.User,
            attributes: ["nickname", "profile_picture"],
          },
        ],
      },
      {
        // 댓글 작성자 정보
        model: models.User,
        attributes: ["nickname", "profile_picture"],
      },
    ],
    order: [["createdAt"]],
  });
};

// 댓글 생성
const createComment = async (data) => {
  const { commentData, userId } = data;
  const result = await models.Comment.create({
    ...commentData,
    user_id: userId,
  });
  return result;
};

// 댓글 수정
const updateComment = async (data) => {
  const { commentId, commentData, userId } = data;
  const result = await models.Comment.update(commentData, {
    where: { id: commentId, user_id: userId },
  });
  return result[0];
};

// 댓글 삭제
const deleteComment = async (data) => {
  const { commentId, userId } = data;
  const result = await models.Comment.update(
    { isShow: false },
    {
      where: { id: commentId, user_id: userId },
    }
  );
  return result[0] > 0;
};

// 댓글 좋아요
const likeComment = async (data) => {
  const { commentId, userId } = data;
  // 좋아요 여부 확인
  const likeCheck = await models.Like.findOne({
    where: { user_id: userId, target_type: "C", target_id: commentId },
  });

  let message;

  if (likeCheck) {
    // 이미 좋아요 해서 좋아요 취소
    await models.Like.destroy({
      where: { user_id: userId, target_type: "C", target_id: commentId },
    });

    // 댓글 likeTotal 감소
    await models.Comment.decrement("likeTotal", {
      where: { id: commentId },
    });

    message = "좋아요 취소";
  } else {
    // 좋아요 내역 없어서 좋아요 처리
    await models.Like.create({
      user_id: userId,
      target_type: "C",
      target_id: commentId,
    });

    // 댓글 likeTotal 증가
    await models.Comment.increment("likeTotal", {
      where: { id: commentId },
    });

    message = "좋아요 성공";
  }

  return message;
};

module.exports = {
  findCommentById,
  createComment,
  updateComment,
  deleteComment,
  likeComment,
};
