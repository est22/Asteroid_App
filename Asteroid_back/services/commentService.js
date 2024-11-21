const { where } = require("sequelize");
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
  return await models.Comment.create(data);
};

// 댓글 수정
const updateComment = async (id, data) => {
  return await models.Comment.update(data, {
    where: { id },
  });
};

// 댓글 삭제
const deleteComment = async (id) => {
  return await models.Comment.destroy({
    where: { id },
  });
};

module.exports = {
  findCommentById,
  createComment,
  updateComment,
  deleteComment,
};
