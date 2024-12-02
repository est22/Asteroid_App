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


// 3. 챌린지 참여
const participateInChallenge = async (req, res) => {
  try {
    const userId = req.user.id;
    const challengeId = req.params.challengeId;

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
        attributes: ['period']
      }]
    });

    if (!participation) {
      return res.status(403).json({
        message: "챌린지에 참여 중이 아닙니다."
      });
    }

    const files = await uploadPhotos(req, res, 1);
    await saveFilesToDB(files, userId, "ChallengeImage", challengeId);

    // 신고 횟수 체크
    if (participation.challenge_reported_count > 0) {
      return res.status(403).json({
        message: "신고된 챌린지는 보상을 받을 수 없습니다."
      });
    }

    // 보상 지급 로직
    const [reward, created] = await Reward.findOrCreate({
      where: {
        user_id: userId,
        challenge_id: challengeId
      },
      defaults: {
        credit: participation.Challenge.period * 10
      }
    });

    if (!created) {
      await reward.increment('credit', {
        by: participation.Challenge.period * 10
      });
    }

    participation.status = "챌린지 달성";
    await participation.save();

    return res.status(200).json({
      message: "챌린지 인증 이미지가 업로드되었고, 보상이 지급되었습니다."
    });
  } catch (error) {
    return res.status(500).json({ 
      error: "이미지 업로드 중 오류가 발생했습니다.",
      details: error.message 
    });
  }
};

const getMyOngoingChallenges = async (req, res) => {
  try {
    console.log("=== getMyOngoingChallenges 함수 시작 ===");
    
    // req.user 확인
    console.log("req.user:", req.user);
    if (!req.user) {
      console.log("사용자 인증 실패: req.user가 없음");
      return res.status(401).json({ message: "인증되지 않은 사용자입니다." });
    }

    const userId = req.user.id;
    console.log("Requesting user ID:", userId);

    // 쿼리 조건 로깅
    const queryCondition = {
      where: {
        user_id: userId,
        status: "참여중"
      },
      include: [{
        model: Challenge,
        attributes: [
          'id',
          'name', 
          'period', 
          'description',
          'reward_name',
          'reward_image_url'
        ]
      }],
      attributes: [
        'challenge_id',
        'start_date',
        'end_date',
        'challenge_reported_count'
      ]
    };
    console.log("Query condition:", JSON.stringify(queryCondition, null, 2));

    const ongoingChallenges = await ChallengeParticipation.findAll(queryCondition);
    console.log("Raw ongoing challenges:", JSON.stringify(ongoingChallenges, null, 2));

    if (!ongoingChallenges) {
      console.log("조회 결과 없음: ongoingChallenges is null");
      return res.status(200).json({
        message: "참여중인 챌린지가 없습니다.",
        challenges: []
      });
    }

    console.log("Found challenges count:", ongoingChallenges.length);

    const formattedChallenges = ongoingChallenges.map(participation => {
      console.log("Processing participation:", participation.toJSON());
      return {
        challengeId: participation.Challenge?.id,
        challengeName: participation.Challenge?.name,
        period: participation.Challenge?.period,
        description: participation.Challenge?.description,
        rewardName: participation.Challenge?.reward_name,
        rewardImageUrl: participation.Challenge?.reward_image_url,
        startDate: participation.start_date,
        endDate: participation.end_date,
        reportCount: participation.challenge_reported_count
      };
    });

    console.log("Formatted challenges:", JSON.stringify(formattedChallenges, null, 2));

    if (formattedChallenges.length === 0) {
      console.log("포맷팅 후 결과 없음");
      return res.status(200).json({
        message: "참여중인 챌린지가 없습니다.",
        challenges: []
      });
    }

    console.log("=== getMyOngoingChallenges 함수 정상 종료 ===");
    return res.status(200).json(formattedChallenges);

  } catch (error) {
    console.error("=== getMyOngoingChallenges 에러 발생 ===");
    console.error("Error details:", error);
    console.error("Error stack:", error.stack);
    return res.status(500).json({ message: "서버 오류가 발생했습니다." });
  }
};

module.exports = {
  getChallengeList,
  getChallengeDetails,
  participateInChallenge,
  uploadChallengeImage,
  getMyOngoingChallenges,
};
