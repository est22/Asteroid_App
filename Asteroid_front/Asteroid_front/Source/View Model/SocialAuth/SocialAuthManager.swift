import Foundation
import SwiftUI
import Combine

class SocialAuthManager: ObservableObject {
    @Published var lastUsedAuth: SocialAuthType?
    private var authViewModel: AuthViewModel
    private let kakaoAuthViewModel: KakaoAuthViewModel
    private let appleAuthViewModel: AppleAuthViewModel
    // 구현 전
    // private let googleAuthViewModel = GoogleAuthViewModel()
    // private let naverAuthViewModel = NaverAuthViewModel()
    
    init(authViewModel: AuthViewModel = AuthViewModel()) {
        self.authViewModel = authViewModel
        self.kakaoAuthViewModel = KakaoAuthViewModel(authViewModel: authViewModel)
        self.appleAuthViewModel = AppleAuthViewModel(authViewModel: authViewModel)
        lastUsedAuth = SocialAuthType(rawValue: UserDefaults.standard.string(forKey: "lastUsedAuth") ?? "")
    }
    
    func handleLogin(with type: SocialAuthType) {
        switch type {
        case .apple:
            appleAuthViewModel.handleSignInWithApple()
        case .kakao:
            kakaoAuthViewModel.handleSignInWithKakao()
        case .google:
            // googleAuthViewModel.handleSignInWithGoogle()
            print("Google login not implemented yet")
        case .naver:
            // naverAuthViewModel.handleSignInWithNaver()
            print("Naver login not implemented yet")
        }
        
        // 마지막 로그인 수단 저장
        UserDefaults.standard.set(type.rawValue, forKey: "lastUsedAuth")
        lastUsedAuth = type
    }
} 