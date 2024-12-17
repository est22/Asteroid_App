import SwiftUI

struct MyCommentView: View {
  @StateObject private var myVM = MyPageViewModel()
  @StateObject private var commentVM = CommentViewModel()
  
  var body: some View {
    NavigationStack {
      List {
        if myVM.comments.isEmpty {
          Text("작성한 댓글이 없습니다.")
            .foregroundStyle(Color.gray)
        } else {
          ForEach(myVM.comments, id: \.id) { comment in
            NavigationLink(destination: PostDetailView(postID: comment.postId)) {
              MyCommentRowView(comment: comment)
                .swipeActions(edge: .trailing) {
                  deleteAction(comment: comment)
                }
            }
            .swipeActions(edge: .trailing) {
            }
          }
        }
      }
      .listStyle(.plain)
    }
    .onAppear {
      myVM.fetchMyComments()
    }
  }
  
  // 댓글 삭제 액션
  private func deleteAction(comment:MyComment) -> some View {
    Button(role: .destructive) {
      withAnimation {
        myVM.comments.removeAll { $0.id == comment.id }
        commentVM.deleteComment(commentId: comment.id)
      }
    } label: {
      Label("삭제", systemImage: "trash")
    }
    .tint(Color.red.opacity(0.8))
  }
}

#Preview {
  MyCommentView()
}
