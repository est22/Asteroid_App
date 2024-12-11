import Foundation

struct BalanceVote: Codable, Identifiable, Equatable {
    let id: Int
    let title: String
    let description: String
    let image1: String
    let image2: String
    let vote1Count: Int
    let vote2Count: Int
    let isShow: Bool
    let createdAt: String
    let updatedAt: String
    let user:User?
    
    enum CodingKeys: String, CodingKey {
        case id, title, description, image1, image2, createdAt, updatedAt, user
        case vote1Count = "vote1_count"
        case vote2Count = "vote2_count"
        case isShow = "isShow"
    }
}

struct BalanceVoteRoot: Codable {
    let data: [BalanceVote]
    let success: Bool
    let message: String
}
