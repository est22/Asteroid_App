import SwiftUI

struct PostDetailView: View {
  @StateObject var postViewModel = PostViewModel()
  @StateObject var commentViewModel = CommentViewModel()
  
  let postID: Int
  
  var body: some View {
    ScrollView {
      VStack(alignment: .leading, spacing: 16) {
        // 게시글 섹션
        if postViewModel.isLoading {
          ProgressView("Loading post...")
        } else if let post = postViewModel.posts.first(where: { $0.id == postID }) {
          VStack(alignment: .leading, spacing: 16) {
            // 유저 정보 및 타이틀
            UserInfoView(
              profileImageURL: post.user?.profilePhoto,
              nickname: post.user?.nickname ?? "닉네임",
              title: post.title
            )
            
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
