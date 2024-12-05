import Foundation
import SwiftUI
import Combine
import KakaoSDKUser
import KakaoSDKAuth

class KakaoAuthViewModel: ObservableObject {
    @Published var kakaoSignInError: String?
    var onLoginSuccess: ((Bool) -> Void)?
    private let baseURL = "http://localhost:3000/auth"
    
    func handleSignInWithKakao() {
        if UserApi.isKakaoTalkLoginAvailable() {
            UserApi.shared.loginWithKakaoTalk { [weak self] (oauthToken, error) in
                if let error = error {
                    print("Kakao Sign In Error: \(error.localizedDescription)")
                    return
                }
                self?.handleKakaoLogin(accessToken: oauthToken?.accessToken)
            }
        } else {
            UserApi.shared.loginWithKakaoAccount { [weak self] (oauthToken, error) in
                if let error = error {
                    print("Kakao Sign In Error: \(error.localizedDescription)")
                    return
                }
                self?.handleKakaoLogin(accessToken: oauthToken?.accessToken)
            }
        }
    }
    
    private func handleKakaoLogin(accessToken: String?) {
        // 서버에 카카오 토큰을 전송하여 로그인/회원가입 처리
    }
}