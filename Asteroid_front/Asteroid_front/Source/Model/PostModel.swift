import Foundation

struct PostRoot: Codable{
    let data: PostList
    let message: String?
}

struct PostList: Codable {
    var count: Int
    var rows: [Post]
}

struct PostDetail: Codable {
    let data: Post
    let commentCount: Int
}

struct Post: Identifiable, Codable, Equatable {
    let id: Int
    let title: String
    let content: String
    let categoryID: Int
    let userID: Int
    let isShow: Bool
    let likeTotal: Int
    let PostImages: [PostImage]?
    let createdAt: String
    let updatedAt: String
    var commentCount:Int?
    let user: PostUser?
    
    enum CodingKeys: String, CodingKey {
        case id, title, content, PostImages, createdAt, updatedAt, isShow, likeTotal, commentCount
        case categoryID = "category_id"
        case userID = "user_id"
        case user = "User"
    }
}

struct PostUser: Codable, Equatable {
    let nickname: String
    let profilePicture: String?
    
    enum CodingKeys: String, CodingKey {
        case nickname
        case profilePicture = "profile_picture"
    }
}

struct PostImage: Codable, Identifiable, Equatable {
    let id: Int?
    let imageURL: String?
    let postID: Int?
    
    enum CodingKeys: String, CodingKey {
        case id
        case imageURL = "image_url"
        case postID = "post_id"
    }
}

struct PostRanking: Codable, Identifiable {
  let id: Int
  let title: String
  let likeTotal: Int
  let createdAt: String
}

struct Like: Decodable {
    var id: Int
    var userId: Int
    var targetId: Int
    var targetType: String
}

