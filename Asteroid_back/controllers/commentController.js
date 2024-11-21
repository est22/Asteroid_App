const commentService = require("../services/commentService");

// 댓글 생성
const createComment = async (req, res) => {
  try {
    const comment = await commentService.createComment(req.body);
    res.status(201).json({ data: comment });
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
};

// 댓글 수정
const updateComment = async (req, res) => {
  try {
    const comment = await commentService.updateComment(req.params.id, req.body);

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
    const comment = await commentService.deleteComment(req.params.id);

    if (comment) {
      res.status(200).json({ message: "댓글 삭제 성공" });
    } else {
      res.status(404).json({ error: "삭제할 댓글 찾을 수 없음" });
    }
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
};

module.exports = {
  createComment,
  updateComment,
  deleteComment,
};
