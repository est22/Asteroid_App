//
//  InitialProfileView.swift
//  Asteroid_front
//
//  Created by Lia An on 12/4/24.
//

import SwiftUI

extension String {
    var koreanCount: Int {
        return self.reduce(0) { count, char in
            let scalars = char.unicodeScalars
            return count + (scalars.contains { $0.value >= 0xAC00 && $0.value <= 0xD7A3 } ? 2 : 1)
        }
    }
}

struct InitialProfileView: View {
    @EnvironmentObject private var viewModel: AuthViewModel
    @State private var nickname = ""
    @State private var motto = ""
    @State private var isLoading = false
    @State private var mottoShakeOffset: CGFloat = 0
    @State private var isMottoExceeded = false
    @State private var isNicknameAvailable = false
    @State private var isNicknameChecked = false
    @FocusState private var nicknameFieldIsFocused: Bool
    @State private var nicknameShakeOffset: CGFloat = 0
    @State private var isNicknameExceeded = false
    
    var body: some View {
        VStack(spacing: 20) {
            Text("프로필 설정")
                .font(.title)
                .fontWeight(.bold)
                .padding(.top, 160)
            
            Text("소행성에서 사용할\n닉네임과 좌우명을 입력해주세요✨")
                .font(.body)
                .multilineTextAlignment(.center)
                .foregroundColor(.gray)
                .padding(.top, 20)
                .padding(.bottom, 10)
            
            VStack(spacing: 15) {
    VStack(alignment: .leading, spacing: 4) {
        ClearableTextField(text: $nickname, placeholder: "닉네임", isError: !viewModel.profileErrorMessage.isEmpty)
            .focused($nicknameFieldIsFocused)
            .onChange(of: nickname) { _ in
                isNicknameChecked = false
                isNicknameAvailable = false
                viewModel.profileErrorMessage = ""
            }
        
        if !viewModel.profileErrorMessage.isEmpty {
            Text(viewModel.profileErrorMessage)
                .foregroundColor(.red)
                .font(.caption)
                .padding(.leading, 4)
        } else if isNicknameChecked && isNicknameAvailable {
            Text("사용 가능한 닉네임입니다.")
                .foregroundColor(Color(UIColor.systemGreen))
                .font(.caption)
                .padding(.leading, 4)
        }
    }
    
    VStack(alignment: .leading, spacing: 4) {
        ClearableTextField(text: $motto, placeholder: "내 소비 좌우명", isError: isMottoExceeded)
            .offset(x: mottoShakeOffset)
            .onChange(of: motto) { newValue in
                if newValue.count > 30 {
                    isMottoExceeded = true
                    motto = String(newValue.prefix(31))
                    
                    withAnimation(.default) {
                        mottoShakeOffset = 10
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        withAnimation(.default) {
                            mottoShakeOffset = -10
                        }
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                        withAnimation(.default) {
                            mottoShakeOffset = 0
                        }
                    }
                } else {
                    isMottoExceeded = false
                }
            }
        
        HStack {
            Spacer()
            Text("\(motto.count)/30")
                .font(.caption)
                .foregroundColor(isMottoExceeded ? .red : .gray)
                .padding(.trailing, 4)
        }
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
        !nickname.isEmpty && !motto.isEmpty
    }
    
    private func updateProfile() {
        isLoading = true
        viewModel.updateInitialProfile(nickname: nickname, motto: motto) { success in
            isLoading = false
        }
    }
    
    private func checkNicknameAvailability() {
        guard !nickname.isEmpty else { return }
        
        print("닉네임 체크 시작: \(nickname)")
        viewModel.checkNicknameAvailability(nickname) { success in
            print("닉네임 체크 결과: \(success)")
            isNicknameChecked = true
            isNicknameAvailable = success
        }
    }
}

#Preview {
    InitialProfileView()
        .environmentObject(AuthViewModel())
}
