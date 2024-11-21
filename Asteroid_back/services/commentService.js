const { where } = require("sequelize");
const models = require("../models");

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
  createComment,
  updateComment,
  deleteComment,
};
