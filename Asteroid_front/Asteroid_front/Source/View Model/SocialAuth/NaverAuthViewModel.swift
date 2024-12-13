//
//  NaverAuthViewModel.swift
//  Asteroid_front
//
//  Created by Lia An on 12/5/24.
//

import Foundation

class NaverAuthViewModel: ObservableObject {
    @Published var naverSignInError: String?
    var onLoginSuccess: ((Bool) -> Void)?
    
    func handleSignInWithNaver() {
        // Naver 로그인 구현
    }
}
