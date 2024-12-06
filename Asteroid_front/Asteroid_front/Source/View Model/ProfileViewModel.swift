import Foundation
import Alamofire

@MainActor
class ProfileViewModel: ObservableObject {
    // MARK: - Published Properties
    @Published var nickname: String = ""
    @Published var motto: String = ""
    @Published var profilePhoto: String?
    @Published var isLoading: Bool = false
    @Published var profileErrorMessage: String = ""
    @Published var isNicknameAvailable: Bool = false
    @Published var isNicknameChecked: Bool = false

    
    // MARK: - Profile Methods
    func fetchProfile() async {
        guard let accessToken = UserDefaults.standard.string(forKey: "accessToken") else { return }
        
        let headers: HTTPHeaders = ["Authorization": "Bearer \(accessToken)"]
        isLoading = true
        
        do {
            let response = try await AF.request("\(APIConstants.baseURL)/profile",
                                             method: .get,
                                             headers: headers)
                .serializingDecodable(ProfileResponse.self)
                .value
            
            nickname = response.data.nickname
            motto = response.data.motto
            profilePhoto = response.data.profilePhoto
            
        } catch {
            print("Profile fetch error: \(error)")
            profileErrorMessage = error.localizedDescription
        }
        
        isLoading = false
    }
    
    func updateProfile(nickname: String, motto: String) async throws {
        guard let accessToken = UserDefaults.standard.string(forKey: "accessToken") else { return }
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(accessToken)",
            "Content-Type": "application/json"
        ]
        
        let parameters: [String: Any] = [
            "nickname": nickname,
            "motto": motto
        ]
        
        do {
            let response = try await AF.request("\(APIConstants.baseURL)/profile/update-profile",
                                             method: .post,
                                             parameters: parameters,
                                             encoding: JSONEncoding.default,
                                             headers: headers)
                .serializingDecodable(UpdateProfileResponse.self)
                .value
            
            print("프로필 업데이트 성공: \(response.message)")
            await fetchProfile()
            
        } catch {
            print("프로필 업데이트 실패: \(error)")
            throw error
        }
    }
    
    // MARK: - Photo Upload Methods
    func uploadProfilePhoto(imageData: Data) async {
        guard let accessToken = UserDefaults.standard.string(forKey: "accessToken") else { return }
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(accessToken)",
            "Content-Type": "multipart/form-data"
        ]
        
        AF.upload(
            multipartFormData: { multipartFormData in
                multipartFormData.append(
                    imageData,
                    withName: "photo",
                    fileName: "profile.jpg",
                    mimeType: "image/jpeg"
                )
            },
            to: "\(APIConstants.baseURL)/profile/upload-photo",
            headers: headers
        )
        .responseDecodable(of: UpdateProfileResponse.self) { [weak self] response in
            switch response.result {
            case .success(let result):
                print("프로필 사진 업로드 성공: \(result.message)")
                Task { [weak self] in
                    await self?.fetchProfile()
                }
            case .failure(let error):
                print("프로필 사진 업로드 실패: \(error)")
            }
        }
    }
    
    // MARK: - Nickname Validation Methods
    func checkNicknameAvailability(_ nickname: String) async {
        guard let accessToken = UserDefaults.standard.string(forKey: "accessToken") else { return }
        
        let headers: HTTPHeaders = ["Authorization": "Bearer \(accessToken)"]
        
        do {
            let response = try await AF.request("\(APIConstants.baseURL)/profile/check-nickname",
                                             method: .post,
                                             parameters: ["nickname": nickname],
                                             encoding: JSONEncoding.default,
                                             headers: headers)
                .serializingDecodable(NicknameCheckResponse.self)
                .value
            
            isNicknameChecked = true
            isNicknameAvailable = true
            profileErrorMessage = ""
            
        } catch {
            isNicknameChecked = true
            isNicknameAvailable = false
            profileErrorMessage = "이미 사용 중인 닉네임입니다."
        }
    }
}

