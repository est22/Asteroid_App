//
//  LoginView.swift
//  Asteroid_front
//
//  Created by Lia An on 12/3/24.
//
import SwiftUI

struct LoginView: View {
    @EnvironmentObject private var viewModel: AuthViewModel
    @State private var showPassword = false
    @State private var buttonOffset: CGFloat = 0
    
    var body: some View {
        VStack(spacing: 30) {
            // 로고
            HStack {
//                Image("asteroid_logo")
//                    .resizable()
//                    .frame(width: 30, height: 30)
                Text("소행성").font(.starFontB(size: 30))
            }
            .padding(.top, 50)
            
            // 입력 필드들
            VStack(spacing: 15) {
                TextField("이메일", text: $viewModel.email)
                    .modifier(CustomTextFieldStyle())
                    .autocapitalization(.none)
                    .keyboardType(.emailAddress)
                
                // 비밀번호 입력 필드
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
            }
            .padding(.horizontal, 20)
            
            // 로그인 버튼 위에 에러 메시지 표시
            if !viewModel.loginErrorMessage.isEmpty {
                Text(viewModel.loginErrorMessage)
                    .foregroundColor(.red)
                    .font(.caption)
            }
            
            // 로그인 버튼
            Button(action: {
                viewModel.login()
            }) {
                if viewModel.isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                } else {
                    Text("로그인")
                    .foregroundColor(.white)
                    .fontWeight(.heavy)
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .background(viewModel.canLogin ? Color.keyColor : Color.gray)
                    .cornerRadius(10)
                }
            }
            .padding(.horizontal, 20)
            .disabled(!viewModel.canLogin || viewModel.isLoading)
            
            // 회원가입 전환 버튼
            Button(action: {
                withAnimation(.easeInOut(duration: 0.3)) {
                    buttonOffset = 50
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        viewModel.isRegistering = true
                        buttonOffset = 0
                    }
                }
            }) {
                Text("계정이 없으신가요? 회원가입")
                    .foregroundColor(.gray)
                    .font(.footnote)
            }
            .offset(y: buttonOffset)
            
            // 소셜 로그인 섹션
            VStack(spacing: 20) {
                Text("소셜 로그인")
                    .foregroundColor(.gray)
                    .font(.footnote)
                
                HStack(spacing: 30) {
                    SocialLoginButton(image: "kakao", action: {})
//                    SocialLoginButton(image: "naver", action: {})
                    SocialLoginButton(image: "google", action: {})
                    SocialLoginButton(image: "apple", action: {
                        viewModel.handleSignInWithApple()
                    })
                }
            }
            .padding(.top, 30)
            
            Spacer()
        }
        .padding(.top, 20)
    }
}
// 커스텀 텍스트필드 스타일


// 소셜 로그인 버튼
struct SocialLoginButton: View {
    let image: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Image(image)
                .resizable()
                .scaledToFit()
                .frame(width: 40, height: 40)
        }
    }
}

#Preview {
    LoginView()
        .environmentObject(AuthViewModel())
}
