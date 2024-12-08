import SwiftUI

struct CommentRowView: View {
    let comment: Comment

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(alignment: .top, spacing: 12) {
                // 프로필 이미지
                if let profilePicture = comment.user.profilePhoto {
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
                        Text(comment.user.nickname!)
                            .font(.headline)
                            .foregroundColor(.primary)
                        
                        Spacer()
                        CommentButtonView()
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
    // 샘플 유저 데이터
    let sampleUser = User(id: 1, email: "user@example.com", nickname: "JohnDoe", motto: "Live life!", profilePhoto: "https://via.placeholder.com/100")
    
    // 샘플 댓글 데이터
    let sampleComments =
                Comment(
                    id: UUID(),
                    content: "This is a sample comment.",
                    likeTotal: 0,
                    createdAt: Date(),
                    replies: [
                        Comment(
                            id: UUID(),
                            content: "This is a reply.",
                            likeTotal: 1,
                            createdAt: Date(),
                            replies: [],
                            isShow: true,
                            user: sampleUser
                        )
                    ],
                    isShow: true,
                    user: sampleUser
                )
    CommentRowView(comment: sampleComments)
}
