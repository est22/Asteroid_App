import Foundation

struct BalanceVoteRoot: Codable {
    let data: BalanceVoteData
    let message: String?
}

struct BalanceVoteData: Codable {
    var count: Int
    var rows: [BalanceVote]
}

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
    let user:BalanceUser
    
    enum CodingKeys: String, CodingKey {
        case id, title, description, image1, image2, createdAt, updatedAt
        case vote1Count = "vote1_count"
        case vote2Count = "vote2_count"
        case isShow = "isShow"
        case user = "User"
    }
  
    static func == (lhs: BalanceVote, rhs: BalanceVote) -> Bool {
        return lhs.id == rhs.id &&
            lhs.title == rhs.title &&
            lhs.description == rhs.description &&
            lhs.image1 == rhs.image1 &&
            lhs.image2 == rhs.image2 &&
            lhs.vote1Count == rhs.vote1Count &&
            lhs.vote2Count == rhs.vote2Count &&
            lhs.isShow == rhs.isShow &&
            lhs.createdAt == rhs.createdAt &&
            lhs.updatedAt == rhs.updatedAt &&
            lhs.user == rhs.user
      }
}

struct BalanceUser: Codable, Equatable {
  let nickname:String
  let profilePhoto:String
  
  enum CodingKeys: String, CodingKey {
      case nickname
      case profilePhoto = "profile_picture"
  }
}
