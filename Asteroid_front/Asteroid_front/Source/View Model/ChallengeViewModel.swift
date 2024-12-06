import Foundation
import Alamofire
import SwiftUI

@MainActor
class ChallengeViewModel: ObservableObject {
    @Published var participatingChallenges: [ChallengeInfo] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String = ""
    
    // 섹션별로 마지막 색상 인덱스를 저장
    private var lastColorIndices: [String: Int] = [:]
    
    // 섹션별로 다른 랜덤 파스텔 컬러 반환
    func randomPastelColor(forSection section: String) -> Color {
        let colorCount = Color.pastelColors.count
        if colorCount <= 1 { return Color.pastelColors[0] }
        
        // 현재 섹션의 마지막 인덱스를 가져옴
        let lastIndex = lastColorIndices[section] ?? -1
        
        // 현재 인덱스를 제외한 새로운 랜덤 인덱스 생성
        var newIndex: Int
        repeat {
            newIndex = Int.random(in: 0..<colorCount)
        } while newIndex == lastIndex
        
        // 새로운 인덱스를 해당 섹션에 저장
        lastColorIndices[section] = newIndex
        return Color.pastelColors[newIndex]
    }
    
    func fetchParticipatingChallenges() async {
        guard let accessToken = UserDefaults.standard.string(forKey: "accessToken") else { return }
        
        let headers: HTTPHeaders = ["Authorization": "Bearer \(accessToken)"]
        isLoading = true
        
        do {
            let response = try await AF.request("\(APIConstants.baseURL)/settings/challenges",
                                             method: .get,
                                             headers: headers)
                .serializingDecodable([ChallengeInfo].self)
                .value
            
            participatingChallenges = response
            
        } catch {
            print("Challenges fetch error: \(error)")
            errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }
}
