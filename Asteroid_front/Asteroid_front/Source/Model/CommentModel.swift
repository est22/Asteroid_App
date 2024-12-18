import Foundation

struct ResponseWrapper<T: Decodable>: Decodable {
    let data: T
}

struct CommentRoot: Codable{
    let data: [Comment]
    let success: Bool?
    let message: String?
}

struct Comment: Identifiable, Codable {
    let id: Int
    let content: String
    let userId: Int
    let postId: Int
    let parentCommentId: Int?
    let isShow: Bool?
    let likeTotal: Int?
    let createdAt: String
    let updatedAt: String
    let replies: [Comment]?
    let user: UserProfile?

    enum CodingKeys: String, CodingKey {
        case id, content, isShow, likeTotal, createdAt, updatedAt
        case userId = "user_id"
        case postId = "post_id"
        case parentCommentId = "parent_comment_id"
        case replies = "Comments"
        case user = "User"
    }
}
