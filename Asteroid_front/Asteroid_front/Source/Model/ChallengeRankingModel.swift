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
