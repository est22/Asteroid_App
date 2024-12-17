import Foundation
import Alamofire

class CommentViewModel: ObservableObject {
    @Published var comments: [Comment] = []
    @Published var message = ""
    @Published var errorMessage: String? = nil
    @Published var isLoading: Bool = false
    private let endPoint = APIConstants.baseURL

    // 댓글 조회
    func fetchComments(postId: Int) {
        isLoading = true
        let url = "\(endPoint)/comment/\(postId)"

        AF.request(url, method: .get).validate().responseDecodable(of: CommentRoot.self) { response in
            self.isLoading = false
          
          print("####   response ", response)
          
          
            switch response.result {
              case .success(let commentRoot):
                  self.comments = commentRoot.data
              case .failure(let error):
                  self.errorMessage = error.localizedDescription
            }
        }
    }

    // 댓글 생성
    func createComment(content: String, postId: Int) {
        let url = "\(endPoint)/comment"
        let parameters: [String: Any] = ["content": content]

        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default)
            .validate()
            .responseDecodable(of: Comment.self) { response in
                switch response.result {
                  case .success(let newComment):
                      self.comments.append(newComment)
                  case .failure(let error):
                      self.errorMessage = error.localizedDescription
                }
            }
    }

    // 댓글 수정
    func updateComment(commentId: Int, content: String) {
        let url = "\(endPoint)/comment/\(commentId)"
        let parameters: [String: Any] = [
            "content": content
        ]

        AF.request(url, method: .put, parameters: parameters, encoding: JSONEncoding.default)
            .validate()
            .responseDecodable(of: Comment.self) { response in
                switch response.result {
                    case .success(let updatedComment):
                        if let index = self.comments.firstIndex(where: { $0.id == updatedComment.id }) {
                            self.comments[index] = updatedComment
                        }
                    case .failure(let error):
                        self.errorMessage = error.localizedDescription
                }
            }
    }

    // 댓글 삭제
    func deleteComment(commentId: Int) {
        let url = "\(endPoint)/comment/\(commentId)"
        guard let token = UserDefaults.standard.string(forKey: "accessToken") else { return }
        let headers: HTTPHeaders = ["Authorization": "Bearer \(token)"]
        
        AF.request(url, method: .delete, headers: headers).response { response in
            if let statusCode = response.response?.statusCode {
                self.message = statusCode == 200 ? "Vote deleted successfully!" : "Error: \(statusCode)"
            }
        }
    }

    // 댓글 좋아요
    func likeComment(commentId: Int, userId: Int) {
        let url = "\(endPoint)/comment/\(commentId)/like"

        AF.request(url, method: .post, encoding: JSONEncoding.default)
            .responseDecodable(of: Comment.self) { response in
                switch response.result {
                    case .success(let updatedComment):
                        if let index = self.comments.firstIndex(where: { $0.id == updatedComment.id }) {
                            self.comments[index] = updatedComment
                        }
                    case .failure(let error):
                        self.errorMessage = error.localizedDescription
                }
            }
    }
}
