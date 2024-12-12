import Foundation
import Alamofire
import SwiftUI

@MainActor
class ProfileViewModel: ObservableObject {
    // MARK: - Published Properties
    @Published var nickname: String = ""
    @Published var motto: String = ""
    @Published var profilePhoto: String?
    @Published var profileImage: Image?
    @Published var isLoading: Bool = false
    @Published var profileErrorMessage: String = ""
    @Published var isNicknameAvailable: Bool = false
    @Published var isNicknameChecked: Bool = false
    @Published var mottoShakeOffset: CGFloat = 0
    @Published var isMottoExceeded: Bool = false
    
    // MARK: - Profile Methods
    @MainActor
func fetchProfile() async throws {
    guard let accessToken = UserDefaults.standard.string(forKey: "accessToken") else { return }
    
    let headers: HTTPHeaders = ["Authorization": "Bearer \(accessToken)"]
    
    let response = try await AF.request("\(APIConstants.baseURL)/profile",
                                      headers: headers)
        .serializingDecodable(ProfileResponse.self)
        .value
    
    print("=== 프로필 응답 ===")
    print(response)
    
    self.nickname = response.data.nickname
    self.motto = response.data.motto
    self.profilePhoto = response.data.profilePhoto 

    
    if let photoURLString = response.data.profilePhoto,
       let photoURL = URL(string: photoURLString) {
        print("프로필 사진 URL: \(photoURL)")
        let (data, _) = try await URLSession.shared.data(from: photoURL)
        if let uiImage = UIImage(data: data) {
            print("이미지 로드 성공")
            self.profileImage = Image(uiImage: uiImage)
        }
    }
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
        
        isLoading = true
        
        do {
            let response = try await AF.request("\(APIConstants.baseURL)/profile/update-profile",
                                                method: .post,
                                                parameters: parameters,
                                                encoding: JSONEncoding.default,
                                                headers: headers)
                .serializingDecodable(UpdateProfileResponse.self)
                .value
            
            print("프로필 업데이트 성공: \(response.message)")
            try await fetchProfile()
            
        } catch {
            print("프로필 업데이트 실패: \(error)")
            throw error
        }
        
        isLoading = false
    }
    
    func uploadProfilePhoto(imageData: Data) async {
    print("===== 프로필 사진 업로드 시작 =====")
    guard let accessToken = UserDefaults.standard.string(forKey: "accessToken") else {
        print("❌ accessToken 없음")
        return 
    }
    
    let headers: HTTPHeaders = [
        "Authorization": "Bearer \(accessToken)"
    ]
    print("📤 요청 헤더: \(headers)")
    print("📦 이미지 데이터 크기: \(imageData.count) bytes")
    
    AF.upload(
        multipartFormData: { multipartFormData in
            multipartFormData.append(
                imageData,
                withName: "images",
                fileName: "profile.jpg",
                mimeType: "image/jpeg"
            )
            print("✅ 멀티파트 폼 데이터 생성 완료")
        },
        to: "\(APIConstants.baseURL)/profile/upload-photo",
        headers: headers
    )
    .uploadProgress { progress in
        print("📈 업로드 진행률: \(progress.fractionCompleted * 100)%")
    }
    .responseDecodable(of: UpdateProfileResponse.self) { [weak self] response in
        print("\n===== 서버 응답 =====")
        if let request = response.request {
            print("🌐 요청 URL: \(request.url?.absoluteString ?? "")")
            print("📋 요청 헤더: \(request.headers)")
        }
        
        switch response.result {
        case .success(let result):
            print("✅ 업로드 성공: \(result.message)")
            Task { [weak self] in
                try? await self?.fetchProfile()
            }
        case .failure(let error):
            print("❌ 업로드 실패: \(error)")
            if let data = response.data, let str = String(data: data, encoding: .utf8) {
                print("📝 서버 응답 데이터: \(str)")
            }
            print("🔍 에러 상세: \(error.localizedDescription)")
        }
        print("===== 프로필 사진 업로드 종료 =====\n")
    }
}
        func deleteProfilePhoto() async throws {
        guard let accessToken = UserDefaults.standard.string(forKey: "accessToken") else { return }
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(accessToken)"
        ]
        
        try await AF.request(
            "\(APIConstants.baseURL)/profile/delete-photo",
            method: .delete,
            headers: headers
        )
        .serializingDecodable(UpdateProfileResponse.self)
        .value
    }

        // MARK: - Validation Methods
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
                
                await MainActor.run {
                    self.isNicknameChecked = true
                    if response.message == "사용 가능한 닉네임입니다." {
                        self.isNicknameAvailable = true
                        self.profileErrorMessage = response.message
                    } else {
                        self.isNicknameAvailable = false
                        self.profileErrorMessage = response.message
                    }
                }
                
            } catch {
                await MainActor.run {
                    self.isNicknameChecked = true
                    self.isNicknameAvailable = false
                    self.profileErrorMessage = "닉네임 중복 확인 중 오류가 발생했습니다."
                }
            }
        }
        
        func validateMotto(_ newValue: String) {
            if newValue.count > 30 {
                isMottoExceeded = true
                motto = String(newValue.prefix(31))
                shakeMottoField()
            } else {
                isMottoExceeded = false
            }
        }
        
        func shakeMottoField() {
            withAnimation(.default) {
                mottoShakeOffset = 10
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                withAnimation(.default) {
                    self.mottoShakeOffset = -10
                }
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                withAnimation(.default) {
                    self.mottoShakeOffset = 0
                }
            }
        }
    }
    

