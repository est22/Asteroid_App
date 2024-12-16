import SwiftUI
import Alamofire
 
class MessageViewModel: ObservableObject {
  @Published var messageRooms: [MessageRoom] = []
  @Published var messages: [Message] = []
  @Published var message: String? = nil // 에러메시지
  @Published var isLoading = false
  private let endPoint = APIConstants.baseURL
  
  // 쪽지방 목록 조회
  func fetchMessageRooms() {
    guard let token = UserDefaults.standard.string(forKey: "accessToken") else { return }
    
    let url = "\(endPoint)/message"
    let headers: HTTPHeaders = ["Authorization": "Bearer \(token)"]
    isLoading = true
    
    AF.request(url, method: .get, encoding: URLEncoding.default, headers: headers)
      .response { response in
        if let statusCode = response.response?.statusCode {
          switch statusCode {
            case 200..<300:
              if let data = response.data {
                do {
                  let root = try JSONDecoder().decode(MessageRoomRoot.self, from: data)
                  self.messageRooms = root.data
                  
                  if self.messageRooms.isEmpty {
                    self.message = "등록된 쪽지방이 없습니다"
                  } else {
                    self.messageRooms = root.data
                  }
                } catch let error {
                  self.message = error.localizedDescription
                  print("### 에러", error)
                }
              }
            default:
              self.message = "알 수 없는 에러"
          }
        }
        self.isLoading = false
      }
  }
  
  // 쪽지 상세 조회
  func fetchMessages(chatUserId: Int) {
    guard let token = UserDefaults.standard.string(forKey: "accessToken") else { return }
    
    let url = "\(endPoint)/message/detail"
    let params: Parameters = ["chatUserId": chatUserId]
    let headers: HTTPHeaders = ["Authorization": "Bearer \(token)", "Content-Type": "application/json"]
    
    AF.request(url, method: .get, parameters: params, encoding: URLEncoding.default, headers: headers)
      .response { response in
        if let statusCode = response.response?.statusCode {
          
          switch statusCode {
            case 200..<300:
              if let data = response.data {
                do {
                  let root = try JSONDecoder().decode(MessageRoot.self, from: data)
                  self.messages.append(contentsOf: root.data)
                  
                  if self.messages.isEmpty {
                    self.message = "메시지가 없습니다"
                  }
                  
                } catch let error {
                  self.message = error.localizedDescription
                  print("### 에러", error)
                }
              }
            default:
              self.message = "알 수 없는 에러"
          }
        }
        self.isLoading = false
      }
  }
  
  // 쪽지 보내기
  func sendMessage(chatUserId: Int, content: String) {
    guard let token = UserDefaults.standard.string(forKey: "accessToken") else { return }
    
    let url = "\(endPoint)/message"
    let params: Parameters = ["receiver_user_id": chatUserId, "content": content]
    let headers: HTTPHeaders = ["Authorization": "Bearer \(token)", "Content-Type": "application/json"]
    
    AF.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers)
      .response { response in
        if let statusCode = response.response?.statusCode {
          switch statusCode {
            case 201:
              if let data = response.data {
                do {
                  let successResponse = try JSONDecoder().decode([String: String].self, from: data)
                  self.message = successResponse["message"] ?? "쪽지 전송 성공"
                  
                } catch let error {
                  self.message = error.localizedDescription
                  print("### 에러", error)
                }
              }
            
            default:
              self.message = "알 수 없는 에러"
          }
        }
      }
  }
  
  // 쪽지방 나가기 (로컬)
  func leaveMessageRoomLocal(chatUserId: Int) {
      if let index = messageRooms.firstIndex(where: { $0.chatUser.id == chatUserId }) {
          messageRooms.remove(at: index)
      }

      // 서버와 동기화
      leaveMessageRoom(chatUserId: chatUserId)
  }
  
  // 쪽지방 나가기 (서버)
  func leaveMessageRoom(chatUserId: Int) {
    guard let token = UserDefaults.standard.string(forKey: "accessToken") else { return }
    
    let url = "\(endPoint)/message/left"
    let params: Parameters = ["receiver_user_id": chatUserId]
    let headers: HTTPHeaders = ["Authorization": "Bearer \(token)", "Content-Type": "application/json"]
    
    AF.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers)
      .response { response in
        if let statusCode = response.response?.statusCode {
          switch statusCode {
          case 201:
            self.message = "쪽지방을 성공적으로 나갔습니다."
          case 300..<600:
            if let data = response.data {
              do {
                let apiError = try JSONDecoder().decode(MessageRoot.self, from: data)
                self.message = apiError.message
              } catch let error {
                self.message = error.localizedDescription
                print("### 에러", error)
              }
            }
          default:
            self.message = "알 수 없는 에러"
          }
        }
      }
  }
}
