//
//  ProfileFieldsView.swift
//  Asteroid_front
//
//  Created by Lia An on 12/13/24.
//

import SwiftUI

struct ProfileFieldsView: View {
    @Binding var nickname: String
    @Binding var motto: String
    @Binding var isNicknameChecked: Bool
    @Binding var isNicknameAvailable: Bool
    @Binding var isMottoExceeded: Bool
    var profileErrorMessage: String
    var onNicknameCheck: () async -> Void
    @FocusState private var nicknameFieldIsFocused: Bool
    @State private var mottoShakeOffset: CGFloat = 0
    var currentNickname: String
    
    var body: some View {
        VStack(spacing: 15) {
            // 닉네임 필드
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    ClearableTextField(
                        text: $nickname,
                        placeholder: "닉네임",
                        isError: !profileErrorMessage.isEmpty && !profileErrorMessage.contains("사용 가능한 닉네임입니다"),
                        isSuccess: isNicknameChecked && isNicknameAvailable
                    )
                    .focused($nicknameFieldIsFocused)
                    .onChange(of: nickname) { _ in
                        isNicknameChecked = false
                        isNicknameAvailable = false
                    }
                    
                    Button("중복확인") {
                        Task {
                            await onNicknameCheck()
                        }
                    }
                    .foregroundStyle(nickname.isEmpty || nickname == currentNickname ? .gray : Color.keyColor)
                    .disabled(nickname.isEmpty || nickname == currentNickname)
                }
                
                if !profileErrorMessage.isEmpty {
                    Text(profileErrorMessage)
                        .foregroundColor(
                            profileErrorMessage == "사용 가능한 닉네임입니다."
                            ? Color(UIColor.systemGreen)
                            : .red
                        )
                        .font(.caption)
                        .padding(.leading, 4)
                }
            }
            
            // 좌우명 필드
            VStack(alignment: .leading, spacing: 4) {
                ClearableTextField(
                    text: $motto,
                    placeholder: "내 소비 좌우명",
                    isError: isMottoExceeded
                )
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
    }
} 