import SwiftUI

struct MessageListView: View {
  @StateObject private var viewModel = MessageViewModel()
  @State private var messageText: String = ""
  let chatUser: MessageUser
  
  var body: some View {
    VStack {
      // 대화 상대 정보
      if let profilePicture = chatUser.profilePhoto {
          AsyncImage(url: URL(string: profilePicture)) { image in
              image
                  .resizable()
                  .frame(width: 40, height: 40)
                  .clipShape(Circle())
          } placeholder: {
              Image(systemName: "person.circle.fill")
                  .resizable()
                  .frame(width: 40, height: 40)
                  .foregroundColor(.gray)
          }
      } else {
          Image(systemName: "person.circle.fill")
              .resizable()
              .frame(width: 40, height: 40)
              .foregroundColor(.gray)
      }
      
      Text(chatUser.nickname)
        .font(.headline)
        .foregroundColor(.primary)
    }
    
    Divider()
    
    // 쪽지 목록
    ScrollView{
      LazyVStack{
        VStack(spacing: 0) {
          ForEach(viewModel.messages, id: \.id) { message in
            MessageRowView(message: message, chatId: chatUser.id!)
              .padding(.bottom, 10)
          }
        }
      }
    }
    .task {
      await viewModel.fetchMessages(chatUserId: chatUser.id!)
    }
    
    Divider()
    
    // 내용 입력창
    if chatUser.id != 1 {
      HStack {
        TextField("내용을 입력하세요", text: $messageText)
          .padding(12)
          .background(Color(.systemGray6))
          .cornerRadius(8)
        
        // 전송
        Button(action: {
          viewModel.sendMessage(chatUserId: chatUser.id!, content: messageText)
          messageText = ""
        }, label: {
          Image(systemName: "paperplane.fill")
            .foregroundStyle(Color.keyColor)
        })
        .padding(.horizontal, 8)
      }
      .padding(.horizontal)
    }
  }
}

#Preview {
  MessageListView(chatUser: MessageUser(id: 1, nickname: "닉네임", profilePhoto: "D"))
}
