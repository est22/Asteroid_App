import SwiftUI

struct CommentListView: View {
    let comments: [Comment]
  
    var body: some View {
        VStack(alignment: .leading) {
            ForEach(comments) { comment in
                // 댓글 표시
                CommentRowView(comment: comment)
                
                // 대댓글
                if let replies = comment.replies, !replies.isEmpty {
                    VStack(alignment: .leading) {
                        ForEach(replies) { reply in
                            CommentRowView(comment: reply)
                                .padding(.leading, 30)  // 들여쓰기
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    let sample = [
        Comment(
            id: 1, content: "정말 좋은 게시글이에요!",
            userId: 1, postId: 1,
            parentCommentId: nil,
            isShow: true,
            likeTotal: 10,
            createdAt: "20241111",
            updatedAt: "20241111",
            replies: [
                Comment(
                    id: 2, content: "저도 동의합니다!",
                    userId: 2, postId: 1,
                    parentCommentId: 1,
                    isShow: true,
                    likeTotal: 3,
                    createdAt: "20241111",
                    updatedAt: "20241111",
                    replies: [],
                    user: UserProfile(nickname: "사용자456", profilePhoto: nil)
                )
            ],
            user: UserProfile(nickname: "사용자123", profilePhoto: nil)
        )
    ]
    CommentListView(comments: sample)
}
