import Foundation
import Alamofire

@MainActor
class RankingViewModel: ObservableObject {
  @Published var rankings: [ChallengeRanking] = [] // Challenge 랭킹
  @Published var postRankings: [PostRanking] = []  // Post 랭킹
  @Published var isLoading: Bool = false
  @Published var errorMessage: String = ""
  
  // Challenge 랭킹
  func fetchRankings() async {
    guard let accessToken = UserDefaults.standard.string(forKey: "accessToken") else { return }
    
    let headers: HTTPHeaders = ["Authorization": "Bearer \(accessToken)"]
    isLoading = true
    
    do {
      let response = try await AF.request("\(APIConstants.baseURL)/challenge/ranking",
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
  
  // Post 랭킹
  func fetchPostRankings(categoryId: Int) async {
    guard let accessToken = UserDefaults.standard.string(forKey: "accessToken") else { return }
    
    let headers: HTTPHeaders = ["Authorization": "Bearer \(accessToken)"]
    isLoading = true
    
    do {
      let response = try await AF.request("\(APIConstants.baseURL)/post/hot?category=\(categoryId)",
                                          method: .get, headers: headers)
      
        .serializingDecodable([PostRanking].self)
        .value
      
      postRankings = response
      
    } catch {
      print("Post Rankings fetch error: \(error)")
      errorMessage = error.localizedDescription
    }
    
    isLoading = false
  }
}
