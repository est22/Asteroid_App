// ViewModels/AuthViewModel.swift
import Foundation
import Combine
import Alamofire

class AuthViewModel: ObservableObject {
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
    
    private let baseURL = "http://localhost:3000/auth"
    private var emailCheckCancellable: AnyCancellable? // combine 구독 저장 및 관리하기 위한 프로퍼티
    
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
        isPasswordMatching = password == confirmPassword
    }
    
    var canRegister: Bool {
        return isEmailValid && isPasswordMatching && !password.isEmpty && !email.isEmpty
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
}

