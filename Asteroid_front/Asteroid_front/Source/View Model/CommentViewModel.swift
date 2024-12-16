import Foundation
import Combine

class CommentViewModel: ObservableObject {
    @Published var comments: [Comment] = []
    @Published var errorMessage: String? = nil
    @Published var isLoading: Bool = false
    
    private var cancellables = Set<AnyCancellable>()
    
    // 댓글 조회
    func fetchComments(forPost postId: Int) {
        self.isLoading = true
        let url = "https://yourapi.com/posts/\(postId)/comments"
        guard let url = URL(string: url) else { return }
        
        URLSession.shared.dataTaskPublisher(for: url)
            .map { $0.data }
            .decode(type: [Comment].self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                switch completion {
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                case .finished:
                    break
                }
                self?.isLoading = false
            } receiveValue: { [weak self] comments in
                self?.comments = comments
            }
            .store(in: &cancellables)
    }
    
    // 댓글 생성
    func createComment(content: String, postId: Int, userId: Int) {
        let url = "https://yourapi.com/posts/\(postId)/comments"
        guard let url = URL(string: url) else { return }
        
        let commentData = [
            "content": content,
            "user_id": userId
        ] as [String : Any]
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONSerialization.data(withJSONObject: commentData)
        
        URLSession.shared.dataTaskPublisher(for: request)
            .map { $0.data }
            .decode(type: Comment.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                if case .failure(let error) = completion {
                    self?.errorMessage = error.localizedDescription
                }
            } receiveValue: { [weak self] comment in
                self?.comments.append(comment)
            }
            .store(in: &cancellables)
    }
    
    // 댓글 수정
    func updateComment(commentId: Int, content: String) {
        let url = "https://yourapi.com/comments/\(commentId)"
        guard let url = URL(string: url) else { return }
        
        let commentData = [
            "content": content
        ]
        
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONSerialization.data(withJSONObject: commentData)
        
        URLSession.shared.dataTaskPublisher(for: request)
            .map { $0.data }
            .decode(type: Comment.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                if case .failure(let error) = completion {
                    self?.errorMessage = error.localizedDescription
                }
            } receiveValue: { [weak self] updatedComment in
                if let index = self?.comments.firstIndex(where: { $0.id == updatedComment.id }) {
                    self?.comments[index] = updatedComment
                }
            }
            .store(in: &cancellables)
    }
    
    // 댓글 삭제
    func deleteComment(commentId: Int) {
        let url = "https://yourapi.com/comments/\(commentId)"
        guard let url = URL(string: url) else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        
        URLSession.shared.dataTaskPublisher(for: request)
            .map { $0.data }
            .decode(type: Comment.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                if case .failure(let error) = completion {
                    self?.errorMessage = error.localizedDescription
                }
            } receiveValue: { [weak self] deletedComment in
                self?.comments.removeAll { $0.id == deletedComment.id }
            }
            .store(in: &cancellables)
    }
    
    // 댓글 좋아요
    func likeComment(commentId: Int, userId: Int) {
        let url = "https://yourapi.com/comments/\(commentId)/like"
        guard let url = URL(string: url) else { return }
        
        let likeData = [
            "user_id": userId
        ]
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONSerialization.data(withJSONObject: likeData)
        
        URLSession.shared.dataTaskPublisher(for: request)
            .map { $0.data }
            .decode(type: Comment.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                if case .failure(let error) = completion {
                    self?.errorMessage = error.localizedDescription
                }
            } receiveValue: { [weak self] updatedComment in
                if let index = self?.comments.firstIndex(where: { $0.id == updatedComment.id }) {
                    self?.comments[index] = updatedComment
                }
            }
            .store(in: &cancellables)
    }
}
