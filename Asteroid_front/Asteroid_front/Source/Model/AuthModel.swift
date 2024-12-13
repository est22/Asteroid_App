//
//  AuthModel.swift
//  Asteroid_front
//
//  Created by Lia An on 12/3/24.
//

struct LoginRequest: Codable {
    let email: String
    let password: String
}

struct LoginResponse: Codable {
    let accessToken: String
    let refreshToken: String
    let isProfileSet: Bool
}

struct ErrorResponse: Codable {
    let message: String
}

struct RegisterRequest: Codable {
    let email: String
    let password: String
}

struct RegisterResponse: Codable {
    let data: User
}

struct User: Codable {
    let id: Int
    let email: String
    let nickname: String?
    let motto: String?
   let profilePhoto: String?
}
