import SwiftUI
import Alamofire

// 응답 모델 추가
struct NewPostResponse: Codable {
    let message: String
    let data: Post
}

class PostViewModel: ObservableObject {
  @Published var posts: [Post] = []
  @Published var commentCount: Int = 0  // 댓글 갯수
  @Published var message: String? = nil
  @Published var isFetchError = false
  @Published var isLoading = false
  private var page = 1
  private var morePosts = true
  private let endPoint = APIConstants.baseURL 
  
  // 게시물 목록 조회
  func fetchPosts(categoryID: Int, search: String) async {
    guard !isLoading, morePosts else { return }
    
    await MainActor.run {
        isLoading = true
    }
    
    guard let token = UserDefaults.standard.string(forKey: "accessToken") else { return }
    
    let url = "\(endPoint)/post"
    let params: Parameters = ["category_id": categoryID, "search": search, "page": page]
    let headers: HTTPHeaders = ["Authorization": "Bearer \(token)", "Content-Type":"application/json"]
    
    return await withCheckedContinuation { continuation in
        AF.request(url, method: .get, parameters: params, encoding: URLEncoding.default, headers: headers)
            .response { [weak self] response in
                if let statusCode = response.response?.statusCode {
                    switch statusCode {
                    case 200..<300:
                        if let data = response.data {
                            do {
                                let root = try JSONDecoder().decode(PostRoot.self, from: data)
                                Task { @MainActor in
                                    self?.posts = root.data.rows
                                    
                                    if self?.posts.isEmpty ?? true {
                                        self?.isFetchError = true
                                        self?.message = "등록된 게시물이 없습니다"
                                        self?.morePosts = false
                                    } else {
                                        self?.page += 1
                                    }
                                }
                            } catch let error {
                                Task { @MainActor in
                                    self?.isFetchError = true
                                    self?.message = error.localizedDescription
                                }
                                print("###   에러  ", error)
                            }
                        }
                    case 300..<600:
                        self?.isFetchError = true
                        if let data = response.data {
                            do {
                                let apiError = try JSONDecoder().decode(PostRoot.self, from: data)
                                self?.message = apiError.message ?? "에러가 발생했습니다."
                            } catch let error {
                                self?.message = error.localizedDescription
                                print("###  에러  \(error)")
                            }
                        }
                    default:
                        self?.isFetchError = true
                        self?.message = "알 수 없는 에러가 발생했습니다."
                    }
                }
                Task { @MainActor in
                    self?.isLoading = false
                    continuation.resume()
                }
            }
    }
  }
  
  // 게시글 상세보기
  func fetchPostDetail(postID: Int) async {
    guard !isLoading else { return }
    
    await MainActor.run {
        isLoading = true
    }
    
    guard let token = UserDefaults.standard.string(forKey: "accessToken") else { return }
    
    let url = "\(endPoint)/post/\(postID)"
    let headers: HTTPHeaders = ["Authorization": "Bearer \(token)"]
    
    return await withCheckedContinuation { continuation in
        AF.request(url, method: .get, headers: headers)
            .responseDecodable(of: PostDetail.self) { [weak self] response in
                if let detail = response.value {
                  
                  print("###   뷰모델    ", detail)
                  
                    Task { @MainActor in
                        // posts 배열이 비어있을 수 있으므로, 없으면 추가
                        if self?.posts.firstIndex(where: { $0.id == postID }) == nil {
                            self?.posts.append(detail.data)
                        } else {
                            // 있으면 업데이트
                            if let index = self?.posts.firstIndex(where: { $0.id == postID }) {
                                self?.posts[index] = detail.data
                            }
                        }
                        self?.commentCount = detail.commentCount
                        self?.isLoading = false
                    }
                }
                continuation.resume()
            }
    }
  }
  
