const { Reward, Challenge, ChallengeParticipation } = require("../models");
const { Op } = require("sequelize");

const getMyRewards = async (req, res) => {
  try {
    const userId = req.user.id;
    
    const rewards = await Reward.findAll({
      where: { user_id: userId },
      include: [{
        model: Challenge,
        attributes: ['name', 'reward_name', 'reward_image_url']
      }, {
        model: ChallengeParticipation,
        attributes: ['status'],
        where: {
          [Op.or]: [
            { 
              status: "챌린지 달성",
              challenge_reported_count: 0 
            },
            { 
              status: "챌린지 수료", 
              challenge_reported_count: 0 
            }
          ]
        }
      }],
      order: [['updatedAt', 'DESC']]
    });

    if (!rewards || rewards.length === 0) {
      return res.status(200).json({
        message: "참여한 챌린지가 없습니다."
      });
    }

    const formattedRewards = rewards.map(reward => ({
      challengeName: reward.Challenge.name,
      rewardName: reward.ChallengeParticipation.status === "챌린지 달성" ? 
        reward.Challenge.reward_name : null,
      rewardImageUrl: reward.ChallengeParticipation.status === "챌린지 달성" ? 
        reward.Challenge.reward_image_url : null,
      credit: reward.credit,
      achievedAt: reward.updatedAt,
      status: reward.ChallengeParticipation.status
    }));

    res.status(200).json(formattedRewards);
  } catch (error) {
    console.error("보상 조회 실패:", error);
    res.status(500).json({ message: "서버 오류가 발생했습니다." });
  }
};

module.exports = {
  getMyRewards
}; 