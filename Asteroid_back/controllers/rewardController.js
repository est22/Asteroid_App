const { Reward, Challenge } = require("../models");

const getMyRewards = async (req, res) => {
  try {
    const userId = req.user.id;
    
    const rewards = await Reward.findAll({
      where: { user_id: userId },
      include: [{
        model: Challenge,
        attributes: ['name', 'reward_name', 'reward_image_url']
      }]
    });

    if (!rewards || rewards.length === 0) {
      return res.status(200).json({
        message: "참여한 챌린지가 없습니다."
      });
    }

    const formattedRewards = rewards.map(reward => ({
      challengeName: reward.Challenge.name,
      rewardName: reward.Challenge.reward_name,
      rewardImageUrl: reward.Challenge.reward_image_url,
      achievementCount: reward.reward_count,
      credit: reward.credit
    }));

    res.status(200).json(formattedRewards);
  } catch (error) {
    console.error("보상 조회 실패:", error);
    console.error("에러 상세:", error.message);
    res.status(500).json({ message: "서버 오류가 발생했습니다." });
  }
};

module.exports = {
  getMyRewards
}; 