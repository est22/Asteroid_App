const { Challenge, ChallengeParticipation, ChallengeImage, User, Reward } = require("../models");
const { uploadPhotos, saveFilesToDB } = require("../services/fileUploadService");
const { checkDailyUpload } = require('../services/challengeService');
const { Op } = require('sequelize');

// 1. 챌린지 목록 반환
const getChallengeList = async (req, res) => {
  try {
    const challenges = await Challenge.findAll({
      attributes: ["id", "name"], // id와 name만 반환
    });

    return res.status(200).json(challenges); // 배열 형태로 반환
  } catch (error) {
    console.error("챌린지 목록 조회 실패:", error);
    return res.status(500).json({ message: "서버 오류가 발생했습니다." });
  }
};

// 2. 챌린지 정보 조회
const getChallengeDetails = async (req, res) => {
  const { challengeId } = req.params;

  try {
    const challenge = await Challenge.findOne({
      where: { id: challengeId },
      attributes: ["period", "description", "reward_name", "reward_image_url"],
      include: [
        {
          model: ChallengeParticipation,
          attributes: [], // 실제로 필요한 것은 참여자 수이므로
          where: { status: "참여중" }, // 현재 참여중인 유저만 카운트
          required: false, // 이 조건이 없어도 챌린지를 찾을 수 있게 설정
        },
      ],
      group: ["Challenge.id"],
    });

    if (!challenge) {
      return res.status(404).json({ message: "챌린지를 찾을 수 없습니다." });
    }

    // 참여자 수를 구하기 위해 ChallengeParticipation 테이블에서 COUNT 사용
    const participantCount = await ChallengeParticipation.count({
      where: { challenge_id: challengeId, status: "참여중" },
    });

    // 챌린지 정보와 참여자 수를 함께 반환
    res.json({
      ...challenge.toJSON(),
      participantCount,
    });
  } catch (error) {
    console.error("Error fetching challenge details:", error);
    res.status(500).json({ message: "서버 오류가 발생했습니다." });
  }
};

// 2-1. 챌린지 이미지 조회 API
const getChallengeImages = async (req, res) => {
  const { challengeId } = req.params;
  const { page = 1, limit = 20 } = req.query;

  try {
    const images = await ChallengeImage.findAndCountAll({
      where: { challenge_id: challengeId },
      attributes: ["id", "image_url", "user_id"], // id와 user_id 추가
      order: [["createdAt", "DESC"]],
      limit: parseInt(limit),
      offset: (page - 1) * limit
    });

    res.json({
      images: images.rows.map(img => ({
        id: img.id,
        imageUrl: img.image_url,
        userId: img.user_id
      })),
      total: images.count,
      currentPage: parseInt(page),
      totalPages: Math.ceil(images.count / limit)
    });
  } catch (error) {
    console.error("Error fetching challenge images:", error);
    res.status(500).json({ message: "서버 오류가 발생했습니다." });
  }
};

// 3. 챌린지 참여
const participateInChallenge = async (req, res) => {
  try {
    const userId = req.user.id;
    const challengeId = req.params.challengeId;

    // 현재 진행중인 동일한 챌린지 참여 여부 확인
    const existingParticipation = await ChallengeParticipation.findOne({
      where: {
        user_id: userId,
        challenge_id: challengeId,
        status: "참여중",
        end_date: {
          [Op.gte]: new Date() // 현재 날짜보다 종료일이 더 큰 경우
        }
      }
    });

    if (existingParticipation) {
      return res.status(400).json({
        message: "이미 참여 중인 챌린지입니다.",
        endDate: existingParticipation.end_date
      });
    }

    // 최근 신고 대상 여부 확인 (3일 이내)
    const recentParticipation = await ChallengeParticipation.findOne({
      where: {
        user_id: userId,
        status: "신고 대상",
        end_date: {
          [Op.gte]: new Date(Date.now() - 3 * 24 * 60 * 60 * 1000) // 3일 이내
        }
      }
    });

    if (recentParticipation) {
      const restrictionEndDate = new Date(recentParticipation.end_date.getTime() + 3 * 24 * 60 * 60 * 1000);
      return res.status(403).json({
        message: "신고로 인해 챌린지 참여가 제한되었습니다.",
        restrictionEndDate: restrictionEndDate
      });
    }

    // 디버깅: challengeId와 userId 출력
    console.log("User ID:", userId);
    console.log("Challenge ID:", challengeId);

    const challenge = await Challenge.findOne({ where: { id: challengeId } });
    if (!challenge) {
      return res.status(404).json({ error: "챌린지를 찾을 수 없습니다." });
    }

    const startDate = new Date();
    const endDate = new Date(startDate);
    endDate.setDate(startDate.getDate() + challenge.period);

    const participation = await ChallengeParticipation.create({
      user_id: userId,
      challenge_id: challengeId,
      status: "참여중",
      start_date: startDate,
      end_date: endDate,
    });

    return res.status(201).json({
      message: "참여가 완료되었습니다.",
      participation,
    });
  } catch (error) {
    console.error("Error in participateInChallenge:", error);
    return res.status(500).json({ error: "서버 오류가 발생했습니다." });
  }
};




