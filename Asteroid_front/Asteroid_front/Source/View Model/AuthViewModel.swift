// ViewModels/AuthViewModel.swift
import Foundation
import Combine
import Alamofire
import AuthenticationServices

class AuthViewModel: NSObject, ObservableObject {
    @Published var email = ""
    @Published var password = ""
    @Published var confirmPassword = ""
    @Published var isLoggedIn = false
    @Published var isUserExists = true
    @Published var isEmailValid = true
    @Published var isPasswordMatching = true
    @Published var isLoading = false
    @Published var loginErrorMessage = ""
    @Published var registerErrorMessage = ""
    @Published var isRegistering = false
    @Published var emailErrorMessage = ""
    @Published var isPasswordLengthValid = false      // 8자 이상
    @Published var hasNumber = false                  // 숫자 포함
    @Published var hasSpecialCharacter = false        // 특수문자 포함
    @Published var isInitialProfileSet = false  // 추가
    @Published var profileErrorMessage = ""  // 추가
    @Published var nickname = ""  // 추가
    @Published var motto = ""     // 추가
    @Published var profilePhoto: String?  // 추가
    
    
    private var emailCheckCancellable: AnyCancellable? // combine 구독 저장 및 관리하기 위한 프로퍼티
    private let appleAuthViewModel = AppleAuthViewModel()
    
    override init() {
        super.init()
        checkAuthStatus()
        
        appleAuthViewModel.onLoginSuccess = { [weak self] isProfileSet in
            DispatchQueue.main.async {
                print("Apple login success, isProfileSet: \(isProfileSet)")  // 디버깅용
                self?.isLoggedIn = true
                self?.isInitialProfileSet = isProfileSet
            }
        }
    }
    
    func handleSignInWithApple() {
        appleAuthViewModel.handleSignInWithApple()
    }
    
    private func checkAuthStatus() {
        let (accessToken, _) = getTokens()
        if let accessToken = accessToken, !accessToken.isEmpty {
            self.isLoggedIn = true
            self.isInitialProfileSet = UserDefaults.standard.bool(forKey: "isInitialProfileSet")
        } else {
            self.isLoggedIn = false
        }
    }
    
    private func getTokens() -> (accessToken: String?, refreshToken: String?) {
        let accessToken = UserDefaults.standard.string(forKey: "accessToken")
        let refreshToken = UserDefaults.standard.string(forKey: "refreshToken")
        return (accessToken, refreshToken)
    }
    
