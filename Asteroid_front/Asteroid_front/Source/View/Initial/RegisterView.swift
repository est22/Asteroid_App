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
    @State private var buttonOffset: CGFloat = 0
    
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
                if !viewModel.isEmailValid && !viewModel.email.isEmpty {
                    Text("유효하지 않은 이메일 형식입니다.")
                        .font(.caption)
                        .foregroundColor(.red)
                }
                
                // 비밀번호 입력
                HStack {
                    if showPassword {
                        TextField("비밀번호", text: $viewModel.password)
                    } else {
                        SecureField("비밀번호", text: $viewModel.password)
                    }
                    
                    Button(action: { showPassword.toggle() }) {
                        Image(systemName: showPassword ? "eye.slash.fill" : "eye.fill")
                            .foregroundColor(.gray)
                    }
                }
                .modifier(CustomTextFieldStyle())
                
                // 비밀번호 확인
                SecureField("비밀번호 확인", text: $viewModel.confirmPassword)
                    .modifier(CustomTextFieldStyle())
                    .onChange(of: viewModel.confirmPassword) { _ in
                        viewModel.validatePassword()
                    }
                
                // 비밀번호 유효성 검사 메시지
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
    }
}

#Preview {
    RegisterView(isRegistering: .constant(true))
        .environmentObject(AuthViewModel())
}
