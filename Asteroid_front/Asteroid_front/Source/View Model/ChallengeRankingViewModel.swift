import Foundation
import Alamofire

@MainActor
class ChallengeRankingViewModel: ObservableObject {
    @Published var rankings: [ChallengeRanking] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String = ""
    
    private let baseURL = "http://localhost:3000"
    
    func fetchRankings() async {
        guard let accessToken = UserDefaults.standard.string(forKey: "accessToken") else { return }
        
        let headers: HTTPHeaders = ["Authorization": "Bearer \(accessToken)"]
        isLoading = true
        
        do {
            let response = try await AF.request("\(baseURL)/challenge/ranking",
                                             method: .get,
                                             headers: headers)
                .serializingDecodable([ChallengeRanking].self)
                .value
            
            rankings = response
            
        } catch {
            print("Rankings fetch error: \(error)")
            errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }
    
    // 선택된 챌린지에 따라 랭킹 필터링
    func filterRankings(by challengeId: Int?) -> [ChallengeRanking] {
        guard let challengeId = challengeId else {
            return rankings // 전체 랭킹 반환
        }
        
        return rankings.filter { ranking in
            ranking.challengeId == challengeId
        }
    }
}