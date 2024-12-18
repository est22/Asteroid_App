import SwiftUI

struct Home: View {
  @EnvironmentObject private var authViewModel: AuthViewModel
  @State private var showNotifications = false
  
  var body: some View {
    ZStack {
      // 메인 컨텐츠
      NavigationView {
        VStack(spacing: 0) {
          // 커스텀 네비게이션 바
          HStack {
            Text("  소행성")
              .font(.starFontB(size: 24))
              .foregroundColor(.black)
              .padding(.leading, 16)
            
            Spacer()
            
            // 로그아웃 버튼 (개발용)
            #if DEBUG
            Button {
              authViewModel.logout()
            } label: {
              Image(systemName: "rectangle.portrait.and.arrow.right")
                .foregroundColor(.keyColor)
                .padding(.trailing, 8)
            }
//            // 신고 버튼 테스트
//            ReportButton(targetType: "P", targetId: 1)
            #endif
            
            // 알림 버튼
            Button {
              withAnimation(.spring()) {
                showNotifications.toggle()
              }
            } label: {
              Image(systemName: "bell.fill")
                .foregroundColor(.keyColor)
                .padding(.trailing, 16)
            }
          }
          .padding(.top, 8)
          
          // 스크롤바 제거
          ScrollView(showsIndicators: false) {
            VStack(spacing: 10) {
              PostRankingView()
                .frame(height: UIScreen.main.bounds.height * 0.25)
                .padding(.bottom, 80)
              
              ChallengeRankingView()
                .frame(height: UIScreen.main.bounds.height * 0.25)
                .padding(.bottom, 80)
              
              MyOngoingChallengeView()
                .padding(.bottom, 16)
            }
            .padding(.top, 8)
          }
        }
        .navigationBarHidden(true)
      }
      
      // 알림 관련 오버레이
      if showNotifications {
        Color.black
          .opacity(0.3)
          .ignoresSafeArea()
          .onTapGesture {
            withAnimation(.spring()) {
              showNotifications = false
            }
          }
      }
      
      // 알림 사이드 패널
      GeometryReader { geometry in
        HStack {
          Spacer()
          NotificationsView()
            .frame(width: geometry.size.width * 0.85)
            .background(Color(.systemBackground))
            .offset(x: showNotifications ? 0 : geometry.size.width)
        }
      }
      .ignoresSafeArea()
    }
  }
}

#Preview {
  Home()
}

