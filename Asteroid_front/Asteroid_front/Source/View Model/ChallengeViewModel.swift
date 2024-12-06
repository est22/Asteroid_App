import Foundation
import Alamofire
import SwiftUI // ObservableObject를 위해 필요

@MainActor
class ChallengeViewModel: ObservableObject {
    @Published var participatingChallenges: [Challenge] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String = ""
    
    
    // 파스텔 컬러 배열
    let pastelColors: [Color] = [
        Color(red: 255/255, green: 179/255, blue: 186/255), // 파스텔 핑크
        Color(red: 255/255, green: 223/255, blue: 186/255), // 파스텔 오렌지
        Color(red: 255/255, green: 255/255, blue: 186/255), // 파스텔 옐로우
        Color(red: 186/255, green: 255/255, blue: 201/255), // 파스텔 그린
        Color(red: 186/255, green: 225/255, blue: 255/255), // 파스텔 블루
        Color(red: 223/255, green: 186/255, blue: 255/255), // 파스텔 퍼플
        Color(red: 255/255, green: 186/255, blue: 255/255), // 파스텔 라벤더
        Color(red: 186/255, green: 255/255, blue: 255/255), // 파스텔 민트
        Color(red: 255/255, green: 214/255, blue: 214/255), // 파스텔 코랄
        Color(red: 214/255, green: 255/255, blue: 224/255)  // 파스텔 세이지
    ]
    
    func fetchParticipatingChallenges() async {
        guard let accessToken = UserDefaults.standard.string(forKey: "accessToken") else { return }
        
        let headers: HTTPHeaders = ["Authorization": "Bearer \(accessToken)"]
        isLoading = true
        
        do {
            let response = try await AF.request("\(APIConfig.baseURL)/settings/challenges",
                                             method: .get,
                                             headers: headers)
                .serializingDecodable([Challenge].self)
                .value
            
            participatingChallenges = response
            
        } catch {
            print("Challenges fetch error: \(error)")
            errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }
    
    // 랜덤 파스텔 컬러 반환
    func randomPastelColor() -> Color {
        pastelColors.randomElement() ?? .blue
    }
}