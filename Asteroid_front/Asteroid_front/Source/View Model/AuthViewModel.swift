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
    
    private let baseURL = "http://localhost:3000/auth"
    private var emailCheckCancellable: AnyCancellable? // combine 구독 저장 및 관리하기 위한 프로퍼티
    
    override init() {
        super.init()
        checkAuthStatus()
    }
    
    private func checkAuthStatus() {
        let (accessToken, _) = getTokens()
        if accessToken != nil {
            self.isLoggedIn = true
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
        
        emailCheckCancellable = AF.request("\(baseURL)/check-email",
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
                self.isLoggedIn = true
                self.isInitialProfileSet = loginResponse.isProfileSet // 서버에서 프로필 설정 여부를 받아옴
                
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
        clearState()
    }
    
    func clearState() {
        email = ""
        password = ""
        confirmPassword = ""
        isEmailValid = true
        isPasswordMatching = true
    }
    
    func handleSignInWithApple() {
        let provider = ASAuthorizationAppleIDProvider()
        let request = provider.createRequest()
        request.requestedScopes = [.fullName, .email]
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.performRequests()
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
                  method: .post,  // HTTP 메서드가 올바른지 확인 (GET일 수도 있음)
                  parameters: parameters,
                  encoding: JSONEncoding.default)
            .validate()
            .responseString { [weak self] response in
                print("Response: \(response)")  // 디버깅용
                
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
                        self?.profileErrorMessage = "닉네임 중복 확인에 실패했습니다."
                        completion(false)
                    }
                }
            }
    }
}

// Apple 로그인 델리게이트 구현
extension AuthViewModel: ASAuthorizationControllerDelegate {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            let userId = appleIDCredential.user
            let email = appleIDCredential.email
            
            // 여기서 서버에 Apple 로그인 정보를 전송하고 처리
            print("Apple User ID: \(userId)")
            print("Apple User Email: \(email ?? "No email")")
            
            DispatchQueue.main.async {
                self.isLoggedIn = true
            }
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print("Apple Sign In Error: \(error.localizedDescription)")
    }
}


