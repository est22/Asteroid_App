import SwiftUI
import Alamofire

class BalanceVoteViewModel: ObservableObject {
    @Published var votes: [BalanceVote] = []
    @Published var message = ""
    @Published var isFetchError = false

    private var isLoading = false
    private let endPoint = APIConstants.baseURL

    // 투표 목록 가져오기
    func fetchVotes() {
        guard !isLoading else { return }
        isLoading = true
        let url = "\(endPoint)/balance"
        guard let token = UserDefaults.standard.string(forKey: "accessToken") else { return }
        let headers: HTTPHeaders = ["Authorization": "Bearer \(token)"]

        AF.request(url, method: .get, headers: headers)
            .response { response in
                self.isLoading = false
                if let statusCode = response.response?.statusCode {
                    
                    print("=== 밸런스 투표 ===")
                    print("###  Response Data: \(String(data: response.data!, encoding: .utf8) ?? "")")
                    print("###  statusCode   ", statusCode)
                    
                    switch statusCode {
                    case 200..<300:
                        if let data = response.data {
                            do {
                                let root = try JSONDecoder().decode(BalanceVoteRoot.self, from: data)
                                self.votes = root.data.rows
                            } catch let error {
                                self.isFetchError = true
                                self.message = error.localizedDescription
                                
                                print("###   에러  ", error)
                            }
                        }
                    default:
                        self.isFetchError = true
                        self.message = "Error: \(statusCode)"
                    }
                }
            }
    }

    // 새 투표 추가
    func addVote(title: String, description: String?, image1: UIImage, image2: UIImage) {
        let formData = MultipartFormData()
        formData.append(title.data(using: .utf8)!, withName: "title")
        if let description = description {
            formData.append(description.data(using: .utf8)!, withName: "description")
        }
        
      // 이미지
      let images: [UIImage] = [image1, image2]
      for image in images {
          formData.append(image.jpegData(compressionQuality: 0.8)!, withName: "images", fileName: "image.jpg", mimeType: "image/jpeg")
      }

      
        guard let token = UserDefaults.standard.string(forKey: "accessToken") else { return }
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(token)",
            "Content-Type": "multipart/form-data"
        ]
        let url = "\(endPoint)/balance"

      AF.upload(multipartFormData: formData, to: url, method: .post, headers: headers).response { response in
            if let statusCode = response.response?.statusCode {
                self.message = statusCode == 200 ? "Vote added successfully!" : "Error: \(statusCode)"
            }
        }
    }

    // 투표 삭제
    func deleteVote(voteId: Int) {
        let url = "\(endPoint)/balance/\(voteId)"
        guard let token = UserDefaults.standard.string(forKey: "accessToken") else { return }
        let headers: HTTPHeaders = ["Authorization": "Bearer \(token)"]

        AF.request(url, method: .delete, headers: headers)
            .response { response in
                if let statusCode = response.response?.statusCode {
                    self.message = statusCode == 200 ? "Vote deleted successfully!" : "Error: \(statusCode)"
                }
            }
    }

    // 투표 결과 제출
    func submitVote(voteId: Int, option: String) {
        let url = "\(endPoint)/balance/\(voteId)/submit"
        guard let token = UserDefaults.standard.string(forKey: "accessToken") else { return }
        let headers: HTTPHeaders = ["Authorization": "Bearer \(token)"]
        let params: Parameters = ["option": option]

        AF.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers)
            .response { response in
                if let statusCode = response.response?.statusCode {
                    self.message = statusCode == 200 ? "Vote submitted successfully!" : "Error: \(statusCode)"
                }
            }
    }
}
