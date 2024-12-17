import SwiftUI

struct MessageListView: View {
  @StateObject private var viewModel = MessageViewModel()
  @State private var messageText: String = ""
  let chatUser: MessageUser
  
  var body: some View {
    VStack {
      // 대화 상대 정보
      chatHeaderView
      
      Divider()
      
      // 메시지 목록
      ScrollViewReader { proxy in
        ScrollView {
          LazyVStack {
            ForEach(viewModel.messages, id: \.id) { message in
              MessageRowView(message: message, chatId: chatUser.id!)
                .padding(.bottom, 10)
                .id(message.id) // 각 메시지에 고유 ID 부여
            }
          }
        }
        .task {
          viewModel.fetchMessages(chatUserId: chatUser.id!)
          scrollToBottom(with: proxy)
        }
        .onChange(of: viewModel.messages.endIndex) { _ in
          scrollToBottom(with: proxy)
        }
      }
      
      Divider()
      
      // 메시지 입력창
      if chatUser.id != 1 {
        messageInputView
      }
    }
  }
}

extension MessageListView {
  // 채팅방 헤더
  private var chatHeaderView: some View {
    VStack {
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
  }
  
  // 메시지 입력창
  private var messageInputView: some View {
    HStack {
      TextField("내용을 입력하세요", text: $messageText)
        .padding(12)
        .background(Color(.systemGray6))
        .cornerRadius(8)
      
      // 전송 버튼
      Button(action: {
        viewModel.sendMessage(chatUserId: chatUser.id!, content: messageText) { success in
          if success {
            Task {
              viewModel.fetchMessages(chatUserId: chatUser.id!)
              messageText = "" // 입력창 초기화
            }
          }
        }
      }, label: {
        Image(systemName: "paperplane.fill")
          .foregroundStyle(Color.keyColor)
      })
      .padding(.horizontal, 8)
    }
    .padding(.horizontal)
  }
  
  // 스크롤 맨 아래로 이동 함수
  private func scrollToBottom(with proxy: ScrollViewProxy) {
    if let lastMessage = viewModel.messages.last {
      DispatchQueue.main.async {
        proxy.scrollTo(lastMessage.id, anchor: .bottom)
    }
    }
  }
}


#Preview {
  MessageListView(chatUser: MessageUser(id: 1, nickname: "닉네임", profilePhoto: ""))
}
