import SwiftUI

struct MessageRoomRowView: View {
    var room: MessageRoom

    var body: some View {
        HStack(spacing: 16) {
            Circle()
                .fill(Color.blue)
                .frame(width: 50, height: 50)
                .overlay(
                    Text(String(room.user1Id))
                        .foregroundColor(.white)
                        .font(.headline)
                )

            VStack(alignment: .leading, spacing: 4) {
                Text("User \(room.user1Id)")
                    .font(.headline)
                    .foregroundColor(.primary)

                Text("최근 메시지가 여기에 표시됩니다.")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .lineLimit(1)
            }

            Spacer()

            // 마지막 업데이트 날짜
            Text("5m")
                .font(.caption)
                .foregroundColor(.gray)
        }
        .padding(.vertical, 8)
    }
}

#Preview {
    MessageRoomRowView(
        room: MessageRoom(
            id: 1,
            user1Id: 101,
            user2Id: 102,
            user1LeftAt: nil,
            user2LeftAt: nil,
            createdAt: Date(),
            updatedAt: Date()
        )
    )
}
