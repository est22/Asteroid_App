import SwiftUI

struct MessageRoomListView: View {
  @StateObject private var viewModel = MessageViewModel()
  
  var body: some View {
    NavigationStack {
      List {
        ForEach(viewModel.messageRooms) { room in
          NavigationLink(destination: MessageListView(chatUser: room.chatUser)) {
            MessageRoomRowView(room: room)
          }
          // 채팅방 나가기
          .swipeActions(edge: .trailing) {
            Button(role: .destructive) {
              withAnimation {
                viewModel.leaveMessageRoomLocal(chatUserId: room.chatUser.id!)
              }
            } label: {
              Label("나가기", systemImage: "person.fill.badge.minus")
            }
            .tint(Color.color1)
          }
        }
      }
      .listStyle(.plain)
      .task {
        await viewModel.fetchMessageRooms()
      }
    }
  }
}

#Preview {
  MessageRoomListView()
}
