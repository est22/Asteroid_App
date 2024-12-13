const { ChallengeImage } = require('../models');

async function cleanTestImages(challengeId) {
    try {
        // 특정 챌린지의 모든 이미지 삭제
        const deleted = await ChallengeImage.destroy({
            where: {
                challenge_id: challengeId
            }
        });
        
        console.log(`${deleted}개의 테스트 이미지가 삭제되었습니다.`);
    } catch (error) {
        console.error('테스트 데이터 삭제 실패:', error);
    }
}

// 실행
const challengeId = 1; // 테스트 데이터를 생성했던 챌린지 ID
cleanTestImages(challengeId); 

// cleanTestImages(11);  // 챌린지 ID 11의 데이터 삭제