const service = require("../services/messageService");

// 쪽지방 목록 조회
const messageRoom = async (req, res) => {
  // 무한 스크롤
  const page = parseInt(req.query.page) || 1;
  const pageSize = parseInt(req.query.size) || 10;

  const limit = pageSize;
  const offset = (page - 1) * pageSize;
  const userId = req.user.id;
  // console.log("@@@@@ User ID:", userId);

  try {
    const result = await service.messageRoom(limit, offset, userId);
    res.status(200).json({ data: result });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

// 쪽지 상세보기
const findMessageDetail = async (req, res) => {
  // 무한 스크롤
  const page = parseInt(req.query.page) || 1;
  const pageSize = parseInt(req.query.size) || 10;

  const limit = pageSize;
  const offset = (page - 1) * pageSize;

  const data = {
    sender_user_id: req.user.id,
    receiver_user_id: req.body.receiver_user_id,
  };

  try {
    const result = await service.findMessageDetail(limit, offset, data);

    res.status(200).json({ data: result });
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
};

// 쪽지 보내기
const createMessage = async (req, res) => {
  try {
    const data = await service.createMessage(req.body);
    res.status(201).json({ data: data });
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
