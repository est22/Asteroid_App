import Foundation

// 대화상대목록 모델
struct MessageRoomRoot: Codable {
    let data:[MessageRoom]
    let error:String?
}

struct MessageRoom: Codable, Identifiable {
    var id: Int? { chatUser.id }
    let chatUser: MessageUser
    let latestMessage: String
    let latestTime: String
    let unRead: String
  
    enum CodingKeys: String, CodingKey {
        case chatUser = "chat_user"
        case latestMessage = "latest_message"
        case latestTime = "latest_message_time"
        case unRead = "unread_count"
    }
}

// 쪽지내용 모델
struct MessageRoot: Codable {
    let data:[Message]
    let message:String?
    let error:String?
}

struct Message: Codable {
    let id: Int
    let content: String
    let senderUserId: Int
    let receiverUserId: Int
    let isRead: Bool
    let createdAt: String
    let updatedAt: String
    let receiver:UserProfile
  
    enum CodingKeys: String, CodingKey {
        case id, content, createdAt, updatedAt
        case senderUserId = "sender_user_id"
        case receiverUserId = "receiver_user_id"
        case isRead = "is_read"
        case receiver = "Receiver"
    }
}
