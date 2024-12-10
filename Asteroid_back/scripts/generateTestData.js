const { ChallengeImage } = require('../models');

async function generateTestImages(challengeId, count = 30) {
    try {
        const testImages = [];
        
        for (let i = 1; i <= count; i++) {
            testImages.push({
                challenge_id: challengeId,
                user_id: 1,
                image_url: `https://picsum.photos/400/400?random=${i}`,
                createdAt: new Date(Date.now() - (i * 24 * 60 * 60 * 1000))
            });
        }

        await ChallengeImage.bulkCreate(testImages);
        console.log(`챌린지 ID ${challengeId}에 ${count}개의 테스트 이미지가 생성되었습니다.`);
    } catch (error) {
        console.error('테스트 데이터 생성 실패:', error);
    }
}

// 챌린지 ID 11로 실행
generateTestImages(11, 200); 