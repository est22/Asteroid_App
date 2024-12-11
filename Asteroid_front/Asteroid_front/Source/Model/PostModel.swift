import Foundation

struct Post: Codable, Identifiable {
    let id: Int
    let title: String
    let content: String
    let categoryID: Int
    let userID: Int
    let isShow: Bool
    let likeTotal: Int
    let images: [PostImage]?
    let commentTotal:Int?
    let createdAt: String
    let updatedAt: String
    let user:User?
    
    enum CodingKeys: String, CodingKey {
        case id, title, content, images, createdAt, updatedAt, user
        case categoryID = "category_id"
        case userID = "user_id"
        case isShow = "isShow"
        case likeTotal = "likeTotal"
        case commentTotal = "commentTotal"
    }
}

struct PostImage: Codable, Identifiable, Equatable {
    let id: Int
    let imageURL: String
    let postID: Int
}

struct PostRoot: Codable{
    let data: [Post]
    let success: Bool
    let message: String
}
