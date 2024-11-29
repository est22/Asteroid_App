const { Op } = require("sequelize");
const moment = require("moment");
const { Post, PostImage, sequelize } = require("../models");
const fileUploadService = require("./fileUploadService");

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

  return await Post.findAndCountAll({
    limit,
    offset,
    order: [["id", "DESC"]],
    where: { category_id: category_id, isShow: true, ...whereCondition },
  });
};

// 게시글 상세보기
const findPostById = async (id) => {
  return await Post.findByPk(id, {
    include: {
      model: User,
      attributes: ["nickname", "profile_picture"],
    },
  });
};

// 댓글 총 개수 조회
const findCommentTotal = async (id) => {
  return await Comment.count({
    where: { post_id: id, isShow: true },
  });
};

// 게시글 생성
const createPost = async (data) => {
  const transaction = await sequelize.transaction(); // 트랜잭션 시작
  const image = data.image;

  try {
    // 게시글 업로드
    const newPost = await Post.create(data.post, { transaction });
    console.log("생성한 게시글 아이디 : ", newPost.id);

    // 이미지 업로드
    if (image && image.length > 0) {
      await fileUploadService.saveFilesToDB(
        image,
        newPost.id,
        "PostImage",
        transaction
      );
    }

    await transaction.commit();
    return newPost;
  } catch (error) {
    await transaction.rollback();
    throw new Error("게시글 생성 실패: " + error.message);
  }
};

// 게시글 수정
const updatePost = async (postId, data) => {
  const transaction = await sequelize.transaction(); // 트랜잭션 시작
  const image = data.image;

  try {
    // 게시글 수정
    const post = await Post.findOne({
      where: { id: postId, isShow: true },
      transaction,
    });

    if (!post) {
      throw new Error("게시글을 찾을 수 없습니다.");
    }

    // 게시글 업데이트
    await post.update(data.post, { transaction });

    // 이미지 업데이트
    if (image && image.length > 0) {
      // 기존 이미지 삭제
      await PostImage.destroy({ where: { post_id: postId }, transaction });

      // 새로운 이미지 저장
      await fileUploadService.saveFilesToDB(
        image,
        postId,
        "PostImage",
        transaction
      );
    } else if (image === undefined || image.length === 0) {
      // 이미지를 삭제하는 경우, 기존 이미지를 삭제하지 않으면 안 됨
      await PostImage.destroy({ where: { post_id: postId }, transaction });
    }

    await transaction.commit();
    return post;
  } catch (error) {
    await transaction.rollback();
    throw new Error("게시글 수정 실패: " + error.message);
  }
};

// 게시글 삭제
const deletePost = async (postId, userId) => {
  const transaction = await sequelize.transaction(); // 트랜잭션 시작

  try {
    const post = await Post.findOne({
      where: { id: postId, user_id: userId },
      transaction,
    });
    if (!post) {
      throw new Error("게시글을 찾을 수 없습니다.");
    }

    // 숨겨서 삭제처럼 보이게 하기
    await post.update({ isShow: false }, { transaction });
    await PostImage.update(
      { isShow: false },
      { where: { post_id: postId }, transaction }
    );

    await transaction.commit();
    return post;
  } catch (error) {
    await transaction.rollback();
    throw new Error("게시글 삭제 실패: " + error.message);
  }
};

// 게시글 좋아요
const likePost = async (postId, userId) => {
  // 좋아요 여부 확인
  const likeCheck = await Like.findOne({
    where: { user_id: userId, target_type: "P", target_id: postId },
  });

  let message;

  if (likeCheck) {
    // 이미 좋아요 해서 좋아요 취소
    await Like.destroy({
      where: { user_id: userId, target_type: "P", target_id: postId },
    });

    // 게시글 likeTotal 감소
    await Post.decrement("likeTotal", {
      where: { id: postId },
    });

    message = "좋아요 취소";
  } else {
    // 좋아요 내역 없어서 좋아요 처리
    await Like.create({
      user_id: userId,
      target_type: "P",
      target_id: postId,
    });

    // 게시글 likeTotal 증가
    await Post.increment("likeTotal", {
      where: { id: postId },
    });

    message = "좋아요 성공";
  }

  return message;
};

// 인기게시글
const hotPost = async () => {
  const period = moment().subtract(3, "days").toDate();

  return await Post.findAll({
    where: {
      isShow: true,
      createdAt: {
        [Op.gte]: period, // period 이후 날짜 조회
      },
    },
    include: [
      {
        model: Category,
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
