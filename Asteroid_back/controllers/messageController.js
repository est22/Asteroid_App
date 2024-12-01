const service = require("../services/messageService");

// 쪽지방 목록 조회
const messageRoom = async (req, res) => {
  // 무한 스크롤
  const page = parseInt(req.query.page) || 1;
  const pageSize = parseInt(req.query.size) || 10;

  const limit = pageSize;
  const offset = (page - 1) * pageSize;

  const data = {
    limit,
    offset,
    userId: req.user.id,
  };

  try {
    const result = await service.messageRoom(data);
    res.status(200).json({ data: result });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

// 쪽지 상세보기
const findMessageDetail = async (req, res) => {
  // 무한 스크롤
  const page = parseInt(req.query.page) || 1;
  const pageSize = parseInt(req.query.size) || 20;

  const limit = pageSize;
  const offset = (page - 1) * pageSize;

  const data = {
    limit,
    offset,
    sender_user_id: req.user.id,
    receiver_user_id: req.body.receiver_user_id,
  };

  try {
    const result = await service.findMessageDetail(data);

    res.status(200).json({ data: result });
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
};

// 쪽지 보내기
const createMessage = async (req, res) => {
  const data = {
    sender_user_id: req.user.id,
    receiver_user_id: req.body.receiver_user_id,
    content: req.body.content.trim(),
  };

  // 유효성 검사
  if (data.receiver_user_id === 1) {
    return res
      .status(403)
      .json({ error: "관리자에게 쪽지를 보낼 수 없습니다." });
  } else if (data.receiver_user_id === data.sender_user_id) {
    return res.status(403).json({ error: "본인에게 쪽지를 보낼 수 없습니다." });
  }

  if (!data.content) {
    return res.status(403).json({ error: "내용을 적어주세요" });
  }

  try {
    const result = await service.createMessage(data);
    res
      .status(201)
      .json({ message: "쪽지가 성공적으로 전송되었습니다.", data: result });
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
};

// 나가기
const leftMessage = async (req, res) => {
  const data = {
    sender_user_id: req.user.id,
    receiver_user_id: req.body.receiver_user_id,
  };

  try {
    const result = await service.leftMessage(data);
    res.status(201).json({ data: result });
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
};

module.exports = {
  messageRoom,
  findMessageDetail,
  createMessage,
  leftMessage,
};
