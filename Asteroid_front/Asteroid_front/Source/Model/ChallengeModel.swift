import Foundation

struct ChallengeRanking: Codable {
    let challengeId: Int
    let challengeName: String
    let topUsers: [UserRanking]
}

struct UserRanking: Codable {
    let nickname: String
    let profilePicture: String?
    let credit: Int
}

struct ChallengeRankingResponse: Codable {
    let status: String
    let data: [ChallengeRanking]
} 

struct ChallengeInfo: Identifiable, Codable {
    private let _id: Int?
    private let _challengeId: Int?
    let name: String?
    let challengeName: String?
    let period: Int?
    let description: String?
    let rewardName: String?
    let rewardImageUrl: String?
    let participantCount: Int?
    
    var id: Int {
        _id ?? _challengeId ?? 0
    }
    
    var displayName: String {
        name ?? challengeName ?? ""
    }
    
    enum CodingKeys: String, CodingKey {
        case _id = "id"
        case _challengeId = "challengeId"
        case name, challengeName, period, description
        case rewardName = "reward_name"
        case rewardImageUrl = "reward_image_url"
        case participantCount
    }
}

// API의 챌린지 상세 정보 응답에 맞는 모델
struct ChallengeDetail: Codable {
    let period: Int
    let description: String
    let rewardName: String
    let rewardImageUrl: String
    let participantCount: Int
    
    enum CodingKeys: String, CodingKey {
        case period, description
        case rewardName = "reward_name"
        case rewardImageUrl = "reward_image_url"
        case participantCount
    }
}

// 챌린지별 이미지를 로드하는 모델
struct ChallengeImage: Codable {
    let id: Int
    let imageUrl: String
    let userId: Int
}

struct ChallengeImagesResponse: Codable {
    let images: [ChallengeImage]
    let total: Int
    let currentPage: Int
    let totalPages: Int
}

// 내 보상 페이지에 사용되는 모델
struct CompletedChallenge: Codable {
    let challengeName: String
    let rewardName: String?
    let rewardImageUrl: String?
    let credit: Int?
    let achievedAt: String
    let status: String
}

struct CompletedChallengeResponse: Codable {
    let message: String?
    let data: [CompletedChallenge]?
}