import SwiftUI

struct MessageRoomListView: View {
  @StateObject private var viewModel = MessageViewModel()
  
  var body: some View {
    NavigationStack{
      ScrollView{
        LazyVStack{
          ForEach(viewModel.messageRooms) { room in
            HStack {
              NavigationLink(destination: MessageListView(chatUser:room.chatUser)) {
                MessageRoomRowView(room: room)
              }
            }
            // 나가기
//            .swipeActions(edge: .trailing, content: {
//              Button {
//                viewModel.leaveMessageRoom(chatUserId: room.chatUser.id!)
//              } label: {
//                Label("나가기", systemImage: "person.fill.badge.minus")
//              }
//              .tint(Color.color1)
//            })
          }
        }
      }
      .task {
        await viewModel.fetchMessageRooms()
      }
    }
  }
  
  private func deleteMessageRoom(at offsets: IndexSet) {
    for index in offsets {
      let room = viewModel.messageRooms[index]
      viewModel.leaveMessageRoom(chatUserId: room.chatUser.id!)
    }
  }
}

#Preview {
  MessageRoomListView()
}
