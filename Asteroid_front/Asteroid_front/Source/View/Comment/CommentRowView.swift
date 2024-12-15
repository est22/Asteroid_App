import SwiftUI

struct CommentRowView: View {
    let comment: Comment

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(alignment: .top, spacing: 12) {
                // 프로필 이미지
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

                // 댓글 내용
                VStack(alignment: .leading, spacing: 6) {
                    HStack {
                        Text((comment.user?.nickname!)!)
                            .font(.headline)
                            .foregroundColor(.primary)
                        
                        Spacer()
                        CommentButtonView() // 버튼 뷰
                    }

                    Text(comment.content)
                        .font(.body)
                        .foregroundColor(.secondary)

                    HStack {
                        Text(comment.createdAt, style: .relative)
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
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
        content: "예시 댓글입니다.",
        likeTotal: 5,
        createdAt: Date(),
        replies: [],
        isShow: true,
        user: User(id: 1, email: "user@example.com", nickname: "사용자", motto: "행복은 나누는 것", profilePhoto: "https://example.com/profile.jpg")
    )
    CommentRowView(comment: sample)
}
