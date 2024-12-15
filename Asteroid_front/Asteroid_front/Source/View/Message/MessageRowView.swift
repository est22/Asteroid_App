import SwiftUI

struct MessageRowView: View {
  var message: Message
  var chatId: Int
  
  var isSent: Bool {
    return message.senderUserId == chatId
  }
  
  var body: some View {
    VStack(alignment: .leading, spacing: 8) {
      // 상단 부분
      HStack {
        Text(isSent ? "받은쪽지" : "보낸쪽지")
          .font(.subheadline)
          .foregroundColor(isSent ? Color.keyColor : Color.color1)
        
        Spacer()
        
        Text(formatDate(message.createdAt))
          .font(.subheadline)
          .foregroundColor(.gray)
      }
      
      // 내용
      Text(message.content)
        .font(.body)
        .foregroundColor(.primary)
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    .padding(10)
  }
  
  // 날짜 포맷
  func formatDate(_ dateString: String) -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
    if let date = formatter.date(from: dateString) {
      formatter.dateFormat = "yyyy-MM-dd HH:mm"
      return formatter.string(from: date)
    }
    return dateString // 변환 실패 시 원본 반환
  }
}

#Preview {
  MessageRowView(message: Message(id: 1, content: "안녕하세요, 잘 지내세요?", senderUserId: 1, receiverUserId: 2, isRead: false, createdAt: "2024-12-15 12:30", updatedAt: "2024-12-15 12:31", receiver: MessageUser(id: 2, nickname: "test", profilePhoto: "url")), chatId: 1)
}
