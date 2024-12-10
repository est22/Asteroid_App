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
    @EnvironmentObject private var authViewModel: AuthViewModel
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
        HStack {
            ClearableTextField(
                text: $nickname, 
                placeholder: "닉네임", 
                isError: authViewModel.profileErrorMessage.isEmpty ? false : !authViewModel.profileErrorMessage.contains("사용 가능한 닉네임입니다"),
                isSuccess: isNicknameChecked && isNicknameAvailable
            )
            .focused($nicknameFieldIsFocused)
            .onChange(of: nickname) { _ in
                isNicknameChecked = false
                isNicknameAvailable = false
                authViewModel.profileErrorMessage = ""
            }
            
            Button("중복확인") {
                checkNicknameAvailability()
            }.foregroundStyle(Color.keyColor)
            .disabled(nickname.isEmpty)
        }
        
        if !authViewModel.profileErrorMessage.isEmpty {
            Text(authViewModel.profileErrorMessage)
                .foregroundColor(
                    authViewModel.profileErrorMessage == "사용 가능한 닉네임입니다." 
                    ? Color(UIColor.systemGreen) 
                    : .red
                )
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
        let result = nickname.isEmpty == false &&  // 닉네임이 있음
                     motto.isEmpty == false &&     // 좌우명이 있음
                     isNicknameChecked && 
                     isNicknameAvailable && 
                     !isMottoExceeded
        
//        // 디버깅용 출력
//        print("canProceed 상태:")
//        print("- nickname not empty: \(!nickname.isEmpty)")
//        print("- motto not empty: \(!motto.isEmpty)")
//        print("- nickname checked: \(isNicknameChecked)")
//        print("- nickname available: \(isNicknameAvailable)")
//        print("- motto not exceeded: \(!isMottoExceeded)")
//        print("Final result: \(result)")
        
        return result
    }
    
    private func updateProfile() {
        if !isNicknameChecked {
            checkNicknameAvailability()
            return
        }
        
        isLoading = true
        authViewModel.updateInitialProfile(nickname: nickname, motto: motto) { success in
            isLoading = false
            if !success {
                authViewModel.profileErrorMessage = "프로필 설정에 실패했습니다. 다시 시도해주세요."
            }
        }
    }
    
    private func checkNicknameAvailability() {
        guard !nickname.isEmpty else { return }
        
        print("닉네임 체크 시작: \(nickname)")  // 디버깅용
        
        authViewModel.checkNicknameAvailability(nickname) { success in
            print("닉네임 체크 결과: \(success)")  // 디버깅용
            
            DispatchQueue.main.async {
                isNicknameChecked = true
                isNicknameAvailable = success
                
                // 디버깅용
                print("상태 업데이트 완료:")
                print("- isNicknameChecked: \(isNicknameChecked)")
                print("- isNicknameAvailable: \(isNicknameAvailable)")
            }
        }
    }
}

#Preview {
    InitialProfileView()
        .environmentObject(AuthViewModel())
}
