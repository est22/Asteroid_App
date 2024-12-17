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
                  
                    // 버튼
                    CommentButtonView(isLiked: $isLiked, likeCount: $likeCount)
                }

                // 댓글 내용
                Text(comment.content)
                    .font(.body)
                    .foregroundColor(.secondary)

                // 시간
                HStack {
                  Text(comment.createdAt)
                        .font(.caption)
                        .foregroundColor(.gray)
                }
            }
        }
        .padding(.vertical, 8)
        .padding(.horizontal)
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
        createdAt: "20241111",
        updatedAt: "20241111",
        replies: [],
        user: UserProfile(nickname: "사용자123", profilePhoto: "https://example.com/profile.jpg")
    )
    CommentRowView(comment: sample)
}
