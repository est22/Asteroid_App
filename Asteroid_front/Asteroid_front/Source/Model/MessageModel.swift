import Foundation

struct Message: Identifiable, Codable {
    let id: Int
    let content: String
    let senderUserId: Int
    let receiverUserId: Int
    let isRead: Bool
    let createdAt: Date
    let updatedAt: Date
}

struct MessageRoom: Identifiable, Codable {
    let id: Int
    let user1Id: Int
    let user2Id: Int
    let user1LeftAt: Date?
    let user2LeftAt: Date?
    let createdAt: Date
    let updatedAt: Date
}


struct MessageRoot: Codable {
    let data:[Message]
    let message:String
    let error:String
}
