const voteService = require("../services/balanceVoteService");

// 밸런스 투표화면 및 결과 목록
// limit 값 투표하는 화면에서는 1, 결과 목록 화면에서는 10으로 설정하기
const findAllVote = async (req, res, next) => {
  const page = parseInt(req.query.page) || 1;
  const pageSize = parseInt(req.query.size) || 5;

  const screen = req.query.screen === "vote";
  const limit = screen ? 1 : pageSize;
  const offset = (page - 1) * pageSize;

  try {
    const posts = await voteService.findAllVote(limit, offset);
    res.status(200).json({ data: posts });
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
};

// 밸런스 투표 생성
const createVote = async (req, res) => {
  try {
    const post = await voteService.createVote(req.body);
    res.status(201).json({ data: post });
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
};

// 밸런스 투표 수정
const updateVote = async (req, res) => {
  try {
    const post = await voteService.updateVote(req.params.id, req.body);

    if (post > 0) {
      res.status(200).json({ message: "밸런스 투표 수정 성공", data: post });
    } else {
      res.status(404).json({ error: "수정할 투표글 찾을 수 없음" });
    }
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
};

// 밸런스 투표 삭제
const deleteVote = async (req, res) => {
  try {
    const post = await voteService.deleteVote(req.params.id);

    if (post) {
      res.status(200).json({ message: "밸런스 투표 삭제 성공" });
    } else {
      res.status(404).json({ error: "삭제할 밸런스 투표 찾을 수 없음" });
    }
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
};

// 밸런스 투표 참여 결과 반영
const submitVote = async (req, res) => {
  const voteResult = req.body.voteResult; // 'vote1_count' 또는 'vote2_count'

  try {
    const post = await voteService.updateVote(req.params.id, voteResult);

    if (post > 0) {
      res.status(200).json({ message: "밸런스 투표 성공" });
    } else {
      res.status(404).json({ error: "투표할 게시글 찾을 수 없음" });
    }
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
};

module.exports = {
  findAllVote,
  createVote,
  updateVote,
  deleteVote,
  submitVote,
};
