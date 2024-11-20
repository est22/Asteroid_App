const postService = require("../services/postService");

// 게시글 목록
const findAllPost = async (req, res, next) => {
  // 무한 스크롤
  const page = parseInt(req.query.page) || 1;
  const pageSize = parseInt(req.query.size) || 10;

  const limit = pageSize;
  const offset = (page - 1) * pageSize;
  const categoryId = req.query.category_id;

  try {
    const posts = await postService.findAllPost(limit, offset, categoryId);
    res.status(200).json({ data: posts });
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
};

// 게시글 상세보기
const findPostById = async (req, res) => {
  try {
    const post = await postService.findPostById(req.params.id);

    if (post) {
      res.status(201).json({ data: post });
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
    const post = await postService.createPost(req.body);
    res.status(201).json({ data: post });
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
};

// 게시글 수정
const updatePost = async (req, res) => {
  try {
    const post = await postService.updatePost(req.params.id, req.body);

    if (post[0] > 0) {
      res.status(200).json({ message: "게시글 수정 성공" });
    } else {
      res.status(404).json({ error: "수정할 게시글 찾을 수 없음" });
    }
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
};

// 게시글 삭제
const deletePost = async (req, res) => {
  try {
    const post = await postService.deletePost(req.params.id);

    if (post) {
      res.status(200).json({ message: "게시글 삭제 성공" });
    } else {
      res.status(404).json({ error: "삭제할 게시글 찾을 수 없음" });
    }
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
};
