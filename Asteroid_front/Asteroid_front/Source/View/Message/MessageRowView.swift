import SwiftUI

struct MessageRowView: View {
    var isSent: Bool
    var content: String
    var timestamp: String

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // 상단 부분
            HStack {
                Text(isSent ? "보낸쪽지" : "받은쪽지")
                    .font(.caption)
                    .foregroundColor(isSent ? Color.orange : Color.blue)
                
                Spacer()
                
                Text(timestamp)
                    .font(.caption)
                    .foregroundColor(.gray)
            }

            // 내용
            Text(content)
                .font(.body)
                .foregroundColor(.primary)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(10)
    }
}

#Preview {
    MessageRowView(isSent: true, content: "dddd", timestamp: "20241115054553")
}
