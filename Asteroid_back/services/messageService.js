const { Op, Sequelize } = require("sequelize");
const models = require("../models");

// 쪽지방 목록 조회
const messageRoom = async (data) => {
  const { userId } = data;

  // 나가지 않은 채팅방 조회
  const activeRooms = await models.MessageRoom.findAll({
    where: {
      [Op.or]: [
        { user1_id: userId, user1_left_at: { [Op.is]: null } },
        { user2_id: userId, user2_left_at: { [Op.is]: null } },
      ],
    },
    raw: true,
  });

  // 나가지 않은 방 대화 상대 ID 추출
  const messagingPartners = activeRooms.map((room) =>
    room.user1_id === userId ? room.user2_id : room.user1_id
  );

  // 쪽지 상대 및 최신 메시지 id 조회
  const subQuery = await models.Message.findAll({
    attributes: [
      [
        Sequelize.literal(`
        CASE
          WHEN sender_user_id = ${userId} THEN receiver_user_id
          ELSE sender_user_id
        END
      `),
        "message_user_id",
      ],
      [Sequelize.fn("MAX", Sequelize.col("Message.id")), "latest_message_id"],
      [
        Sequelize.fn(
          "COUNT",
          Sequelize.literal(`
          CASE
            WHEN receiver_user_id = ${userId} AND is_read = false THEN 1
            ELSE NULL
          END
        `)
        ),
        "unread_count",
      ],
    ],
    where: {
      [Op.or]: [{ sender_user_id: userId }, { receiver_user_id: userId }],
      [Op.or]: messagingPartners.map((partnerId) => ({
        [Op.or]: [
          { sender_user_id: userId, receiver_user_id: partnerId },
          { sender_user_id: partnerId, receiver_user_id: userId },
        ],
      })),
    },
    group: ["message_user_id"],
    order: [[Sequelize.fn("MAX", Sequelize.col("Message.id")), "DESC"]],
    raw: true,
  });

  // 최신 쪽지 id
  const latestMessageIds = subQuery.map((entry) => entry.latest_message_id);

  // 쪽지 상대 및 최신 메시지 상세 조회
  const latestMessages = await models.Message.findAll({
    where: {
      id: {
        [Op.in]: latestMessageIds,
      },
    },
    include: [
      {
        model: models.User,
        as: "Sender",
        attributes: ["id", "nickname", "profile_picture"],
      },
      {
        model: models.User,
        as: "Receiver",
        attributes: ["id", "nickname", "profile_picture"],
      },
    ],
    order: [["id", "DESC"]],
  });

  // 최종 결과
  const result = subQuery.map((entry) => {
    // 상대 ID
    const chatUserId = entry.message_user_id;

    // 상대 정보 추출
    const latestMessage = latestMessages.find(
      (message) =>
        message.sender_user_id === chatUserId ||
        message.receiver_user_id === chatUserId
    );

    const chatUser =
      latestMessage.sender_user_id === chatUserId
        ? latestMessage.Sender
        : latestMessage.Receiver;

    return {
      chat_user: chatUser, // 대화 상대 정보
      latest_message: latestMessage.content, // 최신 대화
      latest_message_time: latestMessage.createdAt, // 최신 대화 시간
      unread_count: entry.unread_count, // 안 읽은 대화 개수
    };
  });

  return result;
};

// 쪽지 상세보기
const findMessageDetail = async (data) => {
  const { sender_user_id, receiver_user_id } = data;

  // user1인지 user2인지 확인
  const room = await userCheck(data);

  // 쪽지방 나간 시간
  const leftDate =
    room.user1_id === sender_user_id ? room.user1_left_at : room.user2_left_at;

  // 방을 나갔으면 leftDate 이후의 메시지, 안 나갔으면 전체 메시지 조회
  const whereCondition = leftDate ? { createdAt: { [Op.gt]: leftDate } } : {};

  const messages = await models.Message.findAll({
    where: {
      [Op.or]: [
        {
          sender_user_id: sender_user_id,
          receiver_user_id: receiver_user_id,
        },
        {
          sender_user_id: receiver_user_id,
          receiver_user_id: sender_user_id,
        },
      ],
      ...whereCondition,
    },
    include: {
      model: models.User,
      as: "Receiver",
      attributes: ["nickname", "profile_picture"],
    },
    order: [["id", "ASC"]],
  });

  // 읽음 처리
  await models.Message.update(
    { is_read: true },
    {
      where: {
        id: {
          [Op.in]: messages.map((message) => message.id),
        },
      },
    }
  );

  return messages;
};

// 쪽지 보내기
const createMessage = async (data) => {
  const transaction = await models.sequelize.transaction(); // 트랜잭션 시작

  try {
    const { sender_user_id, receiver_user_id } = data;

    // MessageRooms 확인 후 없으면 새로 생성
    const room = await models.MessageRoom.findOrCreate({
      where: {
        [Op.or]: [
          { user1_id: sender_user_id, user2_id: receiver_user_id },
          { user1_id: receiver_user_id, user2_id: sender_user_id },
        ],
      },
      // 없을 때 기본 값
      defaults: {
        user1_id: sender_user_id,
        user2_id: receiver_user_id,
      },
      transaction,
    });

    // 쪽지 전송
    await models.Message.create(data, transaction);

    await transaction.commit();
    return { message: "보내기 성공" };
  } catch (error) {
    await transaction.rollback();
    throw new Error("쪽지 생성 실패: " + error.message);
  }
};

// 나가기
const leftMessage = async (data) => {
  // user1인지 user2인지 확인
  const room = await userCheck(data);

  const updatedData =
    room.user1_id === data.sender_user_id
      ? { user1_left_at: new Date() }
      : { user2_left_at: new Date() };

  // left_at 데이터로 방 나가기 처리
  return await models.MessageRoom.update(updatedData, {
    where: {
      id: room.id,
    },
  });
};

// MessageRoom에서 user1인지 user2인지 확인
const userCheck = async (data) => {
  const { sender_user_id, receiver_user_id } = data;

  return await models.MessageRoom.findOne({
    where: {
      [Op.or]: [
        { user1_id: sender_user_id, user2_id: receiver_user_id },
        { user1_id: receiver_user_id, user2_id: sender_user_id },
      ],
    },
  });
};

module.exports = {
  messageRoom,
  findMessageDetail,
  createMessage,
  leftMessage,
  userCheck,
};
