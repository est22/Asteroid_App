const models = require("../models");

// 게시글 목록(무한스크롤)
const findAllPost = async (limit, offset, category_id) => {
  return await models.Post.findAndCountAll({
    limit,
    offset,
    order: [["id", "DESC"]],
    where: { category_id: category_id, isShow: true },
  });
};

// 게시글 상세보기
const findPostById = async (id) => {
  return await models.Post.findByPk(id, {
    include: {
      model: models.User,
      attributes: ["nickname", "profile_picture"],
    },
  });
};

// 댓글 총 개수 조회
const findCommentTotal = async (id) => {
  return await models.Comment.count({
    where: { post_id: id, isShow: true },
  });
};

// 게시글 생성
const createPost = async (data) => {
  return await models.Post.create(data);
};

// 게시글 수정
const updatePost = async (id, data) => {
  return await models.Post.update(data, {
    where: { id },
  });
};

// 게시글 삭제
const deletePost = async (id) => {
  return await models.Post.destroy({
    where: { id },
  });
};

module.exports = {
  findAllPost,
  findPostById,
  findCommentTotal,
  createPost,
  updatePost,
  deletePost,
};
