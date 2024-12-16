import SwiftUI

struct MyCommentView: View {
    @StateObject private var viewModel = MyPageViewModel()
    
    var body: some View {
        VStack {
            // 댓글 목록이 없으면 메시지 표시
            if viewModel.comments.isEmpty {
                Text("댓글이 없습니다.")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .padding()
            } else {
                // 댓글 목록 표시
                List(viewModel.comments) { comment in
                    VStack(alignment: .leading, spacing: 8) {
                        Text(comment.content)
                            .font(.body)
                            .foregroundColor(.gray)
                        
                        Text("작성일: \(formattedDate(comment.createdAt))")
                            .font(.footnote)
                            .foregroundColor(.gray)
                        
                        if let replies = comment.replies, !replies.isEmpty {
                            // 대댓글 목록
                            ForEach(replies) { reply in
                                Text("답글: \(reply.content)")
                                    .font(.subheadline)
                                    .foregroundColor(.blue)
                                    .padding(.leading)
                            }
                        }
                    }
                    .padding()
                }
            }
        }
        .onAppear {
            viewModel.fetchMyComments() // 뷰가 나타날 때 댓글을 불러옴
        }
    }

    // 날짜 포맷팅 함수
    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return formatter.string(from: date)
    }
}

#Preview {
    let viewModel = MyPageViewModel()
    MyCommentView().environmentObject(viewModel)
}
