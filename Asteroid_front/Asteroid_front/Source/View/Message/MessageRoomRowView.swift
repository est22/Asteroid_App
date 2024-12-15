import SwiftUI

struct MessageRoomRowView: View {
  var room: MessageRoom
  
  var body: some View {
    HStack(spacing: 16) {
      // 대화상대 프로필 사진
      AsyncImage(url: URL(string: room.chatUser.profilePhoto)) { image in
        image.resizable()
          .scaledToFill()
          .clipShape(Circle())
      } placeholder: {
        // 로딩 중 이미지
        Image(systemName: "person")
          .clipShape(Circle())
      }
      .frame(width: 50, height: 50)
      
      VStack(alignment: .leading, spacing: 4) {
        // 대화상대 닉네임
        Text("\(room.chatUser.nickname)")
          .font(.headline)
          .foregroundColor(.primary)
        
        // 최근 메시지
        Text("\(room.latestMessage)")
          .font(.subheadline)
          .foregroundColor(.secondary)
          .lineLimit(1)
      }
      
      Spacer()
      
      // 안 읽은 쪽지 수
      if let unreadCount = Int(room.unRead), unreadCount > 0 {
        ZStack {
          Circle()
            .fill(Color.keyColor)
            .frame(width: 24, height: 24)
          
          Text("\(room.unRead)")
            .font(.caption)
            .foregroundColor(.white)
        }
      }
    }
    .padding(10)
  }
}

#Preview {
  MessageRoomRowView(room: MessageRoom(
    chatUser: MessageUser(id: 2, nickname: "test", profilePhoto: "https://i.pinimg.com/736x/41/8d/60/418d606455b307b0552c41e97feabfa3.jpg"),
    latestMessage: "ㅇㅇㅇ", latestTime: "20241010", unRead: "1"))
}
