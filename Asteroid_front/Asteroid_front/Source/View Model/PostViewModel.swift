import SwiftUI
import Alamofire

class PostViewModel: ObservableObject {
    @Published var posts: [Post] = []
    @Published var message: String? = nil
    @Published var isFetchError = false
    @Published var isLoading = false
    private var page = 1
    private var morePosts = true
    private let endPoint = APIConstants.baseURL
    
    @AppStorage("token") var token: String?
    
    // 게시물 목록 조회
    func fetchPosts(categoryID: Int, search:String) {
        guard !isLoading, morePosts else { return }
        isLoading = true
        guard let token = UserDefaults.standard.string(forKey: "accessToken") else { return }

        let url = "\(endPoint)/post"
        let params: Parameters = ["category_id": categoryID, "search": search, "page": page]
        let headers: HTTPHeaders = ["Authorization": "Bearer \(token)", "Content-Type":"application/json"]
        
        AF.request(url, method: .get, parameters: params, encoding: URLEncoding.default, headers: headers)
            .response { response in
                if let statusCode = response.response?.statusCode {
                    
                    switch statusCode {
                        case 200..<300:
                            if let data = response.data {
                                do {
                                    let root = try JSONDecoder().decode(PostRoot.self, from: data)
                                    
                                    self.posts = root.data.rows
                                    
                                    if self.posts.isEmpty {
                                        self.isFetchError = true
                                        self.message = "등록된 게시물이 없습니다"
                                        self.morePosts = false
                                    } else {
                                        self.posts.append(contentsOf: root.data.rows)
                                        self.page += 1
                                    }
                                } catch let error {
                                    self.isFetchError = true
                                    self.message = error.localizedDescription
                                    
                                    print("###   에러  ", error)
                                }
                            }
                        case 300..<600:
                            self.isFetchError = true
                            if let data = response.data {
                                do {
                                    let apiError = try JSONDecoder().decode(PostRoot.self, from: data)
                                    self.message = apiError.message!
                                } catch let error {
                                    self.message = error.localizedDescription
                                    print("###   에러  ", error)
                                }
                            }
                        default:
                            self.isFetchError = true
                            self.message = "알 수 없는 에러"
                    }
                }
                self.isLoading = false
            }
    }
    
    // 게시글 상세보기
    func fetchPostDetail(postID: Int) {
        guard !isLoading else { return }
        isLoading = true
        guard let token = UserDefaults.standard.string(forKey: "accessToken") else { return }
        
        let url = "\(endPoint)/post/\(postID)"
        let headers: HTTPHeaders = ["Authorization": "Bearer \(token)", "Content-Type": "application/json"]
        
        AF.request(url, method: .get, headers: headers)
            .response { response in
                if let statusCode = response.response?.statusCode {
                    switch statusCode {
                    case 200..<300:
                        if let data = response.data {
                            do {
                                let detailedPost = try JSONDecoder().decode(Post.self, from: data)
                                if let index = self.posts.firstIndex(where: { $0.id == postID }) {
                                    // 이미 목록에 있는 게시글이라면 업데이트
                                    self.posts[index] = detailedPost
                                } else {
                                    // 새로운 게시글이라면 추가
                                    self.posts.append(detailedPost)
                                }
                            } catch let error {
                                self.isFetchError = true
                                self.message = error.localizedDescription
                                print("### 디코딩 에러: \(error)")
                            }
                        }
                    case 300..<600:
                        self.isFetchError = true
                        if let data = response.data {
                            do {
                                let apiError = try JSONDecoder().decode(PostRoot.self, from: data)
                                self.message = apiError.message ?? "에러가 발생했습니다."
                            } catch let error {
                                self.message = error.localizedDescription
                                print("### 에러 디코딩 실패: \(error)")
                            }
                        }
                    default:
                        self.isFetchError = true
                        self.message = "알 수 없는 에러가 발생했습니다."
                    }
                }
                self.isLoading = false
            }
    }
    
    // 게시물 추가
    func addPost(title: String, content: String, categoryID: Int, userID: Int, images: [UIImage]?) {
        let userId = UserDefaults.standard.string(forKey: "user_id")
        let formData = MultipartFormData()
        formData.append(title.data(using: .utf8)!, withName: "title")
        formData.append(content.data(using: .utf8)!, withName: "content")
        formData.append("\(categoryID)".data(using: .utf8)!, withName: "category_id")
        formData.append(userId!.data(using: .utf8)!, withName: "user_id")
        
        // 이미지 데이터 추가
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
        let url = "\(endPoint)/post"
        
        AF.upload(multipartFormData: formData, to: url, headers: headers).response { response in
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
                case 300..<600:
                    if let data = response.data {
                        do {
                            let apiError = try JSONDecoder().decode(PostRoot.self, from: data)
                            self.message = apiError.message!
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

    // 게시물 수정
    func updatePost(postId: Int, title: String, content: String, categoryID: Int, userID: Int, images: [UIImage]?) {
        let formData = MultipartFormData()
        formData.append(title.data(using: .utf8)!, withName: "title")
        formData.append(content.data(using: .utf8)!, withName: "content")
        formData.append("\(categoryID)".data(using: .utf8)!, withName: "category_id")
        formData.append("\(userID)".data(using: .utf8)!, withName: "user_id")
        
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
        
        AF.upload(multipartFormData: formData, to: url, headers: headers).response { response in
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

// 샘플 데이터
extension PostViewModel {
    func loadSampleData() {
        let sampleUser = User(id: 1, email: "user@example.com", nickname: "JohnDoe", motto: "Live life!", profilePhoto: "https://via.placeholder.com/100")

        let samplePosts = [
            Post(
                id: 1,
                title: "Sample Post Title 1",
                content: "This is the content of the sample post 1.This is the content of the sample post 1.This is the content of the sample post 1.",
                categoryID: 1,
                userID: 1,
                isShow: true,
                likeTotal: 15,
                PostImages: [PostImage(id: 1, imageURL: "https://via.placeholder.com/150", postID: 1)],
                commentTotal: 5,
                createdAt: "20241111",
                updatedAt: "20241111",
                user: sampleUser
            ),
            Post(
                id: 2,
                title: "Sample Post Title 2",
                content: "This is the content of the sample post 2.",
                categoryID: 1,
                userID: 1,
                isShow: true,
                likeTotal: 10,
                PostImages: [],
                commentTotal: 3,
                createdAt: "20241112",
                updatedAt: "20241112",
                user: sampleUser
            )
        ]

        self.posts = samplePosts
    }
}
