const postService = require("../services/postService");
const {
  uploadPhotos,
  saveFilesToDB,
} = require("../services/fileUploadService");

// 게시글 목록
const findAllPost = async (req, res) => {
  const page = parseInt(req.query.page) || 1;
  const pageSize = parseInt(req.query.size) || 10;

  const limit = pageSize;
  const offset = (page - 1) * pageSize;
  const { category_id, search } = req.body;

  try {
    const posts = await postService.findAllPost(limit, offset, {
      category_id,
      search,
    });
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
    const postData = {
      ...req.body,
      user_id: req.user.id,
    };

    const data = {
      post: postData,
      image: req.files || [],
    };

    const newPost = await postService.createPost(data);

    res.status(201).json({ message: "게시글 생성 성공", data: newPost });
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
};

// 게시글 수정
const updatePost = async (req, res) => {
  try {
    const postId = req.params.id;
    const postData = {
      ...req.body,
      user_id: req.user.id,
    };

    const data = {
      post: postData,
      image: req.files || [],
    };
    console.log("%%%%%%%%%     ", data);

    const updatedPost = await postService.updatePost(postId, data);

    res.status(200).json({ message: "게시글 수정 성공", data: updatedPost });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

// 게시글 삭제
const deletePost = async (req, res) => {
  const postId = req.params.id;
  const userId = req.user.id;

  try {
    const post = await postService.deletePost(postId, userId);

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
const likePost = async () => {
  const postId = req.params.id;
  const userId = req.user.id;

  try {
    const result = await postService.likePost(postId, userId);
    res.status(200).json(result);
  } catch (e) {
    res.status(400).json({ error: e.message });
    console.error(e);
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
