import SwiftUI

struct MessageRoomListView: View {
    // 샘플 데이터
    let messageRooms: [MessageRoom] = [
        MessageRoom(id: 1, user1Id: 101, user2Id: 102, user1LeftAt: nil, user2LeftAt: nil, createdAt: Date(), updatedAt: Date()),
        MessageRoom(id: 2, user1Id: 201, user2Id: 202, user1LeftAt: nil, user2LeftAt: nil, createdAt: Date(), updatedAt: Date()),
        MessageRoom(id: 3, user1Id: 301, user2Id: 302, user1LeftAt: nil, user2LeftAt: nil, createdAt: Date(), updatedAt: Date())
    ]
    
    var body: some View {
        NavigationView {
            List(messageRooms) { room in
                MessageRoomRowView(room: room)
            }
            .navigationTitle("쪽지방 목록")
        }
    }
}

#Preview {
    MessageRoomListView()
}
