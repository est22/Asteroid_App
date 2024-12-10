import SwiftUI

struct SocialLoginButton: View {
    let type: SocialAuthType
    @EnvironmentObject var socialAuthManager: SocialAuthManager
    
    var body: some View {
        VStack(spacing: 8) {
            Button(action: {
                socialAuthManager.handleLogin(with: type)
            }) {
                Image(type.rawValue)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 50, height: 50)
            }
            
            if socialAuthManager.lastUsedAuth == type {
                LastLoginBadge()
            }
        }
    }
}

struct LastLoginBadge: View {
    var body: some View {
        VStack(spacing: 0) {
            // 위쪽 삼각형 화살표
            Triangle()
                .fill(Color.white)
                .frame(width: 10, height: 5)
                .shadow(color: .gray.opacity(0.2), radius: 1, y: -1)
            
            // 말풍선 내용
            Text("최근 로그인")
                .font(.caption2)
                .fontWeight(.medium)
                .foregroundColor(.gray)
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.white)
                        .shadow(color: .gray.opacity(0.2), radius: 3)
                )
        }
        .zIndex(1)
    }
}

// 삼각형 모양을 그리기 위한 커스텀 Shape
struct Triangle: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.midX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.closeSubpath()
        return path
    }
}

#Preview {
    VStack {
        SocialLoginButton(type: .kakao)
            .environmentObject(SocialAuthManager())
    }
    .padding()
    .previewLayout(.sizeThatFits)
}
