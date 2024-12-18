import SwiftUI

struct PostDetailView: View {
  @StateObject var postViewModel = PostViewModel()
  @StateObject var commentViewModel = CommentViewModel()
  @State private var commentText: String = ""
  @State private var showingDeleteAlert = false
  @State private var showingReportView = false
  @State private var showingEditView = false
  let postID: Int

  @Environment(\.dismiss) private var dismiss
  
  var body: some View {
    ScrollView(showsIndicators: false) {
      VStack(alignment: .leading, spacing: 16) {
        // 게시글 섹션
        if postViewModel.isLoading {
          ProgressView("Loading post")
        } else if let post = postViewModel.posts.first(where: { $0.id == postID }) {
          VStack(alignment: .leading, spacing: 16) {
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
                  option: "post"
                )
            }
            
            // 내용
            Text(post.content)
              .font(.body)
              .foregroundColor(.primary)
            
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
              }
            }
            Divider()
            // 댓글 갯수
            HStack(spacing: 3) {
                Image(systemName: "ellipsis.bubble")
                    .foregroundStyle(Color.keyColor)
              Text("\(postViewModel.commentCount ?? 0)")
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
              commentText = ""
            }, label: {
              Image(systemName: "paperplane.fill")
                .foregroundStyle(Color.keyColor)
            })
            .padding(.horizontal, 8)
          }
        }
        
        // 댓글 섹션
        if commentViewModel.isLoading {
          ProgressView("Loading comments...")
        } else if commentViewModel.comments.isEmpty {
          Text("댓글이 없습니다.")
            .font(.subheadline)
            .foregroundColor(.secondary)
        } else {
          CommentListView(comments: commentViewModel.comments)
        }
      }
      .padding()
    }
    .onAppear {
      Task {
        await postViewModel.fetchPostDetail(postID: postID)
        print("####    onAppear   ", postViewModel.posts)
      }
        commentViewModel.fetchComments(postId: postID)
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
    .alert(isPresented: $showingReportView) {
      Alert(title: Text("게시글을 신고하시겠습니까?"),
            message: Text("신고된 게시글은 관리자 확인 후 처리됩니다."),
            primaryButton: .destructive(Text("신고")) {
              // 신고 로직
            },
            secondaryButton: .cancel())
    }
  }
}

#Preview {
    PostDetailView(postID: 1)
}
