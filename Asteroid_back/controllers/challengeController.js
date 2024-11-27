const { Challenge, ChallengeParticipation, ChallengeImage, User } = require("../models");
const { uploadPhotos, saveFilesToDB } = require("../services/fileUploadService.js");

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
  const { challengeId } = req.params;  // URL 파라미터에서 challengeId를 가져옴

  try {
    const userId = req.user.id; // 미들웨어에서 가져온 userId

    // 디버깅: challengeId와 userId 출력
    console.log("User ID:", userId);
    console.log("Challenge ID:", challengeId);

    const challenge = await Challenge.findOne({ where: { id: challengeId } });
    if (!challenge) {
      console.log("Challenge not found!");
      return res.status(404).json({ error: "챌린지를 찾을 수 없습니다." });
    }

    const startDate = new Date();
    const endDate = new Date(startDate);
    endDate.setDate(startDate.getDate() + challenge.period);

    const participation = await ChallengeParticipation.create({
      user_id: userId, // 자동으로 가져온 userId 사용
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
    console.error("Error in participateInChallenge:", error); // 오류를 더 명확하게 출력
    return res.status(500).json({ error: "서버 오류가 발생했습니다." });
  }
};




// 4. 챌린지 참여 사진 업로드
const uploadChallengeImage = async (req, res) => {
  try {
    // 디버깅을 위한 로그 추가
    // console.log('Request files:', req.file);
    // console.log('Challenge ID:', req.params.challengeId);
    
    if (!req.file) {
      return res.status(400).json({ error: "파일이 업로드되지 않았습니다." });
    }

    const userId = req.user.id;
    const challengeId = req.params.challengeId;

    const result = await saveFilesToDB(
      [req.file],
      userId,
      "ChallengeImage",
      challengeId
    );

    return res.status(200).json({
      message: "챌린지 인증 이미지가 성공적으로 업로드되었습니다.",
      // data: result,
    });
  } catch (error) {
    // 더 자세한 에러 로깅
    console.error('이미지 업로드 에러 상세:', {
      error: error.message,
      stack: error.stack
    });
    return res.status(500).json({ 
      error: "이미지 업로드 중 오류가 발생했습니다.",
      details: error.message 
    });
  }
};


module.exports = {
  getChallengeList,
  getChallengeDetails,
  participateInChallenge,
  uploadChallengeImage,
};
