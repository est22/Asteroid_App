import SwiftUI

struct PostDetailView: View {
  @StateObject var postViewModel = PostViewModel()
  @StateObject var commentViewModel = CommentViewModel()
  @State private var userID: Int? = UserDefaults.standard.integer(forKey: "UserID")
  @State private var commentText: String = ""
  let postID: Int
  
  var body: some View {
    ScrollView {
      VStack(alignment: .leading, spacing: 16) {
        // 게시글 섹션
        if postViewModel.isLoading {
          ProgressView("Loading post")
        } else if let post = postViewModel.posts.first(where: { $0.id == postID }) {
          VStack(alignment: .leading, spacing: 16) {
            HStack {
              // 유저 정보 및 타이틀
              UserInfoView(
                profileImageURL: post.user?.profilePhoto,
                nickname: post.user?.nickname ?? "닉네임",
                title: post.title
              )
              
              // 오른쪽 ... 버튼
              if let postUser = post.user, let userID = userID, postUser.id == userID {
                Menu {
                  Button("수정") {
                    NavigationLink {
                      PostWriteView(post: post)
                    } label: {
                        Text("수정")
                    }
                  }
                  Button("삭제", role: .destructive) {
                    postViewModel.deletePost(postId: post.id)
//                    presentationMode.wrappedValue.dismiss()
                  }
                } label: {
                  Image(systemName: "ellipsis")
                    .font(.title2)
                    .foregroundColor(.primary)
                }
              } else {
                Menu {
                  Button("신고") {
                    ReportView(targetType: "P", targetId: post.id)
                  }
                } label: {
                  Image(systemName: "ellipsis")
                    .font(.title2)
                    .foregroundColor(.primary)
                }
              }
              
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
            
            HStack {
              Image(systemName: "heart.fill")
              Text("\(post.likeTotal) Likes")
                .font(.subheadline)
                .foregroundColor(.secondary)
              Spacer()
              Image(systemName: "bubble.left.fill")
              Text("\(post.commentTotal ?? 0) Comments")
                .font(.subheadline)
                .foregroundColor(.secondary)
            }
          }
        } else if let errorMessage = postViewModel.message, postViewModel.isFetchError {
          // 에러 메시지 처리
          Text(errorMessage)
            .foregroundColor(.red)
        }
        
        Divider()
          .padding(.vertical)
        
        // 댓글 입력
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
      postViewModel.fetchPostDetail(postID: postID)
      commentViewModel.fetchComments(forPost: postID)
    }
  }
}

#Preview {
  PostDetailView(postID: 1)
}
