import SwiftUI
import Alamofire

class MyPageViewModel: ObservableObject {
    @Published var posts: [Post] = []
    @Published var votes: [BalanceVote] = []
    @Published var comments: [Comment] = []
    @Published var errorMessage: String = ""

    private var isLoading = false
    private let endPoint = APIConstants.baseURL

    // 게시물 목록 가져오기
    func fetchMyPosts() {
        guard !isLoading else { return }
        isLoading = true
        let url = "\(endPoint)/settings/posts"
        guard let token = UserDefaults.standard.string(forKey: "accessToken") else { return }
        let headers: HTTPHeaders = ["Authorization": "Bearer \(token)"]
        
        AF.request(url, method: .get, headers: headers)
            .response { response in
                self.isLoading = false
                
                if let statusCode = response.response?.statusCode {
                  
                    switch statusCode {
                    case 200..<300:
                        if let data = response.data {
                            do {
                                let root = try JSONDecoder().decode(MyPosts.self, from: data)
                                self.posts = root.posts
                                self.votes = root.balanceVotes
                            } catch {
                                self.errorMessage = "Error decoding data: \(error.localizedDescription)"
                              print("@@@@$$$$    ", error)
                            }
                        }
                    default:
                        self.errorMessage = "Error: \(statusCode)"
                    }
                }
            }
    }

    // 댓글 목록 가져오기
    func fetchMyComments() {
        guard !isLoading else { return }
        isLoading = true
        let url = "\(endPoint)/settings/comments"
        guard let token = UserDefaults.standard.string(forKey: "accessToken") else { return }
        let headers: HTTPHeaders = ["Authorization": "Bearer \(token)"]

        AF.request(url, method: .get, headers: headers)
            .response { response in
                self.isLoading = false

                if let statusCode = response.response?.statusCode {
                    switch statusCode {
                    case 200..<300:
                        if let data = response.data {
                            do {
                                let decoded = try JSONDecoder().decode([Comment].self, from: data)
                                self.comments.append(contentsOf: decoded)
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
