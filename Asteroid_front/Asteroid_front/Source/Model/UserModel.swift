struct User: Codable, Equatable {
    let id: Int
    let email: String
    let nickname: String?
    let motto: String?
    let profilePhoto: String?
}

struct UserProfile: Codable, Equatable{
  let id: Int?
  let nickname: String
  let profilePhoto: String?
  
  enum CodingKeys: String, CodingKey {
      case id, nickname
      case profilePhoto = "profile_picture"
  }
}

struct MessageUser: Codable {
    let id: Int?
    let nickname: String
    let profilePhoto: String?
  
    enum CodingKeys: String, CodingKey {
        case id, nickname
        case profilePhoto = "profile_picture"
    }
}
