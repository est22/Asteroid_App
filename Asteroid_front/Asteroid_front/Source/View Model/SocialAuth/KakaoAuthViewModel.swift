import Foundation
import SwiftUI
import Combine
import KakaoSDKUser
import KakaoSDKAuth
import Alamofire

class KakaoAuthViewModel: ObservableObject {
    @Published var kakaoSignInError: String?
    private var authViewModel: AuthViewModel
    
    init(authViewModel: AuthViewModel) {
        self.authViewModel = authViewModel
    }
    
    private func signInWithKakao(userId: Int64) {
        let parameters: [String: Any] = [
            "kakao_id": userId
        ]
        
        // print("Sending kakao login request with ID:", userId)  // 디버깅 로그
        
        AF.request("\(APIConstants.baseURL)/auth/kakao-login",
                  method: .post,
                  parameters: parameters,
                  encoding: JSONEncoding.default)
        .responseDecodable(of: LoginResponse.self) { [weak self] response in
            // print("Received response:", response.debugDescription)  // 디버깅 로그
            
            switch response.result {
            case .success(let loginResponse):
                // print("Login success - isProfileSet:", loginResponse.isProfileSet)  // 디버깅 로그
                
                // UserDefaults 저장
                UserDefaults.standard.set(loginResponse.accessToken, forKey: "accessToken")
                UserDefaults.standard.set(loginResponse.refreshToken, forKey: "refreshToken")
                UserDefaults.standard.set(loginResponse.isProfileSet, forKey: "hasCompletedInitialProfile")
                UserDefaults.standard.set(true, forKey: "isLoggedIn")  // 추가
                
                // 메인 스레드에서 상태 업데이트
                DispatchQueue.main.async {
                    self?.authViewModel.isLoggedIn = true
                    self?.authViewModel.isInitialProfileSet = loginResponse.isProfileSet
                    // print("Updated auth state - isLoggedIn: true, isProfileSet:", loginResponse.isProfileSet)
                }
                
            case .failure(let error):
                print("Kakao Sign In Error:", error.localizedDescription)
                DispatchQueue.main.async {
                    self?.kakaoSignInError = "카카오 로그인에 실패했습니다."
                }
            }
        }
    }
    
    func handleSignInWithKakao() {
        if UserApi.isKakaoTalkLoginAvailable() {
            UserApi.shared.loginWithKakaoTalk { [weak self] token, error in
                if let error {
                    print("handleSignInWithKakao error")
                    print(error.localizedDescription)
                } else {
                    print("loginWithKakaoTalk() success.")
                    
                    // 카카오 사용자 정보 가져오기
                    UserApi.shared.me { user, error in
                        if let error {
                            print("fetchUserInfo error")
                            print(error.localizedDescription)
                        } else {
                            if let id = user?.id {
                                print("kakao_user_id: \(id)")
                                // 서버에 카카오 ID 전송
                                self?.signInWithKakao(userId: id)
                            }
                        }
                    }
                }
            }
        } else {
            UserApi.shared.loginWithKakaoAccount { [weak self] token, error in
                if let error {
                    print(error.localizedDescription)
                } else {
                    print(token!)
                    
                    // 카카오 사용자 정보 가져오기
                    UserApi.shared.me { user, error in
                        if let error {
                            print(error.localizedDescription)
                        } else {
                            if let id = user?.id {
                                self?.signInWithKakao(userId: id)
                            }
                        }
                    }
                }
            }
        }
    }
}
