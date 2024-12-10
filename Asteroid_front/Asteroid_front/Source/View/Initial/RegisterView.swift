//
//  RegisterView.swift
//  Asteroid_front
//
//  Created by Lia An on 12/4/24.
//

import SwiftUI

struct RegisterView: View {
    @EnvironmentObject private var authViewModel: AuthViewModel
    @Binding var isRegistering: Bool
    @State private var showPassword = false
    @State private var showConfirmPassword = false
    @State private var buttonOffset: CGFloat = 0
    @FocusState private var isPasswordFieldActive: Bool
    
    var body: some View {
        VStack(spacing: 30) {
            // 로고
            HStack {
                Text("소행성")
                    .font(.starFontB(size: 30))
            }
            .padding(.top, 50)
            
            // 입력 필드들
            VStack(spacing: 15) {
                TextField("이메일", text: $authViewModel.email)
                    .modifier(CustomTextFieldStyle())
                    .autocapitalization(.none)
                    .keyboardType(.emailAddress)
                    .onChange(of: authViewModel.email) { _ in
                        authViewModel.validateEmail()
                    }
                
                if !authViewModel.email.isEmpty {
                    Text(authViewModel.emailErrorMessage)
                        .font(.caption)
                        .foregroundColor(authViewModel.isEmailValid ? .green : .red)
                }
                
                HStack {
                    if showPassword {
                        TextField("비밀번호", text: $authViewModel.password)
                            .focused($isPasswordFieldActive)
                            .onChange(of: authViewModel.password) { _ in
                                authViewModel.validatePassword()
                            }
                    } else {
                        SecureField("비밀번호", text: $authViewModel.password)
                            .focused($isPasswordFieldActive)
                            .onChange(of: authViewModel.password) { _ in
                                authViewModel.validatePassword()
                            }
                    }
                    
                    Button(action: { showPassword.toggle() }) {
                        Image(systemName: showPassword ? "eye.slash.fill" : "eye.fill")
                            .foregroundColor(.gray)
                    }
                }
                .modifier(CustomTextFieldStyle())
                
                if isPasswordFieldActive {
                    VStack(alignment: .leading, spacing: 5) {
                        Text("비밀번호는 다음 조건을 만족해야 합니다:")
                            .font(.caption)
                            .foregroundColor(.gray)
                            .padding(.top, 5)
                        
                        HStack {
                            Image(systemName: authViewModel.isPasswordLengthValid ? "checkmark.circle.fill" : "xmark.circle.fill")
                            Text("8자 이상")
                        }
                        .font(.caption)
                        .foregroundColor(authViewModel.isPasswordLengthValid ? .green : .red)
                        
                        HStack {
                            Image(systemName: authViewModel.hasNumber ? "checkmark.circle.fill" : "xmark.circle.fill")
                            Text("숫자 포함")
                        }
                        .font(.caption)
                        .foregroundColor(authViewModel.hasNumber ? .green : .red)
                        
                        HStack {
                            Image(systemName: authViewModel.hasSpecialCharacter ? "checkmark.circle.fill" : "xmark.circle.fill")
                            Text("특수문자 포함")
                        }
                        .font(.caption)
                        .foregroundColor(authViewModel.hasSpecialCharacter ? .green : .red)
                    }
                    .padding(.leading, 40)
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
                
                HStack {
                    if showConfirmPassword {
                        TextField("비밀번호 확인", text: $authViewModel.confirmPassword)
                            .onChange(of: authViewModel.confirmPassword) { _ in
                                authViewModel.validatePassword()
                            }
                    } else {
                        SecureField("비밀번호 확인", text: $authViewModel.confirmPassword)
                            .onChange(of: authViewModel.confirmPassword) { _ in
                                authViewModel.validatePassword()
                            }
                    }
                    
                    Button(action: { showConfirmPassword.toggle() }) {
                        Image(systemName: showConfirmPassword ? "eye.slash.fill" : "eye.fill")
                            .foregroundColor(.gray)
                    }
                }
                .modifier(CustomTextFieldStyle())
                
                if !authViewModel.isPasswordMatching && !authViewModel.confirmPassword.isEmpty {
                    Text("비밀번호가 일치하지 않습니다")
                        .font(.caption)
                        .foregroundColor(.red)
                }
            }
            .padding(.horizontal, 20)
            
            Button(action: {
                authViewModel.register()
            }) {
                Text("회원가입")
                    .foregroundColor(.white)
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .background(authViewModel.canRegister ? Color.keyColor : Color.gray)
                    .cornerRadius(10)
            }
            .disabled(!authViewModel.canRegister)
            .padding(.horizontal, 20)
            .offset(y: buttonOffset)
            .animation(.easeInOut, value: buttonOffset)
            
            Button(action: {
                withAnimation(.easeInOut(duration: 0.3)) {
                    buttonOffset = -50
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
            authViewModel.emailErrorMessage = ""
            authViewModel.registerErrorMessage = ""
            authViewModel.isEmailValid = true
            authViewModel.isPasswordMatching = true
            authViewModel.isPasswordLengthValid = false
            authViewModel.hasNumber = false
            authViewModel.hasSpecialCharacter = false
        }
    }
}

#Preview {
    RegisterView(isRegistering: .constant(true))
        .environmentObject(AuthViewModel())
}
