import Foundation
import SwiftUI
import Combine
import KakaoSDKUser
import KakaoSDKAuth

class KakaoAuthViewModel: ObservableObject {
//    @Published var kakaoSignInError: String?
//    var onLoginSuccess: ((Bool) -> Void)?
//    private let baseURL = "\(APIConstants.baseURL)/auth"
//    
//    func handleSignInWithKakao() {
//        if UserApi.isKakaoTalkLoginAvailable() {
//            UserApi.shared.loginWithKakaoTalk { [weak self] (oauthToken, error) in
//                if let error = error {
//                    self?.kakaoSignInError = "Kakao Sign In Error: \(error.localizedDescription)"
//                    print(self?.kakaoSignInError ?? "Unknown error")
//                    return
//                }
//                self?.handleKakaoLogin(accessToken: oauthToken?.accessToken)
//            }
//        } else {
//            UserApi.shared.loginWithKakaoAccount { [weak self] (oauthToken, error) in
//                if let error = error {
//                    self?.kakaoSignInError = "Kakao Sign In Error: \(error.localizedDescription)"
//                    print(self?.kakaoSignInError ?? "Unknown error")
//                    return
//                }
//                self?.handleKakaoLogin(accessToken: oauthToken?.accessToken)
//            }
//        }
//    }
    
    fileprivate func fetchUserInfo() {
        UserApi.shared.me { user, error in
            if let error {
                print("fetchUserInfo error")
                print(error.localizedDescription)
            } else {
                if let id = user?.id {
                    print("kakao_user_id: \(id)")
                }
            }
        }
    }
    
    func handleSignInWithKakao(){
    
        if UserApi.isKakaoTalkLoginAvailable() {
            UserApi.shared.loginWithKakaoTalk { token, error in
                if let error {
                    print("handleSignInWithKakao error")
                    print(error.localizedDescription)
                } else {
                    print("loginWithKakaoTalk() success.")
                    print("token:", token!)
                    // 성공 시 동작 구현
                    self.fetchUserInfo()
                    
                }
            }
        } else {
            UserApi.shared.loginWithKakaoAccount { token, error in
                if let error {
                    print(error.localizedDescription)
                } else {
                    print(token!)
                }
            }
        }
    }
}
