const { Op } = require("sequelize");
const moment = require("moment");
const models = require("../models");

// 게시글 목록
const findAllPost = async (limit, offset, { category_id, search }) => {
  const whereCondition = search
    ? {
        [Op.or]: [
          { title: { [Op.like]: `%${search}%` } },
          { content: { [Op.like]: `%${search}%` } },
        ],
      }
    : {};

  return await models.Post.findAndCountAll({
    limit,
    offset,
    order: [["id", "DESC"]],
    where: { category_id: category_id, isShow: true, ...whereCondition },
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

// 게시글 좋아요
const likePost = async (postId, userId) => {
  // 좋아요 여부 확인
  const likeCheck = await models.Like.findOne({
    where: { user_id: userId, target_type: "P", target_id: postId },
  });

  let message;

  if (likeCheck) {
    // 이미 좋아요 해서 좋아요 취소
    await models.Like.destroy({
      where: { user_id: userId, target_type: "P", target_id: postId },
    });

    // 게시글 likeTotal 감소
    await models.Post.decrement("likeTotal", {
      where: { id: postId },
    });

    message = "좋아요 취소";
  } else {
    // 좋아요 내역 없어서 좋아요 처리
    await models.Like.create({
      user_id: userId,
      target_type: "P",
      target_id: postId,
    });

    // 게시글 likeTotal 증가
    await models.Post.increment("likeTotal", {
      where: { id: postId },
    });

    message = "좋아요 성공";
  }

  return message;
};

// 인기게시글
const hotPost = async () => {
  const period = moment().subtract(3, "days").toDate();

  return await models.Post.findAll({
    where: {
      isShow: true,
      createdAt: {
        [Op.gte]: period, // period 이후 날짜 조회
      },
    },
    include: [
      {
        model: models.Category,
        attributes: ["category_name"],
      },
    ],
    order: [["likeTotal", "DESC"]],
    limit: 3,
  });
};

module.exports = {
  findAllPost,
  findPostById,
  findCommentTotal,
  createPost,
  updatePost,
  deletePost,
  likePost,
  hotPost,
};
