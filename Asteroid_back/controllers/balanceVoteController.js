const voteService = require("../services/balanceVoteService");

// 밸런스 투표화면 및 결과 목록
const findAllVote = async (req, res) => {
  const page = parseInt(req.query.page) || 1;
  const pageSize = parseInt(req.query.size) || 10;

  const limit = pageSize;
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
    const data = {
      title: req.body.title.trim(),
      description: req.body.description.trim(),
      user_id: req.user.id,
      images: req.files,
    };

    console.log("######   ", data);

    // 유효성 검사
    if (!data.title) {
      return res.status(403).json({ error: "제목을 입력하세요" });
    } else if (!data.description) {
      return res.status(403).json({ error: "내용을 입력하세요" });
    } else if (data.images.length !== 2) {
      return res
        .status(403)
        .json({ error: "투표용 이미지는 2개만 업로드 가능합니다" });
    }

    const result = await voteService.createVote(data);

    res.status(201).json({ message: "밸런스 투표 생성 성공", data: result });
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
};

// 밸런스 투표 삭제
const deleteVote = async (req, res) => {
  const data = {
    voteId: parseInt(req.params.id, 10),
    userId: req.user.id,
  };

  try {
    const result = await voteService.deleteVote(data);

    if (result) {
      res.status(200).json({ message: "밸런스 투표 삭제 성공", data: result });
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
  deleteVote,
  submitVote,
};