// 4. 챌린지 참여 사진 업로드
const uploadChallengeImage = async (req, res) => {
  try {
    const userId = req.user.id;
    const challengeId = req.params.challengeId;

    // 참여 상태 확인
    const participation = await ChallengeParticipation.findOne({
      where: {
        user_id: userId,
        challenge_id: challengeId,
        status: "참여중"
      },
      include: [{
        model: Challenge,
        attributes: ['period', 'name']
      }]
    });

    if (!participation) {
      return res.status(403).json({
        message: "챌린지에 참여 중이 아닙니다."
      });
    }

    // 오늘 날짜의 시작과 끝 설정
    const today = new Date();
    today.setHours(0, 0, 0, 0);
    const tomorrow = new Date(today);
    tomorrow.setDate(tomorrow.getDate() + 1);

    // 오늘 해당 챌린지에 대한 인증 여부 확인
    const todayUpload = await ChallengeImage.findOne({
      where: {
        user_id: userId,
        challenge_id: challengeId,
        createdAt: {
          [Op.gte]: today,
          [Op.lt]: tomorrow
        }
      }
    });

    if (todayUpload) {
      return res.status(400).json({
        message: "오늘은 이미 이 챌린지의 인증 사진을 업로드했습니다. 내일 다시 시도해주세요."
      });
    }

    const files = await uploadPhotos(req, res, 1);
    await saveFilesToDB(files, userId, "ChallengeImage", challengeId);

    // 오늘이 end_date인지 확인
    const endDate = new Date(participation.end_date);
    endDate.setHours(0, 0, 0, 0);
    const isLastDay = today.getTime() === endDate.getTime();

    // 마지막 날이고 신고 없는 경우 바로 상태 변경 및 보상 지급
    if (isLastDay && participation.challenge_reported_count === 0) {
      participation.status = "챌린지 달성";
      await participation.save();

      // 보상 지급
      const dailyCredit = 10;
      await Reward.create({
        user_id: userId,
        challenge_id: challengeId,
        credit: dailyCredit
      });

      return res.status(200).json({
        message: "챌린지가 성공적으로 달성되었습니다! 보상이 지급되었습니다.",
        status: "챌린지 달성",
        credit: dailyCredit
      });
    }

    return res.status(200).json({
      message: "챌린지 인증 이미지가 업로드되었습니다."
    });

  } catch (error) {
    return res.status(500).json({ 
      error: "이미지 업로드 중 오류가 발생했습니다.",
      details: error.message 
    });
  }
};

const getTopUsersByChallenge = async (req, res) => {
  try {
    const topUsers = await Challenge.findAll({
      attributes: ['id', 'name'],
      include: [{
        model: Reward,
        include: [{
          model: User,
          attributes: ['nickname', 'profile_picture']
        }]
      }]
    });

    const formattedResults = topUsers.map(challenge => {
      const top5Users = challenge.Rewards
        .sort((a, b) => b.credit - a.credit)
        .slice(0, 5)
        .map(reward => ({
          nickname: reward.User.nickname,
          profilePicture: reward.User.profile_picture,
          credit: reward.credit
        }));

      return {
        challengeId: challenge.id,
        challengeName: challenge.name,
        topUsers: top5Users
      };
    });

    res.status(200).json(formattedResults);
  } catch (error) {
    console.error("챌린지별 상위 크레딧 보유자 조회 실패:", error);
    res.status(500).json({ message: "서버 오류가 발생했습니다." });
  }
};

module.exports = {
  getChallengeList,
  getChallengeDetails,
  participateInChallenge,
  uploadChallengeImage,
  getTopUsersByChallenge,
  getChallengeImages
};
