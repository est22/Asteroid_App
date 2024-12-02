const schedule = require('node-schedule');
const { ChallengeParticipation, Challenge, ChallengeImage, Reward, User } = require('../models');
const { Op } = require('sequelize');
// const { sendPushNotification } = require('./pushNotificationService');

// 일일 업로드 체크
const checkDailyUpload = async (userId, challengeId) => {
  try {
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

    if (!participation) return false;

    // 오늘 업로드한 이미지 수 확인
    const today = new Date();
    today.setHours(0, 0, 0, 0);
    
    const uploadCount = await ChallengeImage.count({
      where: {
        user_id: userId,
        challenge_id: challengeId,
        createdAt: {
          [Op.gte]: today
        }
      }
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

      return true;
    }

    return false;
  } catch (error) {
    console.error('챌린지 달성 체크 에러:', error);
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
        status: "참여중"
      }
    });

    if (participation) {
      if (reportType === "severe") {  // 심각한 위반
        participation.status = "신고 대상";
        
        // 참여 제한 기간 설정 (3일)
        const restrictionEndDate = new Date();
        restrictionEndDate.setDate(restrictionEndDate.getDate() + 3);
        
        // User 모델에 참여 제한 정보 저장
        await User.update(
          {
            challenge_restriction_until: restrictionEndDate
          },
          {
            where: { id: userId }
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
const checkChallengeCompletion = async () => {
  const today = new Date();
  
  // 종료 예정인 참여 찾기
  const endingParticipations = await ChallengeParticipation.findAll({
    where: {
      end_date: {
        [Op.lt]: today
      },
      status: "참여중"
    },
    include: [
      {
        model: Challenge,
        attributes: ['period', 'reward_name', 'name', 'reward_image_url']
      }
    ]
  });

  for (const participation of endingParticipations) {
    // 참여 기간 동안의 이미지 업로드 수 확인
    const imageCount = await ChallengeImage.count({
      where: {
        user_id: participation.user_id,
        challenge_id: participation.challenge_id,
        createdAt: {
          [Op.between]: [participation.start_date, participation.end_date]
        }
      }
    });

    // 성공 조건: 기간만큼 이미지를 업로드했고 신고가 없음
    if (imageCount === participation.Challenge.period && participation.challenge_reported_count === 0) {
      // 챌린지 달성 처리
      participation.status = "챌린지 달성";
      
      // Reward 테이블 업데이트
      const [reward, created] = await Reward.findOrCreate({
        where: {
          user_id: participation.user_id,
          challenge_id: participation.challenge_id
        },
        defaults: {
          reward_count: 1,
        //   credit: 100 // 기본 포인트 지급
        }
      });

      if (!created) {
        reward.reward_count += 1;
        // reward.credit += 100; // 추가 포인트 지급
        await reward.save();
      }

      // 푸시 알림 발송
      if (participation.User.device_token) {
        await sendPushNotification({
          deviceToken: participation.User.device_token,
          title: "챌린지 달성을 축하합니다! 🎉",
          body: `${participation.Challenge.name} 챌린지를 성공적으로 완료했습니다!`,
          data: {
            type: "challenge_complete",
            challengeId: participation.challenge_id,
            rewardName: participation.Challenge.reward_name
          }
        });
      }
    } else {
      // 실패 처리
      participation.status = "챌린지 수료";
      
      // 실패 알림 발송
      if (participation.User.device_token) {
        await sendPushNotification({
          deviceToken: participation.User.device_token,
          title: "챌린지가 종료되었습니다",
          body: `${participation.Challenge.name} 챌린지가 종료되었습니다.`,
          data: {
            type: "challenge_end",
            challengeId: participation.challenge_id
          }
        });
      }
    }
    
    await participation.save();
  }
};

// 챌린지 종료 시 보상 지급 함수 추가
const giveRewardForCompletion = async (participation) => {
  try {
    // 신고 횟수 체크
    if (participation.challenge_reported_count > 0) {
      console.log(`사용자 ${participation.user_id}의 챌린지가 신고되어 보상이 지급되지 않습니다.`);
      return false;
    }

    // 챌여 기간 동안의 이미지 업로드 수 확인
    const imageCount = await ChallengeImage.count({
      where: {
        user_id: participation.user_id,
        challenge_id: participation.challenge_id,
        createdAt: {
          [Op.between]: [participation.start_date, participation.end_date]
        }
      }
    });

    // 수료 보상 지급
    if (participation.status === "챌린지 수료") {
      const [reward, created] = await Reward.findOrCreate({
        where: {
          user_id: participation.user_id,
          challenge_id: participation.challenge_id
        },
        defaults: {
          credit: imageCount * 10
        }
      });

      if (!created) {
        await reward.increment('credit', {
          by: imageCount * 10
        });
      }

      return true;
    }
    return false;
  } catch (error) {
    console.error('수료 보상 지급 중 오류:', error);
    throw error;
  }
};

// 스케줄러 설정 (매일 자정에 실행)
const scheduleChallengeCheck = () => {
  schedule.scheduleJob('0 0 * * *', async () => {
    try {
      await checkChallengeCompletion();
      console.log('챌린지 상태 체크 완료');
    } catch (error) {
      console.error('챌린지 상태 체크 실패:', error);
    }
  });
};

module.exports = {
  checkDailyUpload,
  checkChallengeCompletion,
  scheduleChallengeCheck,
  giveRewardForCompletion,
}; 