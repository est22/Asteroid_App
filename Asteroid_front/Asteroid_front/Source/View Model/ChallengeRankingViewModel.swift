import Foundation
import Alamofire

@MainActor
class ChallengeRankingViewModel: ObservableObject {
    @Published var rankings: [ChallengeRanking] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String = ""
    
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
            
            rankings = response.sorted { 
                ($0.topUsers.first?.credit ?? 0) > ($1.topUsers.first?.credit ?? 0)
            }
            
        } catch {
            print("Rankings fetch error: \(error)")
            errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }
    
    func filterRankings(by challengeId: Int?) -> [ChallengeRanking] {
        print("=== 필터링 디버그 ===")
        print("선택된 챌린지 ID:", challengeId ?? "전체")
        
        // 전체 포인트순 보기
        if challengeId == nil {
            // 모든 챌린지의 유저들을 하나로 합침
            let allUsers = rankings.flatMap { $0.topUsers }
            
            // 닉네임으로 그룹화하고 가장 높은 점수만 유지
            let uniqueUsers = Dictionary(grouping: allUsers) { $0.nickname }
                .values
                .compactMap { users in
                    users.max { $0.credit < $1.credit }
                }
                .sorted { $0.credit > $1.credit }
                .filter { $0.credit > 0 }  // 0점인 유저 제외
            
            print("전체 보기 유저 수:", uniqueUsers.count)
            return [ChallengeRanking(
                challengeId: 0,
                challengeName: "전체",
                topUsers: Array(uniqueUsers.prefix(5))
            )]
        } 
        // 챌린지별 보기
        else {
                //         return rankings
                // .filter { $0.challengeId == challengeId }
                // .map { ranking in
                //     ChallengeRanking(
                //         challengeId: ranking.challengeId,
                //         challengeName: ranking.challengeName,
                //         topUsers: ranking.topUsers
                //             .filter { $0.credit > 0 }  // 0점인 유저 제외
                //             .sorted { $0.credit > $1.credit }  // 점수 높은 순으로 정렬
                //             .prefix(5)  // 상위 5명만
                //             .map { $0 }
                //     )
                // }
            let filtered = rankings.filter { $0.challengeId == challengeId }
            print("필터링된 챌린지:", filtered.map { $0.challengeName })
            print("해당 챌린지 유저 수:", filtered.first?.topUsers.count ?? 0)
            
            return filtered  // 필터링된 챌린지 그대로 반환
        }
    }
}