//
//  AppleAuthViewModel.swift
//  Asteroid_front
//
//  Created by Lia An on 12/5/24.
//

import Foundation
import AuthenticationServices
import Alamofire

class AppleAuthViewModel: NSObject, ObservableObject {
    @Published var appleSignInError: String?
    private let baseURL = "http://localhost:3000/auth"
    var onLoginSuccess: ((Bool) -> Void)?
    
    func handleSignInWithApple() {
        let provider = ASAuthorizationAppleIDProvider()
        let request = provider.createRequest()
        request.requestedScopes = [.fullName, .email]
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.performRequests()
    }
    
    private func signInWithApple(userId: String, email: String?) {
        let parameters: [String: Any] = [
            "apple_id": userId,
            "email": email as Any
        ]
        
        AF.request("\(baseURL)/apple-login",
                  method: .post,
                  parameters: parameters,
                  encoding: JSONEncoding.default)
        .responseDecodable(of: LoginResponse.self) { [weak self] response in
            switch response.result {
            case .success(let loginResponse):
                UserDefaults.standard.set(loginResponse.accessToken, forKey: "accessToken")
                UserDefaults.standard.set(loginResponse.refreshToken, forKey: "refreshToken")
                UserDefaults.standard.set(loginResponse.isProfileSet, forKey: "isInitialProfileSet")
                
                DispatchQueue.main.async {
                    self?.onLoginSuccess?(loginResponse.isProfileSet)
                }
                
            case .failure(let error):
                print("Apple Sign In Error: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    self?.appleSignInError = "Apple 로그인에 실패했습니다."
                }
            }
        }
    }
}

extension AppleAuthViewModel: ASAuthorizationControllerDelegate {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            let userId = appleIDCredential.user
            let email = appleIDCredential.email
            
            print("Apple User ID: \(userId)")
            print("Apple User Email: \(email ?? "No email")")
            
            signInWithApple(userId: userId, email: email)
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print("Apple Sign In Error: \(error.localizedDescription)")
        self.appleSignInError = "Apple 로그인에 실패했습니다."
    }
}