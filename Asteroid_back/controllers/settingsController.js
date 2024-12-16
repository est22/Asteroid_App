const {
  Post,
  Comment,
  BalanceVote,
  Message,
  Like,
  User,
  Challenge,
  ChallengeParticipation,
  Reward,
} = require("../models");
const { Op } = require("sequelize");

// 1. 내 보상 조회 (기존 rewardController에서 가져옴)
const getMyRewards = async (req, res) => {
  try {
    const userId = req.user.id;
    
    // 먼저 모든 리워드의 총합을 구합니다 (상태와 관계없이)
    const totalPoints = await Reward.sum('credit', {
      where: { user_id: userId }
    }) || 0;

    console.log("\n=== 리워드 조회 ===");
    console.log("User ID:", userId);
    console.log("Total Points:", totalPoints);

    // 달성한 챌린지 정보 조회 (completed rewards만)
    const completedRewards = await Reward.findAll({
      where: { user_id: userId },
      include: [
        {
          model: Challenge,
          attributes: ["name", "reward_name", "reward_image_url"],
        },
        {
          model: ChallengeParticipation,
          attributes: ["status"],
          where: {
            [Op.or]: [
              { status: "챌린지 달성", challenge_reported_count: 0 },
              { status: "챌린지 수료", challenge_reported_count: 0 },
            ],
          },
        },
      ],
      order: [["updatedAt", "DESC"]],
    });

    if (!completedRewards || completedRewards.length === 0) {
    if (!completedRewards || completedRewards.length === 0) {
      return res.status(200).json({
        message: "챌린지를 달성하고 행성을 모아보세요!",
        totalPoints  // 보상이 없어도 총 포인트는 반환
      });
    }

    const formattedRewards = completedRewards.map(reward => ({
      challengeName: reward.Challenge.name,
      rewardName:
        reward.ChallengeParticipation.status === "챌린지 달성"
          ? reward.Challenge.reward_name
          : null,
      rewardImageUrl:
        reward.ChallengeParticipation.status === "챌린지 달성"
          ? reward.Challenge.reward_image_url
          : null,
      credit: reward.credit,
      achievedAt: reward.updatedAt,
      status: reward.ChallengeParticipation.status,
    }));

    res.status(200).json({
      data: formattedRewards,
      totalPoints
    });
  } catch (error) {
    console.error("보상 조회 실패:", error);
    res.status(500).json({ message: "서버 오류가 발생했습니다." });
  }
};

// 2. 내 진행중인 챌린지 (기존 challengeController에서 가져옴)
const getMyOngoingChallenges = async (req, res) => {
  try {
    const userId = req.user.id;
    const currentDate = new Date();
    const currentDate = new Date();

    const ongoingChallenges = await ChallengeParticipation.findAll({
      where: {
        user_id: userId,
        status: "참여중",
        end_date: {
          [Op.gte]: currentDate  // end_date가 현재 날짜보다 크거나 같은 경우만 조회
        }
      },
      include: [
        {
          model: Challenge,
          attributes: [
            "id",
            "name",
            "period",
            "description",
            "reward_name",
            "reward_image_url",
          ],
        },
      ],
    });

    const formattedChallenges = ongoingChallenges.map((participation) => ({
      challengeId: participation.Challenge.id,
      challengeName: participation.Challenge.name,
      period: participation.Challenge.period,
      description: participation.Challenge.description,
      rewardName: participation.Challenge.reward_name,
      rewardImageUrl: participation.Challenge.reward_image_url,
      startDate: participation.start_date,
      endDate: participation.end_date,
      reportCount: participation.challenge_reported_count,
    }));

    res.status(200).json(formattedChallenges);
  } catch (error) {
    console.error("진행중인 챌린지 조회 실패:", error);
    res.status(500).json({ message: "서버 오류가 발생했습니다." });
  }
};

// 3. 내 게시글 (게시글 + 밸런스 투표)
const getMyPosts = async (req, res) => {
  try {
    const userId = req.user.id;

    // 커뮤니티 게시글 조회
    const posts = await Post.findAll({
      where: { user_id: userId, isShow: true },
      order: [["createdAt", "DESC"]],
    });

    // 밸런스 투표 조회
    const balanceVotes = await BalanceVote.findAll({
      where: { user_id: userId, isShow: true },
      order: [["createdAt", "DESC"]],
    });

    res.status(200).json({
      posts: posts,
      balanceVotes: balanceVotes,
    });
  } catch (error) {
    console.error("내 게시글 조회 실패:", error);
    res.status(500).json({ message: "서버 오류가 발생했습니다." });
  }
};

// 4. 내 댓글
const getMyComments = async (req, res) => {
  try {
    const userId = req.user.id;

    const comments = await Comment.findAll({
      where: { user_id: userId, isShow: true },
      include: [
        {
          model: Post,
          where: { isShow: true },
          attributes: ["title"],
        },
      ],
      order: [["createdAt", "DESC"]],
    });

    if (!comments || comments.length === 0) {
      return res.status(200).json({
        message: "댓글이 없습니다.",
      });
    }

    const formattedComments = comments.map((comment) => ({
      id: comment.id,
      postTitle: comment.Post.title,
      content: comment.content,
      createdAt: comment.createdAt,
    }));

    res.status(200).json(formattedComments);
  } catch (error) {
    console.error("내가 단 댓글 조회 실패:", error);
    res.status(500).json({ message: "서버 오류가 발생했습니다." });
  }
};

// 5. 내 쪽지
const getMyMessages = async (req, res) => {
  try {
    const userId = req.user.id;

    const messages = await Message.findAll({
      where: {
        [Op.or]: [{ sender_user_id: userId }, { receiver_user_id: userId }],
      },
      include: [
        {
          model: User,
          as: "Sender",
          attributes: ["nickname"],
        },
        {
          model: User,
          as: "Receiver",
          attributes: ["nickname"],
        },
      ],
      order: [["createdAt", "DESC"]],
    });

    const formattedMessages = messages.map((message) => ({
      messageId: message.id,
      content: message.content,
      senderNickname: message.Sender.nickname,
      receiverNickname: message.Receiver.nickname,
      createdAt: message.createdAt,
    }));

    res.status(200).json(formattedMessages);
  } catch (error) {
    console.error("내 쪽지 조회 실패:", error);
    res.status(500).json({ message: "서버 오류가 발생했습니다." });
  }
};

// 6. 내가 좋아요 한 게시물
const getMyLikedPosts = async (req, res) => {
  try {
    const userId = req.user.id;

    const likedPosts = await Like.findAll({
      attributes: ["id", "user_id", "target_type", "target_id", "createdAt"],
      where: {
        user_id: userId,
        target_type: "P",
      },
      include: [
        {
          model: Post,
          as: "Post",
          attributes: ["id", "title", "content", "createdAt"],
          required: false,
        },
      ],
      order: [[{ model: Post, as: "Post" }, "createdAt", "DESC"]],
    });

    if (!likedPosts || likedPosts.length === 0) {
      return res.status(200).json({
        message: "좋아요한 게시물이 없습니다.",
      });
    }

    const formattedLikedPosts = likedPosts
      .filter((like) => like.Post) // null인 Post 제외
      .map((like) => ({
        postId: like.Post.id,
        title: like.Post.title,
        content: like.Post.content,
        likedAt: like.createdAt,
      }));

    res.status(200).json(formattedLikedPosts);
  } catch (error) {
    console.error("내가 좋아요 한 게시물 조회 실패:", error);
    res.status(500).json({ message: "서버 오류가 발생했습니다." });
  }
};

module.exports = {
  getMyRewards,
  getMyOngoingChallenges,
  getMyPosts,
  getMyComments,
  getMyMessages,
  getMyLikedPosts,
};
