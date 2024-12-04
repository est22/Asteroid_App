//
//  InitialProfileView.swift
//  Asteroid_front
//
//  Created by Lia An on 12/4/24.
//

import SwiftUI

struct InitialProfileView: View {
    @EnvironmentObject private var viewModel: AuthViewModel
    @State private var nickname = ""
    @State private var motto = ""
    @State private var isLoading = false
    @State private var errorMessage = ""
    
    var body: some View {
        VStack(spacing: 30) {
        VStack(spacing: 20) {
            Text("프로필 설정")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.top, 100)
                .padding(.top, 160)
            
            Text("소행성에서 사용할\n닉네임과 좌우명을 입력해주세요✨")
                .font(.body)
                .multilineTextAlignment(.center)
                .foregroundColor(.gray)
                .padding(.top, 20)
                .padding(.bottom, 10)
            
            VStack(spacing: 15) {
                // 닉네임 입력
                TextField("닉네임", text: $nickname)
                    .modifier(CustomTextFieldStyle())
                    .autocapitalization(.none)
            VStack(spacing: 25) {
                
                // 좌우명 입력
                TextField("내 소비 좌우명", text: $motto)
                    .modifier(CustomTextFieldStyle())
                
                if !errorMessage.isEmpty {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .font(.caption)
                }
            }
            .padding(.horizontal, 40)
            
            
            // 시작하기 버튼
            Button(action: {
                updateProfile()
            }) {
                if isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                } else {
                    Text("시작하기")
                        .foregroundColor(.white)
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(canProceed ? Color.keyColor : Color.gray)
                        .cornerRadius(10)
                        .padding(.top, 10)
                }
            }
            .disabled(!canProceed || isLoading)
            .padding(.horizontal, 40)
            
            Spacer()
        }
    }
    
    private var canProceed: Bool {
        return !nickname.isEmpty && !motto.isEmpty
    }
    
    private func updateProfile() {
        isLoading = true
        errorMessage = ""
        
        viewModel.updateInitialProfile(nickname: nickname, motto: motto) { success in
            isLoading = false
            if !success {
                errorMessage = "프로필 설정에 실패했습니다. 다시 시도해주세요."
            }
        }
    }
}

#Preview {
    InitialProfileView()
        .environmentObject(AuthViewModel())
}
