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
    @Published var isParticipating: Bool = false
    @Published var participantCount: Int = 0
    @Published var currentParticipantCount: Int = 0  // 현재 참여자 수를 추적하는 새로운 변수
    @Published var challengeProgress: Int = 0
    @Published var uploadCount: Int = 0
    @Published var showAlert: Bool = false
    @Published var alertMessage: String = ""
    
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
//            print("Fetching challenges from: \(APIConstants.baseURL)/challenge")
            
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
//            print("Fetching challenge detail from: \(APIConstants.baseURL)/challenge/\(id)")
            
            let response = try await AF.request("\(APIConstants.baseURL)/challenge/\(id)",
                                             method: .get,
                                             headers: headers)
                .validate()
                .responseData { response in
                    // 응답 데이터 로깅
                    if let data = response.data, let str = String(data: data, encoding: .utf8) {
//                        print("Response data: \(str)")
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
    
    // 챌린지 참여중이면 챌린지 업로드+progress bar , 참여중 아니면 "나도 참여하기" 버튼을 위해 
    func isParticipatingIn(challengeId: Int) -> Bool {
        return participatingChallenges.contains { $0.id == challengeId }
    }
    
    func participateInChallenge(id: Int) async {
        guard let url = URL(string: "\(APIConstants.baseURL)/challenge/\(id)/participate") else { return }
        guard let accessToken = UserDefaults.standard.string(forKey: "accessToken") else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            if let httpResponse = response as? HTTPURLResponse {
                print("Participate API Response Status: \(httpResponse.statusCode)")
                if httpResponse.statusCode == 200 {
                    print("Successfully participated in challenge")
                    await MainActor.run {
                        self.isParticipating = true
                        self.participantCount += 1
                        // 참여 목록에 추가
                        Task {
                            await self.fetchParticipatingChallenges()
                        }
                    }
                } else {
                    print("Failed to participate: \(httpResponse.statusCode)")
                }
            }
            
            if let responseString = String(data: data, encoding: .utf8) {
                print("API Response: \(responseString)")
            }
        } catch {
            print("Error participating in challenge: \(error)")
        }
    }
    
    func fetchChallengeImages(challengeId: Int, page: Int, limit: Int) async throws -> ChallengeImagesResponse {
        guard let url = URL(string: "\(APIConstants.baseURL)/challenge/\(challengeId)/images?page=\(page)&limit=\(limit)") else {
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        if let token = UserDefaults.standard.string(forKey: "accessToken") {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw URLError(.badServerResponse)
        }
        
        guard httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
        
        let decoder = JSONDecoder()
        return try decoder.decode(ChallengeImagesResponse.self, from: data)
    }
    
    func checkParticipationStatus(challengeId: Int) async {
        guard let url = URL(string: "\(APIConstants.baseURL)/settings/challenges") else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(UserDefaults.standard.string(forKey: "accessToken") ?? "")", forHTTPHeaderField: "Authorization")
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                let challenges = try JSONDecoder().decode([ChallengeInfo].self, from: data)
                
                DispatchQueue.main.async {
                    self.isParticipating = challenges.contains { $0.id == challengeId }
                }
            }
        } catch {
            print("Error checking participation status: \(error)")
        }
    }
    // '참여'시 참여자수 +1을 위한 사용자 즉각 피드백
    func incrementParticipantCount() {
        currentParticipantCount += 1
    }
    
    func uploadChallengeImage(challengeId: Int, image: UIImage) async throws -> String {
        print("이미지 업로드 시작: 챌린지 ID \(challengeId)")
        
        guard let url = URL(string: "\(APIConstants.baseURL)/challenge/\(challengeId)/upload"),
              let imageData = image.jpegData(compressionQuality: 0.8) else {
            throw URLError(.badURL)
        }
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(UserDefaults.standard.string(forKey: "accessToken") ?? "")"
        ]
        
        return try await withCheckedThrowingContinuation { continuation in
            AF.upload(multipartFormData: { multipartFormData in
                multipartFormData.append(imageData, withName: "images", fileName: "image.jpg", mimeType: "image/jpeg")
            }, to: url, headers: headers)
            .responseString { response in
                switch response.result {
                case .success(let responseString):
                    print("서버 응답:", responseString)
                    continuation.resume(returning: responseString)
                case .failure(let error):
                    print("업로드 실패:", error)
                    continuation.resume(throwing: error)
                }
            }
        }
    }
    
    func fetchChallengeProgress(challengeId: Int) async {
        guard let accessToken = UserDefaults.standard.string(forKey: "accessToken") else { return }
        
        let headers: HTTPHeaders = ["Authorization": "Bearer \(accessToken)"]
        
        do {
            let response = try await AF.request("\(APIConstants.baseURL)/challenge/\(challengeId)/progress",
                                         method: .get,
                                         headers: headers)
                .serializingDecodable(ChallengeProgressResponse.self)
                .value
            
            await MainActor.run {
                self.uploadCount = response.uploadCount
            }
        } catch {
            print("진행률 조회 실패:", error)
        }
    }

    // 챌린지 이미지 일일 인증 여부 확인
    func checkTodayUpload(challengeId: Int) async throws -> Bool {
        let url = "\(APIConstants.baseURL)/challenge/\(challengeId)/check-today-upload"
        
        // UserDefaults에서 토큰 가져오기
        if let token = UserDefaults.standard.string(forKey: "accessToken") {
            print("토큰 존재:", String(token.prefix(10)) + "...")  // 토큰의 앞부분만 출력
            
            return try await withCheckedThrowingContinuation { continuation in
                AF.request(url,
                    method: .get,
                    headers: [
                        "Authorization": "Bearer \(token)",
                        "Content-Type": "application/json"
                    ]
                )
                .responseData { response in
                    print("HTTP 상태 코드:", response.response?.statusCode ?? 0)
                    if let data = response.data, let str = String(data: data, encoding: .utf8) {
                        print("서버 응답:", str)
                    }
                }
                .responseDecodable(of: CheckTodayUploadResponse.self) { response in
                    switch response.result {
                    case .success(let data):
                        print("업로드 확인 성공:", data.hasUploaded)
                        continuation.resume(returning: data.hasUploaded)
                    case .failure(let error):
                        print("업로드 확인 실패:", error)
                        continuation.resume(throwing: error)
                    }
                }
            }
        } else {
            print("⚠️ 토큰이 없습니다. AuthViewModel에서 토큰 상태를 확인해주세요.")
            // 토큰이 없는 경우 재로그인 필요
            NotificationCenter.default.post(name: Notification.Name("LogoutNotification"), object: nil)
            throw AFError.explicitlyCancelled
        }
    }
}

