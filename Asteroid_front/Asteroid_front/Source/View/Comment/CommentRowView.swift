import SwiftUI

struct CommentRowView: View {
    let comment: Comment
    @State private var isLiked = false
    @State private var likeCount: Int
  
    init(comment: Comment) {
      _likeCount = State(initialValue: comment.likeTotal ?? 0)
        self.comment = comment
    }

    var body: some View {
        HStack(alignment: .center, spacing: 12) {
            // 프로필 이미지
            VStack {
                Spacer()
              if let profilePicture = comment.user?.profilePhoto {
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
                Spacer()
            }

            // 닉네임, 버튼, 내용, 시간
            VStack(alignment: .leading, spacing: 6) {
                // 닉네임
                HStack {
                    Text(comment.user?.nickname ?? "닉네임")
                        .font(.headline)
                        .foregroundColor(.primary)

                    Spacer()

                    // 시간
                    Text(formatDate(comment.createdAt))
                        .font(.caption)
                        .foregroundColor(.gray)

                    // 주석 처리된 버튼
                    // CommentButtonView(isLiked: $isLiked, likeCount: $likeCount)
                }

                // 댓글 내용
                Text(comment.content)
                    .font(.body)
                    .foregroundColor(.secondary)
            }
        }
        .padding(.vertical, 8)
        .padding(.horizontal)
    }

    private func formatDate(_ dateString: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        if let date = formatter.date(from: dateString) {
            formatter.dateFormat = "MM월 dd일 HH:mm"
            return formatter.string(from: date)
        }
        return dateString
    }
}

#Preview {
    let sample = Comment(
        id: 1,
        content: "이건 정말 좋은 아이디어 같아요! 자세히 공유해주셔서 감사합니다.",
        userId: 2,
        postId: 10,
        parentCommentId: nil,
        isShow: true,
        likeTotal: 15,
        createdAt: "2024-11-11T15:42:00.878Z",
        updatedAt: "2024-11-11T15:42:00.878Z",
        replies: [],
        user: UserProfile(nickname: "사용자123", profilePhoto: "https://example.com/profile.jpg")
    )
    CommentRowView(comment: sample)
}
