//
//  GoogleAuthViewModel.swift
//  Asteroid_front
//
//  Created by Lia An on 12/5/24.
//

import Foundation

class GoogleAuthViewModel: ObservableObject {
    @Published var googleSignInError: String?
    var onLoginSuccess: ((Bool) -> Void)?
    
    func handleSignInWithGoogle() {
        // Google 로그인 구현
    }
}
