struct ProfileResponse: Codable {
    let status: String
    let data: ProfileData
}

struct ProfileData: Codable {
    let nickname: String
    let motto: String
    let profilePhoto: String?
}

struct UpdateProfileResponse: Codable {
    let message: String
}

struct NicknameCheckResponse: Codable {
    let message: String
}

