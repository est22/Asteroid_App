import SwiftUI

struct CommentButtonView: View {
    @Binding var isLiked: Bool
    @Binding var likeCount: Int
  
    var body: some View {
        HStack(spacing: 15) {
            // 대댓글 버튼
            Button(action: {
                print("대댓글 작성")
            }) {
                HStack {
                    Image(systemName: "message")
                }
                .foregroundStyle(Color.keyColor)
            }
            
            // 좋아요 버튼
            Button(action: {
                isLiked.toggle()
                likeCount += isLiked ? 1 : -1
                print("좋아요 클릭")
            }) {
                HStack(spacing: 3) {
                    Image(systemName: isLiked ? "heart.fill" : "heart")
                    Text("\(likeCount)")
                }
                .foregroundStyle(Color.color1)
            }
            
            // 수정, 삭제, 신고
            Button(action: {
                print("기타 버튼 클릭")
            }) {
                HStack {
                    Image(systemName: "ellipsis")
                }
                .foregroundStyle(Color.color3)
            }
        }
        .padding(.top, 5)
    }
}

#Preview {
  CommentButtonView(isLiked: .constant(true), likeCount: .constant(1))
}
