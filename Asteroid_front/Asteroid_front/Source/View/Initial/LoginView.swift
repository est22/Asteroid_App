//
//  LoginView.swift
//  Asteroid_front
//
//  Created by Lia An on 12/3/24.
//
import SwiftUI

struct LoginView: View {
  @EnvironmentObject private var authViewModel: AuthViewModel
  @EnvironmentObject private var socialAuthManager: SocialAuthManager
  @StateObject private var kakaoAuthVM = KakaoAuthViewModel(authViewModel: AuthViewModel.shared)
  @State private var showPassword = false
  @State private var buttonOffset: CGFloat = 0
  
  var body: some View {
    VStack(spacing: 30) {
      // 로고
      HStack {
        // Image("asteroid_logo")
        //     .resizable()
        //     .frame(width: 30, height: 30)
        Text("소행성")
          .font(.starFontB(size: 30))
      }
      .padding(.top, 60)
      
      
      // 입력 필드들
      VStack(spacing: 15) {
        TextField("이메일", text: $authViewModel.email)
          .modifier(CustomTextFieldStyle())
          .autocapitalization(.none)
          .keyboardType(.emailAddress)
        
        // 비밀번호 입력 필드
        HStack {
          if showPassword {
            TextField("비밀번호", text: $authViewModel.password)
          } else {
            SecureField("비밀번호", text: $authViewModel.password)
          }
          
          Button(action: { showPassword.toggle() }) {
            Image(systemName: showPassword ? "eye.slash.fill" : "eye.fill")
              .foregroundColor(.gray)
          }
        }
        .modifier(CustomTextFieldStyle())
        
        // 비밀번호 찾기 링크
        HStack {
          Spacer()
          Text("비밀번호를 잊어버리셨나요?")
            .foregroundColor(.gray)
            .font(.footnote)
            .underline()
            .onTapGesture {
              if let url = URL(string: "mailto:test@test.com") {
                UIApplication.shared.open(url)
              }
            }
            .padding(.trailing, 20)
        }
        .padding(.top, 2)
      }
      .padding(.horizontal, 20)
      
      // 로그인 버튼 위에 에러 메시지 표시
      if !authViewModel.loginErrorMessage.isEmpty {
        Text(authViewModel.loginErrorMessage)
          .foregroundColor(.red)
          .font(.caption)
      }
      
      // 로그인 버튼
      Button(action: {
        authViewModel.login()
      }) {
        if authViewModel.isLoading {
          ProgressView()
            .progressViewStyle(CircularProgressViewStyle(tint: .white))
        } else {
          Text("로그인")
            .foregroundColor(.white)
            .fontWeight(.heavy)
            .frame(maxWidth: .infinity)
            .frame(height: 50)
            .background(authViewModel.canLogin ? Color.keyColor : Color.gray)
            .cornerRadius(10)
        }
      }
      .padding(.horizontal, 20)
      .disabled(!authViewModel.canLogin || authViewModel.isLoading)
      
      // 회원가입 전환 버튼
      Button(action: {
        withAnimation(.easeInOut(duration: 0.3)) {
          buttonOffset = 50
          DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            authViewModel.isRegistering = true
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
        // 구분선
        HStack {
          Rectangle()
            .fill(Color.gray.opacity(0.3))
            .frame(height: 1)
            .padding(.horizontal)
        }
        
        Text("소셜 로그인")
          .foregroundColor(.gray)
          .font(.footnote)
        
        // 소셜 로그인 버튼들을 일렬로 배치
        HStack(spacing: 30) {
          SocialLoginButton(type: .google)
          SocialLoginButton(type: .apple)
          SocialLoginButton(type: .naver)
          SocialLoginButton(type: .kakao)
        }
        .padding(.horizontal, 20)
        .padding(.bottom, 60) // 말풍선을 위한 여백
      }
      .padding(.top, 30)
      
      Spacer()
    }
    .padding(.top, 20)
    .onAppear {
      authViewModel.loginErrorMessage = ""  // 에러 메시지만 초기화
    }
  }
}

// 커스텀 텍스트필드 스타일

#Preview {
    LoginView()
        .environmentObject(AuthViewModel())
}


