import Foundation

enum SocialAuthType: String {
    case apple
    case kakao
    case google
    case naver
    
    var displayName: String {
        switch self {
        case .apple: return "Apple"
        case .kakao: return "카카오"
        case .google: return "구글"
        case .naver: return "네이버"
        }
    }
}