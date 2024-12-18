import SwiftUI

struct PostDetailView: View {
  @StateObject var postViewModel = PostViewModel()
  @StateObject var commentViewModel = CommentViewModel()
  @State private var commentText: String = ""
  @State private var showingDeleteAlert = false
  @State private var showingReportView = false
  @State private var showingEditView = false
  @State private var likeTotal: Int = 0
  @State private var isLiked: Bool = false
  let postID: Int
  
  
  @Environment(\.dismiss) private var dismiss
  
  var body: some View {
    ScrollView(showsIndicators: false) {
      VStack(alignment: .leading, spacing: 16) {
        // 게시글 섹션
        if postViewModel.isLoading {
          ProgressView("Loading post")
        } else if let post = postViewModel.posts.first(where: { $0.id == postID }) {
          VStack(alignment: .leading, spacing: 0) {
            HStack {
                // 유저 정보 및 타이틀
                UserInfoView(
                  profileImageURL: post.user?.profilePicture,
                  nickname: post.user?.nickname ?? "닉네임",
                  title: post.title,
                  createdAt: post.createdAt,
                  userID: post.userID,
                  isCurrentUser: false,
                  onEditTap: { showingEditView = true },
                  onDeleteTap: { showingDeleteAlert = true },
                  onReportTap: { showingReportView = true },
                  likeCount: post.likeTotal,
                  isLiked: .constant(true),
                  option: "post", post: post
                )
            }
            

            // 내용
            Text(post.content)
                .font(.subheadline)
                .lineSpacing(4)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.top, 8)
                .padding(.bottom, 20)
            
            // 이미지
            if let firstImageURL = post.PostImages?.first?.imageURL, !firstImageURL.isEmpty {
              AsyncImage(url: URL(string: firstImageURL)) { phase in
                switch phase {
                case .empty:
                  ProgressView()
                case .success(let image):
                  image
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: .infinity)
                    .cornerRadius(8)
                case .failure:
                  Image(systemName: "photo")
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: .infinity)
                    .foregroundColor(.gray)
                @unknown default:
                  EmptyView()
                }
              }.padding(.bottom, 30)
            }
            Divider().padding(.bottom, 10)
            // 댓글 갯수
            HStack(spacing: 3) {
              Image(systemName: "ellipsis.bubble")
                .foregroundStyle(Color.keyColor)
              Text("\(postViewModel.commentCount)")
                .font(.subheadline)
                .foregroundStyle(Color.keyColor)
            }
          }
        } else if let errorMessage = postViewModel.message, postViewModel.isFetchError {
          // 에러 메시지 처리
          Text(errorMessage)
            .foregroundColor(.red)
        }
        
        // 댓글 입력
        VStack{
          HStack {
            TextField("내용을 입력하세요", text: $commentText)
              .padding(12)
              .background(Color(.systemGray6))
              .cornerRadius(8)
            
            // 전송
            Button(action: {
              sendComment()
            }, label: {
              Image(systemName: "paperplane.fill")
                .foregroundStyle(Color.keyColor)
            })
            .padding(.horizontal, 8)
          }
          
          if let errorMessage = commentViewModel.errorMessage {
            Text(errorMessage)
              .font(.footnote)
              .foregroundStyle(Color.red)
          }
        }
        
        // 댓글 섹션
        if commentViewModel.comments.isEmpty {
          Text("댓글이 없습니다.")
            .font(.subheadline)
            .foregroundColor(.secondary)
        } else if commentViewModel.isLoading {
          ProgressView("Loading comments...")
        } else {
          CommentListView(comments: commentViewModel.comments)
        }
      }
      .padding()
    }
    .onAppear {
      Task {
        await postViewModel.fetchPostDetail(postID: postID)
        commentViewModel.fetchComments(postId: postID)
      }
    }
    .sheet(isPresented: $showingEditView) {
      PostWriteView()
    }
    .alert(isPresented: $showingDeleteAlert) {
      Alert(title: Text("게시글을 삭제하시겠습니까?"),
            message: Text("삭제된 게시글은 복구할 수 없습니다."),
            primaryButton: .destructive(Text("삭제")) {
        postViewModel.deletePost(postId: postID)
      },
            secondaryButton: .cancel())
    }
    // 신고하기
    .sheet(isPresented: $showingReportView) {
      ReportView(targetType: "P", targetId: postID)
    }
  }
  
  private func sendComment() {
    guard !commentText.trimmingCharacters(in: .whitespaces).isEmpty else {
      commentViewModel.errorMessage = "댓글 내용을 입력해주세요."
      return
    }
    
    commentViewModel.createComment(content: commentText, postId: postID)
    commentText = "" // 입력 필드 초기화
  }
}

#Preview {
  PostDetailView(postID: 1)
}
