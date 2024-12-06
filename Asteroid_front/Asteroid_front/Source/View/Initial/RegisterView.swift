//
//  RegisterView.swift
//  Asteroid_front
//
//  Created by Lia An on 12/4/24.
//

import SwiftUI

struct RegisterView: View {
    @EnvironmentObject private var viewModel: AuthViewModel
    @Binding var isRegistering: Bool
    @State private var showPassword = false
    @State private var showConfirmPassword = false
    @State private var buttonOffset: CGFloat = 0
    @FocusState private var isPasswordFieldActive: Bool
    
    var body: some View {
        VStack(spacing: 30) {
            // 로고
            HStack {
//                Image("asteroid_logo")
//                    .resizable()
//                    .frame(width: 30, height: 30)
                Text("소행성")
                    .font(.starFontB(size: 30))
            }
            .padding(.top, 50)
            
            // 입력 필드들
            VStack(spacing: 15) {
                TextField("이메일", text: $viewModel.email)
                    .modifier(CustomTextFieldStyle())
                    .autocapitalization(.none)
                    .keyboardType(.emailAddress)
                    .onChange(of: viewModel.email) { _ in
                        viewModel.validateEmail()
                    }
                
                // 이메일 유효성 검사 메시지
                if !viewModel.email.isEmpty {
                    Text(viewModel.emailErrorMessage)
                        .font(.caption)
                        .foregroundColor(viewModel.isEmailValid ? .green : .red)
                }
                
                // 비밀번호 입력
                HStack {
                    if showPassword {
                        TextField("비밀번호", text: $viewModel.password)
                            .focused($isPasswordFieldActive)
                            .onChange(of: viewModel.password) { _ in
                                viewModel.validatePassword()
                            }
                    } else {
                        SecureField("비밀번호", text: $viewModel.password)
                            .focused($isPasswordFieldActive)
                            .onChange(of: viewModel.password) { _ in
                                viewModel.validatePassword()
                            }
                    }
                    
                    Button(action: { showPassword.toggle() }) {
                        Image(systemName: showPassword ? "eye.slash.fill" : "eye.fill")
                            .foregroundColor(.gray)
                    }
                }
                .modifier(CustomTextFieldStyle())
                
                // 비밀번호 유효성 검사 UI를 여기로 이동
                if isPasswordFieldActive {
                    VStack(alignment: .leading, spacing: 5) {
                        Text("비밀번호는 다음 조건을 만족해야 합니다:")
                            .font(.caption)
                            .foregroundColor(.gray)
                            .padding(.top, 5)
                        
                        HStack {
                            Image(systemName: viewModel.isPasswordLengthValid ? "checkmark.circle.fill" : "xmark.circle.fill")
                            Text("8자 이상")
                        }
                        .font(.caption)
                        .foregroundColor(viewModel.isPasswordLengthValid ? .green : .red)
                        
                        HStack {
                            Image(systemName: viewModel.hasNumber ? "checkmark.circle.fill" : "xmark.circle.fill")
                            Text("숫자 포함")
                        }
                        .font(.caption)
                        .foregroundColor(viewModel.hasNumber ? .green : .red)
                        
                        HStack {
                            Image(systemName: viewModel.hasSpecialCharacter ? "checkmark.circle.fill" : "xmark.circle.fill")
                            Text("특수문자 포함")
                        }
                        .font(.caption)
                        .foregroundColor(viewModel.hasSpecialCharacter ? .green : .red)
                    }
                    .padding(.leading, 40) // 비밀번호 유효성 검사 왼쪽 패딩
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
                
                // 비밀번호 확인
                HStack {
                    if showConfirmPassword {
                        TextField("비밀번호 확인", text: $viewModel.confirmPassword)
                            .onChange(of: viewModel.confirmPassword) { _ in
                                viewModel.validatePassword()
                            }
                    } else {
                        SecureField("비밀번호 확인", text: $viewModel.confirmPassword)
                            .onChange(of: viewModel.confirmPassword) { _ in
                                viewModel.validatePassword()
                            }
                    }
                    
                    Button(action: { showConfirmPassword.toggle() }) {
                        Image(systemName: showConfirmPassword ? "eye.slash.fill" : "eye.fill")
                            .foregroundColor(.gray)
                    }
                }
                .modifier(CustomTextFieldStyle())
                
                // 비밀번호 일치 여부 메시지
                if !viewModel.isPasswordMatching && !viewModel.confirmPassword.isEmpty {
                    Text("비밀번호가 일치하지 않습니다")
                        .font(.caption)
                        .foregroundColor(.red)
                }
            }
            .padding(.horizontal, 20)
            
            // 회원가입 버튼
            Button(action: {
                viewModel.register()
            }) {
                Text("회원가입")
                    .foregroundColor(.white)
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .background(viewModel.canRegister ? Color.keyColor : Color.gray)
                    .cornerRadius(10)
            }
            .disabled(!viewModel.canRegister)
            .padding(.horizontal, 20)
            .offset(y: buttonOffset)
            .animation(.easeInOut, value: buttonOffset)
            
            // 로그인으로 돌아가기
            Button(action: {
                withAnimation(.easeInOut(duration: 0.3)) {
                    buttonOffset = -50  // 위로 올라가는 효과
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        isRegistering = false
                        buttonOffset = 0
                    }
                }
            }) {
                Text("계정이 있으신가요? 로그인")
                    .foregroundColor(.gray)
                    .font(.footnote)
            }
            .offset(y: buttonOffset)
            
            Spacer()
        }
        .padding(.top, 20)
        .onAppear {
            viewModel.emailErrorMessage = ""
            viewModel.registerErrorMessage = ""
            viewModel.isEmailValid = true
            viewModel.isPasswordMatching = true
            viewModel.isPasswordLengthValid = false
            viewModel.hasNumber = false
            viewModel.hasSpecialCharacter = false
        }
    }
}

#Preview {
    RegisterView(isRegistering: .constant(true))
        .environmentObject(AuthViewModel())
}