  // 게시물 추가
  func addPost(title: String, content: String, categoryID: Int, images: [UIImage]?) async -> Int? {
    let formData = MultipartFormData()
    formData.append(title.data(using: .utf8)!, withName: "title")
    formData.append(content.data(using: .utf8)!, withName: "content")
    formData.append("\(categoryID)".data(using: .utf8)!, withName: "category_id")
    
    // 이미지 데이터 추가
    if let images = images {
        if !images.isEmpty {
            for (index, image) in images.enumerated() {
                if let imageData = image.jpegData(compressionQuality: 0.2) {
                    formData.append(
                        imageData,
                        withName: "images",
                        fileName: "photo\(index).jpg",
                        mimeType: "image/jpeg"
                    )
                }
            }
        }
    }
    
    guard let token = UserDefaults.standard.string(forKey: "accessToken") else { return nil }
    let headers: HTTPHeaders = [
        "Authorization": "Bearer \(token)",
        "Content-Type": "multipart/form-data"
    ]
    let url = "\(endPoint)/post"
    
    return await withCheckedContinuation { (continuation: CheckedContinuation<Int?, Never>) in
        AF.upload(multipartFormData: formData, to: url, method: .post, headers: headers)
            .response { [weak self] response in
                if let statusCode = response.response?.statusCode {
                    switch statusCode {
                    case 200..<300:
                        if let data = response.data {
                            do {
                                let newPostResponse = try JSONDecoder().decode(NewPostResponse.self, from: data)
                                Task { @MainActor in
                                    if newPostResponse.data.categoryID == categoryID {
                                        self?.posts.insert(newPostResponse.data, at: 0)
                                        print("새 포스트 추가됨: \(newPostResponse.data)")
                                        print("포스트 이미지: \(String(describing: newPostResponse.data.PostImages))")
                                    }
                                }
                                // 새 포스트의 ID 반환
                                continuation.resume(returning: newPostResponse.data.id)
                            } catch let error {
                                print("Decoding error: \(error)")
                                continuation.resume(returning: nil)
                            }
                        }
                    default:
                        Task { @MainActor in
                            self?.message = "게시글 작성에 실패했습니다."
                        }
                        continuation.resume(returning: nil)
                    }
                }
            }
    }
  }
  
  // 게시물 수정
  func updatePost(postId: Int, title: String, content: String, categoryID: Int, images: [UIImage]?) {
    let formData = MultipartFormData()
    formData.append(title.data(using: .utf8)!, withName: "title")
    formData.append(content.data(using: .utf8)!, withName: "content")
    formData.append("\(categoryID)".data(using: .utf8)!, withName: "category_id")
    
    if let images = images {
      for (index, image) in images.enumerated() {
        if let imageData = image.jpegData(compressionQuality: 0.2) {
          formData.append(
            imageData,
            withName: "images[\(index)]",
            fileName: "photo\(index).jpg",
            mimeType: "image/jpeg"
          )
        }
      }
    }
    
    guard let token = UserDefaults.standard.string(forKey: "accessToken") else { return }
    let headers: HTTPHeaders = [
      "Authorization": "Bearer \(token)",
      "Content-Type": "multipart/form-data"
    ]
    let url = "\(endPoint)/post/\(postId)"
    
    AF.upload(multipartFormData: formData, to: url, method: .put, headers: headers).response { response in
      if let statusCode = response.response?.statusCode {
        switch statusCode {
        case 200..<300:
          if let data = response.data {
            do {
              let root = try JSONDecoder().decode(PostRoot.self, from: data)
              self.message = root.message!
            } catch let error {
              self.message = error.localizedDescription
            }
          }
        default:
          self.message = "알 수 없는 에러"
        }
      }
    }
  }
  
  // 게시물 삭제
  func deletePost(postId: Int) {
    guard let token = UserDefaults.standard.string(forKey: "accessToken") else { return }
    let headers: HTTPHeaders = ["Authorization": "Bearer \(token)"]
    let url = "\(endPoint)/post/\(postId)"
    
    AF.request(url, method: .delete, headers: headers)
      .response { response in
        if let statusCode = response.response?.statusCode {
          switch statusCode {
          case 200..<300:
            self.message = "게시물이 삭제되었습니다."
            self.posts.removeAll { $0.id == postId }
          default:
            self.message = "알 수 없는 에러"
          }
        }
      }
  }
}

// JSON 프린트를 위한 확장
extension Data {
    var prettyPrintedJSONString: String? {
        guard let object = try? JSONSerialization.jsonObject(with: self, options: []),
              let data = try? JSONSerialization.data(withJSONObject: object, options: [.prettyPrinted]),
              let prettyPrintedString = String(data: data, encoding: .utf8) else { return nil }
        return prettyPrintedString
    }
}

