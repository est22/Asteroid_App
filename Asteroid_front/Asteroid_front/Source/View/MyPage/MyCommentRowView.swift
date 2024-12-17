import SwiftUI

struct MyCommentRowView: View {
  let comment: MyComment

    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            // 댓글 내용
            Text(comment.content)
                .font(.body)
                .foregroundColor(.black)
                .lineLimit(3)

            // 게시글 제목 (작게)
            Text(comment.postTitle)
                .font(.subheadline)
                .foregroundColor(.gray)
                .lineLimit(1)
        }
        .padding()
    }
}

#Preview {
  let sample = MyComment(
      id: 1,
      postId: 10,
      postTitle: "gㅏ이",
      content: "이건 정말 좋은 아이디어 같아요! 자세히 공유해주셔서 감사합니다.",
      createdAt: "20241111"
  )
    MyCommentRowView(comment: sample)
}
