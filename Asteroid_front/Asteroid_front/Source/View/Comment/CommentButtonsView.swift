import SwiftUI

struct CommentButtonView: View {
    var body: some View {
        HStack(spacing: 15) {
            // 대댓글 버튼
            Button(action: {
                print("대댓글 작성")
            }) {
                HStack {
                    Image(systemName: "message.fill")
                }
                .foregroundColor(.blue)
            }
            
            // 좋아요 버튼
            Button(action: {
                print("좋아요 클릭")
            }) {
                HStack {
                    Image(systemName: "heart.fill")
                }
                .foregroundColor(.red)
            }
            
            // 신고 버튼
            Button(action: {
                print("신고 클릭")
            }) {
                HStack {
                    Image(systemName: "exclamationmark.triangle.fill")
                }
                .foregroundColor(.orange)
            }
        }
        .padding(.top, 5)
    }
}

#Preview {
    CommentButtonView()
}
