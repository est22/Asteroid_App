const schedule = require("node-schedule");
const {
  ChallengeParticipation,
  Challenge,
  ChallengeImage,
  Reward,
  User,
} = require("../models");
const { Op } = require("sequelize");
// const { sendPushNotification } = require('./pushNotificationService');

// 일일 업로드 체크
const checkDailyUpload = async (userId, challengeId) => {
  try {
    const participation = await ChallengeParticipation.findOne({
      where: {
        user_id: userId,
        challenge_id: challengeId,
        status: "참여중",
      },
      include: [
        {
          model: Challenge,
          attributes: ["period"],
        },
      ],
    });

    if (!participation) return false;

    // 오늘 업로드한 이미지 수 확인
    const today = new Date();
    today.setHours(0, 0, 0, 0);

    const uploadCount = await ChallengeImage.count({
      where: {
        user_id: userId,
        challenge_id: challengeId,
        createdAt: {
          [Op.gte]: today,
        },
      },
    });

    // 신고 횟수 체크 추가
    if (participation.challenge_reported_count > 0) {
      return false;
    }

    // period 일수만큼 연속으로 업로드했는지 확인
    if (uploadCount >= participation.Challenge.period) {
      // 챌린지 달성 처리
      participation.status = "챌린지 달성";
      await participation.save();

      // Reward 찾거나 생성 - credit 누적
      const [reward, created] = await Reward.findOrCreate({
        where: {
          user_id: userId,
          challenge_id: challengeId,
        },
        defaults: {
          credit: participation.Challenge.period * 10,
        },
      });

      if (!created) {
        await reward.increment("credit", {
          by: participation.Challenge.period * 10,
        });
      }

      return true;
    }

    return false;
  } catch (error) {
    console.error("챌린지 달성 체크 에러:", error);
    throw error;
  }
};

// 단순히 오늘 업로드 여부만 확인하는 새로운 함수
const checkTodayUpload = async (userId, challengeId) => {
  try {
    console.log("\n=== checkTodayUpload 서비스 시작 ===");
    console.log("userId:", userId);
    console.log("challengeId:", challengeId);

    const today = new Date();
    today.setHours(0, 0, 0, 0);
    console.log("today:", today);

    const uploadCount = await ChallengeImage.count({
      where: {
        user_id: userId,
        challenge_id: challengeId,
        createdAt: {
          [Op.gte]: today,
        },
      },
    });

    console.log("uploadCount:", uploadCount);
    return uploadCount > 0;
  } catch (error) {
    console.error("오늘 업로드 확인 에러:", error);
    throw error;
  }
};

// 신고 처리 함수
const handleReportedUser = async (userId, challengeId, reportType) => {
  try {
    const participation = await ChallengeParticipation.findOne({
      where: {
        user_id: userId,
        challenge_id: challengeId,
        status: "참여중",
      },
    });

    if (participation) {
      if (reportType === "severe") {
        // 심각한 위반
        participation.status = "신고 대상";

        // 참여 제한 기간 설정 (3일)
        const restrictionEndDate = new Date();
        restrictionEndDate.setDate(restrictionEndDate.getDate() + 3);

        // User 모델에 참여 제한 정보 저장
        await User.update(
          {
            challenge_restriction_until: restrictionEndDate,
          },
          {
            where: { id: userId },
          }
        );
      } else {
        participation.challenge_reported_count += 1;
      }
      await participation.save();
    }
  } catch (error) {
    console.error("신고 처리 실패:", error);
    throw error;
  }
};

// 챌린지 완료 체크 및 보상 지급
const checkChallengeCompletion = async (challenge) => {
  try {
    // challenge 객체가 존재하는지 먼저 확인
    if (!challenge) {
      console.log("Challenge object is undefined");
      return;
    }

    // user_id가 존재하는지 확인
    if (!challenge.user_id) {
      console.log("User ID is missing from challenge:", challenge);
      return;
    }

    // 나머지 로직
    const result = await Challenge.findOne({
      where: {
        user_id: challenge.user_id,
        // 다른 조건들...
      },
    });

    // 결과 처리
    if (result) {
      // 로직 처리
    }

    // challenge 객체가 존재하는지 먼저 확인
    if (!challenge) {
      console.log("Challenge object is undefined");
      return;
    }

    // user_id가 존재하는지 확인
    if (!challenge.user_id) {
      console.log("User ID is missing from challenge:", challenge);
      return;
    }

   

    // 결과 처리
    if (result) {
      // 로직 처리
    }
  } catch (error) {
    console.error("챌린지 상태 체크 중 에러 발생:", error);
    throw error;
  }
};

// 챌린지 종료 시 보상 지급 함수 추가
const giveRewardForCompletion = async (participation) => {
  try {
    // 신고 횟수 체크
    if (participation.challenge_reported_count > 0) {
      console.log(
        `사용자 ${participation.user_id}의 챌린지가 신고되어 보상이 지급되지 않습니다.`
      );
      return false;
    }

    // 챌여 기간 동안의 이미지 업로드 수 확인
    const imageCount = await ChallengeImage.count({
      where: {
        user_id: participation.user_id,
        challenge_id: participation.challenge_id,
        createdAt: {
          [Op.between]: [participation.start_date, participation.end_date],
        },
      },
    });

    // 수료 보상 지급
    if (participation.status === "챌린지 수료") {
      const [reward, created] = await Reward.findOrCreate({
        where: {
          user_id: participation.user_id,
          challenge_id: participation.challenge_id,
        },
        defaults: {
          credit: imageCount * 10,
        },
      });

      if (!created) {
        await reward.increment("credit", {
          by: imageCount * 10,
        });
      }

      return true;
    }
    return false;
  } catch (error) {
    console.error("수료 보상 지급 중 오류:", error);
    throw error;
  }
};

// 스케줄러 설정 (매일 자정에 실행)
const scheduleChallengeCheck = () => {
  schedule.scheduleJob("0 0 * * *", async () => {
    try {
      await checkChallengeCompletion();
      console.log("챌린지 상태 체크 완료");
    } catch (error) {
      console.error("챌린지 상태 체크 실패:", error);
    }
  });
};

const updateChallengeStatusAndReward = async () => {
  try {
    const now = new Date();

    // 참여 중인 챌린지 중 기간이 끝난 것들 찾기
    const participations = await ChallengeParticipation.findAll({
      where: {
        status: "참여중",
        end_date: {
          [Op.lte]: now,
        },
      },
      include: [
        {
          model: Challenge,
          attributes: ["period"],
        },
      ],
    });

    for (const participation of participations) {
      // 챌린지 달성 여부 확인
      const isAchieved = participation.challenge_reported_count === 0;

      // 상태 업데이트
      participation.status = isAchieved ? "챌린지 달성" : "실패";
      await participation.save();

      // 보상 지급
      if (isAchieved) {
        const totalCredit = participation.Challenge.period * 10; // 예: 하루 10 크레딧
        await Reward.create({
          user_id: participation.user_id,
          challenge_id: participation.challenge_id,
          credit: totalCredit,
        });
      }
    }
  } catch (error) {
    console.error("챌린지 상태 업데이트 및 보상 지급 에러:", error);
  }
};

module.exports = {
  checkDailyUpload,
  checkTodayUpload,
  checkChallengeCompletion,
  scheduleChallengeCheck,
  giveRewardForCompletion,
  updateChallengeStatusAndReward,
};