    func validateEmail() {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let isValidFormat = NSPredicate(format: "SELF MATCHES %@", emailRegex)
            .evaluate(with: email)
        
        if !isValidFormat {
            isEmailValid = false
            emailErrorMessage = "유효하지 않은 이메일 형식입니다."
            return
        }
        
        emailCheckCancellable?.cancel()
        
        let parameters = ["email": email]
        
        print("Checking email: \(email)")
        
        emailCheckCancellable = AF.request("\(APIConstants.baseURL)/check-email",
                                         method: .post,
                                         parameters: parameters,
                                         encoding: JSONEncoding.default)
            .validate()
            .publishDecodable(type: ErrorResponse.self)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print("Email check error: \(error)")
                    self?.isEmailValid = false
                    self?.emailErrorMessage = "서버 오류가 발생했습니다."
                }
            }, receiveValue: { [weak self] response in
                print("Response Status Code: \(String(describing: response.response?.statusCode))")
                if let data = response.data, let responseString = String(data: data, encoding: .utf8) {
                    print("Response Data: \(responseString)")
                }
                
                if response.response?.statusCode == 400 {
                    self?.isEmailValid = false
                    if let errorMessage = try? JSONDecoder().decode(ErrorResponse.self, from: response.data ?? Data()).message {
                        self?.emailErrorMessage = errorMessage
                    }
                } else {
                    self?.isEmailValid = true
                    self?.emailErrorMessage = "사용 가능한 이메일입니다."
                }
            })
    }
    
    func validatePassword() {
        // 8자 이상 검사
        isPasswordLengthValid = password.count >= 8
        
        // 숫자 포함 검사
        hasNumber = password.range(of: ".*[0-9]+.*", options: .regularExpression) != nil
        
        // 특수문자 포함 검사
        let specialCharacterRegex = ".*[!@#$%^&*()\\-_=+{}|?>.<]+.*"
        hasSpecialCharacter = password.range(of: specialCharacterRegex, options: .regularExpression) != nil
        
        // 비밀번호 확인 일치 검사
        isPasswordMatching = password == confirmPassword && !password.isEmpty
    }
    
    var canRegister: Bool {
        return isEmailValid && 
               isPasswordMatching && 
               !password.isEmpty && 
               !email.isEmpty && 
               isPasswordLengthValid && 
               hasNumber && 
               hasSpecialCharacter
    }

    var canLogin: Bool {
        return !email.isEmpty && !password.isEmpty
    }
    
    func login() {
        isLoading = true
        loginErrorMessage = ""
        
        let parameters: [String: Any] = [
            "email": email,
            "password": password
        ]
        
        AF.request("\(baseURL)/login",
                  method: .post,
                  parameters: parameters,
                  encoding: JSONEncoding.default)
        .responseDecodable(of: LoginResponse.self) { [weak self] response in
            guard let self = self else { return }
            self.isLoading = false
            
            print("Request URL: \(String(describing: response.request?.url))")
            print("Request Body: \(parameters)")
            print("Response Status Code: \(String(describing: response.response?.statusCode))")
            if let data = response.data, let responseString = String(data: data, encoding: .utf8) {
                print("Response Data: \(responseString)")
            }
            
            switch response.result {
            case .success(let loginResponse):
                UserDefaults.standard.set(loginResponse.accessToken, forKey: "accessToken")
                UserDefaults.standard.set(loginResponse.refreshToken, forKey: "refreshToken")
                UserDefaults.standard.set(loginResponse.isProfileSet, forKey: "isInitialProfileSet")
                self.isLoggedIn = true
                self.isInitialProfileSet = loginResponse.isProfileSet
                
            case .failure(let error):
                print("Login Error: \(error.localizedDescription)")
                if let data = response.data,
                   let errorResponse = try? JSONDecoder().decode(ErrorResponse.self, from: data) {
                    self.loginErrorMessage = errorResponse.message
                } else {
                    self.loginErrorMessage = "로그인에 실패했습니다."
                }
            }
        }
    }
    
    func register() {
        isLoading = true
        registerErrorMessage = ""
        
        let parameters = RegisterRequest(
            email: email,
            password: password
        )
        
        AF.request("\(baseURL)/register",
                  method: .post,
                  parameters: parameters,
                  encoder: JSONParameterEncoder.default)
        .responseDecodable(of: RegisterResponse.self) { [weak self] response in
            guard let self = self else { return }
            self.isLoading = false
            
            print("Request URL: \(String(describing: response.request?.url))")
            print("Request Body: \(parameters)")
            print("Response Status Code: \(String(describing: response.response?.statusCode))")
            if let data = response.data, let responseString = String(data: data, encoding: .utf8) {
                print("Response Data: \(responseString)")
            }
            
            switch response.result {
            case .success(let registerResponse):
                print("Successfully registered user: \(registerResponse.data.email)")
                self.confirmPassword = ""
                DispatchQueue.main.async {
                    self.isRegistering = false
                }
                
            case .failure(let error):
                print("Register Error: \(error.localizedDescription)")
                if let data = response.data,
                   let errorResponse = try? JSONDecoder().decode(ErrorResponse.self, from: data) {
                    self.registerErrorMessage = errorResponse.message
                } else {
                    self.registerErrorMessage = "회원가입에 실패했습니다."
                }
            }
        }
    }
    
    func logout() {
        isLoggedIn = false
        UserDefaults.standard.removeObject(forKey: "accessToken")
        UserDefaults.standard.removeObject(forKey: "refreshToken")
        UserDefaults.standard.removeObject(forKey: "isInitialProfileSet")
        clearState()
    }
    
    func clearState() {
        email = ""
        password = ""
        confirmPassword = ""
        isEmailValid = true
        isPasswordMatching = true
    }
    
    func updateInitialProfile(nickname: String, motto: String, completion: @escaping (Bool) -> Void) {
        let parameters = [
            "nickname": nickname,
            "motto": motto
        ]
        
        guard let accessToken = getTokens().accessToken else {
            completion(false)
            return
        }
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(accessToken)"
        ]
        
        AF.request("\(baseURL)/init",
                  method: .post,
                  parameters: parameters,
                  encoding: JSONEncoding.default,
                  headers: headers)
        .response { [weak self] response in
            if let data = response.data,
               let errorResponse = try? JSONDecoder().decode(ErrorResponse.self, from: data) {
                if response.response?.statusCode == 400 {
                    self?.profileErrorMessage = errorResponse.message
                    completion(false)
                    return
                }
            }
            
            if response.response?.statusCode == 200 {
                self?.isInitialProfileSet = true
                self?.profileErrorMessage = ""
                self?.nickname = nickname  // 추가: 프로필 저장 성공시 뷰모델에도 저장
                self?.motto = motto       // 추가: 프로필 저장 성공시 뷰모델에도 저장
                completion(true)
            } else {
                self?.profileErrorMessage = "프로필 설정에 실패했습니다."
                completion(false)
            }
        }
    }
    
    func checkNicknameAvailability(_ nickname: String, completion: @escaping (Bool) -> Void) {
        let url = "\(baseURL)/auth/init"
        let parameters = ["nickname": nickname]
        
        AF.request(url, 
                  method: .post,
                  parameters: parameters,
                  encoding: JSONEncoding.default)
            .validate()
            .responseString { [weak self] response in
                switch response.result {
                case .success(let message):
                    DispatchQueue.main.async {
                        if message == "닉네임 사용 가능" {
                            completion(true)
                        } else {
                            self?.profileErrorMessage = message
                            completion(false)
                        }
                    }
                case .failure(let error):
                    DispatchQueue.main.async {
                        self?.profileErrorMessage = error.localizedDescription
                        completion(false)
                    }
                }
            }
    }
    
    @MainActor
    func uploadProfilePhoto(imageData: Data) async {
        guard let accessToken = getTokens().accessToken else { return }
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(accessToken)",
            "Content-Type": "multipart/form-data"
        ]
        
        print("업로드 시작")  // 디버깅용
        
        do {
            let response = try await withCheckedThrowingContinuation { continuation in
                AF.upload(
                    multipartFormData: { multipartFormData in
                        multipartFormData.append(
                            imageData,
                            withName: "photo",
                            fileName: "profile.jpg",
                            mimeType: "image/jpeg"
                        )
                    },
                    to: "http://localhost:3000/profile/upload-photo",
                    headers: headers
                )
                .responseDecodable(of: UpdateProfileResponse.self) { response in
                    switch response.result {
                    case .success(let value):
                        continuation.resume(returning: value)
                    case .failure(let error):
                        continuation.resume(throwing: error)
                    }
                }
            }
            
            print("프로필 사진 업데이트 성공: \(response.message)")
        } catch {
            print("프로필 사진 업데이트 실패: \(error)")
        }
    }
    
    @MainActor
    func updateProfile(nickname: String, motto: String) async {
        guard let accessToken = getTokens().accessToken else { return }
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(accessToken)"
        ]
        
        let parameters = [
            "nickname": nickname,
            "motto": motto
        ]
        
        AF.request("http://localhost:3000/profile/update-profile",
                  method: .post,
                  parameters: parameters,
                  encoding: JSONEncoding.default,
                  headers: headers)
        .responseDecodable(of: UpdateProfileResponse.self) { [weak self] response in
            switch response.result {
            case .success(let response):
                self?.nickname = nickname
                self?.motto = motto
                print("Profile updated: \(response.message)")
            case .failure(let error):
                print("Failed to update profile: \(error)")
            }
        }
    }
}


