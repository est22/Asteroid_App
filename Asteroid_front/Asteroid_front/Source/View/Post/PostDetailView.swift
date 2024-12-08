import SwiftUI

struct PostDetailView: View {
    @State private var comment: [Comment] = []
    let post: Post

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                // 프로필, 제목, 닉네임, 시간
                HStack(alignment: .top, spacing: 12) {
                    // 프로필 이미지
                    if let profileImageURL = post.user.profilePhoto, !profileImageURL.isEmpty {
                        AsyncImage(url: URL(string: profileImageURL)) { phase in
                            switch phase {
                            case .empty:
                                ProgressView()
                            case .success(let image):
                                image
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 50, height: 50)
                                    .clipShape(Circle())
                                    .shadow(radius: 2)
                            case .failure:
                                Image(systemName: "person.crop.circle")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 50, height: 50)
                                    .foregroundColor(.gray)
                            @unknown default:
                                EmptyView()
                            }
                        }
                    } else {
                        Image(systemName: "person.crop.circle")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 50, height: 50)
                            .foregroundColor(.gray)
                    }

                    // 제목, 닉네임, 시간
                    VStack(alignment: .leading, spacing: 4) {
                        Text(post.title)
                            .font(.title3)
                            .bold()

                        HStack {
                            Text(post.user.nickname!)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                    }
                }

                // 게시글 내용
                Text(post.content)
                    .font(.body)
                    .foregroundColor(.primary)

                // 게시글 이미지
                if let firstImageURL = post.images.first?.imageURL, !firstImageURL.isEmpty {
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

                // 좋아요, 댓글 수
                HStack {
                    Image(systemName: "heart.fill")
                    Text("\(post.likeTotal) Likes")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    Spacer()
                    Image(systemName: "bubble.left.fill")
                    Text("\(post.commentTotal) Comments")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                // 댓글
                CommentListView(comments: comment)
            }
            .padding()
        }
        .onAppear {
            fetchComments()
        }
    }
    
    // 댓글 데이터 불러오기
    func fetchComments() {
        // 샘플 댓글 데이터
        let sampleComment = [
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
                        user: post.user
                    )
                ],
                isShow: true,
                user: post.user
            ),
            Comment(
                id: UUID(),
                content: "Another top-level comment.",
                likeTotal: 5,
                createdAt: Date().addingTimeInterval(-3600),
                replies: [],
                isShow: true,
                user: post.user
            )
        ]
        
        // 댓글 데이터 업데이트
        self.comment = sampleComment
    }
}

#Preview {
    // 샘플 이미지 데이터
    let samplePostImage = PostImage(id: 1, imageURL: "https://via.placeholder.com/150", postID: 1)

    // 샘플 유저 데이터
    let sampleUser = User(id: 1, email: "user@example.com", nickname: "JohnDoe", motto: "Live life!", profilePhoto: "https://via.placeholder.com/100")

    // 샘플 포스트 데이터
    let samplePost = Post(
        id: 1,
        title: "Sample Post Title",
        content: "This is the content of the sample post. It can contain a detailed description of the post.",
        categoryID: 1,
        userID: 1,
        isShow: true,
        likeTotal: 15,
        images: [samplePostImage],
        commentTotal: 5, user: sampleUser
    )
    
    PostDetailView(post: samplePost)
}
