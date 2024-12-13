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

struct Post: Codable, Identifiable, Equatable {
    let id: Int
    let title: String
    let content: String
    let categoryID: Int
    let userID: Int
    let isShow: Bool
    let likeTotal: Int
    let PostImages: [PostImage]?
    let commentTotal:Int?
    let createdAt: String
    let updatedAt: String
    let user:User?
    
    enum CodingKeys: String, CodingKey {
        case id, title, content, PostImages, createdAt, updatedAt, user
        case categoryID = "category_id"
        case userID = "user_id"
        case isShow = "isShow"
        case likeTotal = "likeTotal"
        case commentTotal = "commentTotal"
    }
}

struct PostImage: Codable, Identifiable, Equatable {
    let id: Int?
    let imageURL: String?
    let postID: Int?
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
