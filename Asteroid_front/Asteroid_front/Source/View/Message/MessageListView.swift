import SwiftUI

struct MessageListView: View {
    var messages: [Message]
    var recipientName: String = "니체"
    var recipientImage: Image = Image(systemName: "person.circle.fill")

    var body: some View {
        VStack {
            // 대화 상대 정보
            VStack {
                recipientImage
                    .resizable()
                    .scaledToFill()
                    .frame(width: 60, height: 60)
                    .clipShape(Circle())
                    .padding(.bottom, 8)
                
                Text(recipientName)
                    .font(.headline)
                    .foregroundColor(.primary)
            }
            
            Divider()

            // 메시지 목록
            ScrollView {
                VStack(spacing: 0) {
                    ForEach(messages) { message in
                        let isSent = message.senderUserId == 1
                        MessageRowView(
                            isSent: isSent,
                            content: message.content,
                            timestamp: formatDate(message.createdAt)
                        )
                        .padding(.bottom, 10)
                    }
                }
            }

            Divider()
            
            // 입력창
            HStack {
                TextField("메시지를 입력하세요...", text: .constant(""))
                    .padding(12)
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
                
                Button(action: {
                    // 전송 로직
                }) {
                    Image(systemName: "paperplane.fill")
                        .foregroundColor(.blue)
                }
                .padding(.horizontal, 8)
            }
            .padding()
        }
        .navigationBarTitle("", displayMode: .inline)
    }
    
    // Helper: 날짜 포맷 변환
    func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}

#Preview {
    let sample = [
        Message(id: 1, content: "LG그룹에선 조주완 LG전자 사장과 정철동 LG디스플레이 사장의 부회장 승진 가능성에 이목이 쏠렸지만 승진자는 나오지 않았다.", senderUserId: 2, receiverUserId: 1, isRead: true, createdAt: Date(timeIntervalSince1970: 20241115054553), updatedAt: Date()),
        Message(id: 2, content: "LG그룹 조주완 LG전자 사장", senderUserId: 1, receiverUserId: 2, isRead: true, createdAt: Date(), updatedAt: Date())
    ]

    MessageListView(messages: sample)
}
