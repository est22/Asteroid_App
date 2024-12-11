import Foundation

struct Comment: Identifiable, Codable {
    let id: Int
    let content: String
    let likeTotal: Int?
    let createdAt: Date
    let replies: [Comment]?
    let isShow: Bool?
    let user:User?
    
    enum CodingKeys: String, CodingKey {
        case id, content, likeTotal, createdAt, replies, isShow, user
    }
}

struct CommentRoot: Codable{
    let data: [Comment]
    let success: Bool
    let message: String
}
