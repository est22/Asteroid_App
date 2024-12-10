import Foundation
import Alamofire
import SwiftUI

@MainActor
class ChallengeViewModel: ObservableObject {
    @Published var participatingChallenges: [ChallengeInfo] = []
    @Published var challenges: [ChallengeInfo] = []  // 전체 챌린지 목록
    @Published var selectedChallenge: ChallengeDetail?  // 선택된 챌린지 상세 정보
    @Published var isLoading: Bool = false
    @Published var errorMessage: String = ""
    
    // 섹션별로 마지막 색상 인덱스를 저장
    private var lastColorIndices: [String: Int] = [:]
    
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
    
    // 전체 챌린지 목록 가져오기
    func fetchChallenges() async {
        guard let accessToken = UserDefaults.standard.string(forKey: "accessToken") else { return }
        
        let headers: HTTPHeaders = ["Authorization": "Bearer \(accessToken)"]
        isLoading = true
        
        do {
            // API 요청 전 로그
            print("Fetching challenges from: \(APIConstants.baseURL)/challenge")
            
            let response = try await AF.request("\(APIConstants.baseURL)/challenge",
                                             method: .get,
                                             headers: headers)
                .validate()  // 응답 검증 추가
                .serializingDecodable([ChallengeInfo].self)
                .value
            
            challenges = response
            
        } catch {
            print("Challenges fetch error: \(error)")
            if let underlyingError = (error as? AFError)?.underlyingError {
                print("Underlying error: \(underlyingError)")
            }
            errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }
    
    // 챌린지 상세 정보 가져오기
    func fetchChallengeDetail(id: Int) async {
        guard let accessToken = UserDefaults.standard.string(forKey: "accessToken") else { return }
        
        let headers: HTTPHeaders = ["Authorization": "Bearer \(accessToken)"]
        isLoading = true
        
        do {
            print("Fetching challenge detail from: \(APIConstants.baseURL)/challenge/\(id)")
            
            let response = try await AF.request("\(APIConstants.baseURL)/challenge/\(id)",
                                             method: .get,
                                             headers: headers)
                .validate()
                .responseData { response in
                    // 응답 데이터 로깅
                    if let data = response.data, let str = String(data: data, encoding: .utf8) {
                        print("Response data: \(str)")
                    }
                }
                .serializingDecodable(ChallengeDetail.self)
                .value
            
            selectedChallenge = response
            
        } catch {
            print("Challenge detail fetch error: \(error)")
            if let underlyingError = (error as? AFError)?.underlyingError {
                print("Underlying error: \(underlyingError)")
            }
            errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }
}