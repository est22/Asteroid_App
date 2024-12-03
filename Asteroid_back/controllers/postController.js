const postService = require("../services/postService");
const { Like, Post, User } = require("../models");

// 게시글 목록
const findAllPost = async (req, res) => {
  const page = parseInt(req.query.page) || 1;
  const pageSize = parseInt(req.query.size) || 10;

  const limit = pageSize;
  const offset = (page - 1) * pageSize;

  const data = {
    limit,
    offset,
    category_id: req.body.category_id,
    search: req.body.search,
  };

  try {
    const posts = await postService.findAllPost(data);
    res.status(200).json({ data: posts });
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
};

// 게시글 상세보기
const findPostById = async (req, res) => {
  const postId = req.params.id;

  try {
    const post = await postService.findPostById(postId);
    const commentCount = await postService.findCommentTotal(postId);

    if (post) {
      res.status(201).json({ data: post, commentCount: commentCount });
    } else {
      res.status(404).json({ error: "게시글 상세 에러" });
    }
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
};

// 게시글 생성
const createPost = async (req, res) => {
  try {
    const data = {
      postData: { ...req.body, user_id: req.user.id },
      postId: req.params.id,
      image: req.files || [],
    };

    // 유효성 검사
    if (!data.postData.title) {
      return res.status(403).json({ error: "제목을 적어주세요" });
    } else if (!data.postData.content) {
      return res.status(403).json({ error: "내용을 적어주세요" });
    }

    const newPost = await postService.createPost(data);

    res.status(201).json({ message: "게시글 생성 성공", data: newPost });
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
};

// 게시글 수정
const updatePost = async (req, res) => {
  try {
    const data = {
      postData: req.body,
      userId: req.user.id,
      postId: req.params.id,
      image: req.files || [],
    };

    const updatedPost = await postService.updatePost(data);

    res.status(200).json({ message: "게시글 수정 성공", data: updatedPost });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

// 게시글 삭제
const deletePost = async (req, res) => {
  const data = {
    postId: req.params.id,
    userId: req.user.id,
  };

  try {
    const post = await postService.deletePost(data);

    if (post) {
      res.status(200).json({ message: "게시글 삭제 성공" });
    } else {
      res.status(404).json({ error: "삭제할 게시글 찾을 수 없음" });
    }
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
};

// 게시글 좋아요
const likePost = async (req, res) => {
  try {
    const postId = req.params.id;
    const userId = req.user.id;

    const existingLike = await Like.findOne({
      attributes: ['id', 'user_id', 'target_type', 'target_id'],
      where: {
        user_id: userId,
        target_id: postId,
        target_type: 'P'
      }
    });

    if (existingLike) {
      await existingLike.destroy();
      return res.status(200).json({ message: "좋아요가 취소되었습니다." });
    }

    await Like.create({
      user_id: userId,
      target_id: postId,
      target_type: 'P'
    });

    res.status(201).json({ message: "좋아요가 추가되었습니다." });
  } catch (error) {
    console.error("좋아요 처리 실패:", error);
    res.status(500).json({ message: "서버 오류가 발생했습니다." });
  }
};

// 인기게시글
const hotPost = async (req, res) => {
  try {
    const posts = await postService.hotPost();
    res.status(200).json({ data: posts });
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
};

module.exports = {
  findAllPost,
  findPostById,
  createPost,
  updatePost,
  deletePost,
  likePost,
  hotPost,
};
