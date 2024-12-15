import SwiftUI
import Alamofire

class MyPageViewModel: ObservableObject {
    @Published var posts: [Post] = []
    @Published var votes: [BalanceVote] = []
    @Published var comments: [Comment] = []
    @Published var errorMessage: String = ""
    
    @AppStorage("token") var token: String?

    private var isLoading = false
    private var page = 1
    private let endPoint = APIConstants.baseURL

    // 게시물 목록 가져오기
    func fetchMyPosts(size: Int = 10) {
        guard !isLoading else { return }
        isLoading = true
        let url = "\(endPoint)/settings/posts"
        guard let token = UserDefaults.standard.string(forKey: "accessToken") else { return }
        let params: Parameters = ["page": self.page, "size": size]
        let headers: HTTPHeaders = ["Authorization": "Bearer \(token)"]
        
        AF.request(url, method: .get, parameters: params, headers: headers)
            .response { response in
                self.isLoading = false
                
                if let statusCode = response.response?.statusCode {
                    switch statusCode {
                    case 200..<300:
                        if let data = response.data {
                            do {
                                let decoded = try JSONDecoder().decode(MyPosts.self, from: data)
                                self.posts = decoded.posts
                                self.votes = decoded.balanceVotes
                                self.page += 1
                            } catch {
                                self.errorMessage = "Error decoding data: \(error.localizedDescription)"
                            }
                        }
                    default:
                        self.errorMessage = "Error: \(statusCode)"
                    }
                }
            }
    }

    // 댓글 목록 가져오기
    func fetchMyComments(size: Int = 10) {
        guard !isLoading else { return }
        isLoading = true
        let url = "\(endPoint)/settings/comments"
        guard let token = UserDefaults.standard.string(forKey: "accessToken") else { return }
        let params: Parameters = ["page": self.page, "size": size]
        let headers: HTTPHeaders = ["Authorization": "Bearer \(token)"]

        AF.request(url, method: .get, parameters: params, headers: headers)
            .response { response in
                self.isLoading = false

                if let statusCode = response.response?.statusCode {
                    switch statusCode {
                    case 200..<300:
                        if let data = response.data {
                            do {
                                let decoded = try JSONDecoder().decode([Comment].self, from: data)
                                self.comments.append(contentsOf: decoded)
                                self.page += 1
                            } catch {
                                self.errorMessage = "Error decoding data: \(error.localizedDescription)"
                                print("### detailed error : \(error)")
                            }
                        }
                    default:
                        self.errorMessage = "Error: \(statusCode)"
                    }
                }
            }
    }
}
