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
    var id: Int { challengeId }
    let challengeId: Int
    let challengeName: String
    let period: Int
    let description: String
    let rewardName: String
    let rewardImageUrl: String
    let startDate: String
    let endDate: String
    let reportCount: Int
}
