const service = require("../services/commentService");

// 댓글 조회 (계층형)
const findCommentById = async (req, res) => {
  try {
    const comment = await service.findCommentById(req.params.id);

    if (comment) {
      res.status(201).json({ data: comment });
    } else {
      res.status(404).json({ error: "댓글 조회 에러" });
    }
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
};

// 댓글 생성
const createComment = async (req, res) => {
  try {
    const data = {
      postId: req.body.postId,
      content: req.body.content,
      userId: req.user.id,
    };

    const comment = await service.createComment(data);

    res.status(201).json({ data: comment });
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
};

// 댓글 수정
const updateComment = async (req, res) => {
  try {
    const data = {
      commentData: req.body,
      commentId: req.params.id,
      userId: req.user.id,
    };

    const comment = await service.updateComment(data);

    if (comment > 0) {
      res.status(200).json({ message: "댓글 수정 성공" });
    } else {
      res.status(404).json({ error: "수정할 댓글 찾을 수 없음" });
    }
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
};

// 댓글 삭제
const deleteComment = async (req, res) => {
  try {
    const data = {
      commentId: req.params.id,
      userId: req.user.id,
    };

    const comment = await service.deleteComment(data);

    if (comment) {
      res.status(200).json({ message: "댓글 삭제 성공" });
    } else {
      res.status(404).json({ error: "삭제할 댓글 찾을 수 없음" });
    }
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
};

// 댓글 좋아요
const likeComment = async (req, res) => {
  try {
    const data = {
      commentId: req.params.id,
      userId: req.user.id,
    };
    const result = await service.likeComment(data);
    res.status(200).json(result);
  } catch (e) {
    res.status(400).json({ error: e.message });
    console.error(e);
  }
};

module.exports = {
  findCommentById,
  createComment,
  updateComment,
  deleteComment,
  likeComment,
};
