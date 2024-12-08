import SwiftUI

struct CommentListView: View {
    let comments: [Comment]

    var body: some View {
        VStack {
            ForEach(comments) { comment in
                CommentRowView(comment: comment)

                // 대댓글
                if !comment.replies.isEmpty {
                    VStack(alignment: .leading, spacing: 8) {
                        ForEach(comment.replies) { reply in
                            CommentRowView(comment: reply)
                                .padding(.leading, 30)  // 대댓글 들여쓰기
                        }
                    }
                }
            }
        }
    }
}


#Preview {
    // 샘플 유저 데이터
    let sampleUser = User(id: 1, email: "user@example.com", nickname: "JohnDoe", motto: "Live life!", profilePhoto: "https://via.placeholder.com/100")
    
    // 샘플 댓글 데이터
    let sampleComments = [
        Comment(
            id: UUID(),
            content: "This is a sample comment.",
            likeTotal: 10,
            createdAt: Date(),
            replies: [
                Comment(
                    id: UUID(),
                    content: "This is a reply.",
                    likeTotal: 2,
                    createdAt: Date(),
                    replies: [],
                    isShow: true,
                    user: sampleUser
                )
            ],
            isShow: true, user: sampleUser
        ),
        Comment(
            id: UUID(),
            content: "Another top-level comment.",
            likeTotal: 5,
            createdAt: Date().addingTimeInterval(-3600),
            replies: [],
            isShow: true,
            user: sampleUser
        )
    ]
    
    CommentListView(comments: sampleComments)
}
