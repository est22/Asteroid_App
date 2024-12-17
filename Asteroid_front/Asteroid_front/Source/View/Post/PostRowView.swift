import SwiftUI

struct PostRowView: View {
    let post: Post

    var body: some View {
        HStack(alignment: .top, spacing: 0) {
            // 제목, 내용, 아이콘들
            VStack(alignment: .leading, spacing: 2) {
                // 제목
                Text(post.title)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundStyle(.primary)
                    .foregroundColor(.black)
                    .lineLimit(1)
                    .frame(maxWidth: .infinity, alignment: .leading)

                // 내용
                Text(post.content)
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                    .foregroundColor(.black)
                    .lineLimit(1)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .multilineTextAlignment(.leading)
                
                // 좋아요, 댓글 수 표시
                HStack(spacing: 8) {
                    HStack(spacing: 4) {
                        Image(systemName: "heart")
                            .foregroundColor(.red.opacity(0.6))
                        Text("\(post.likeTotal)")
                            .foregroundColor(.red.opacity(0.6))
                            .font(.footnote)
                    }
                    
                    HStack(spacing: 4) {
                        Image(systemName: "message")
                            .foregroundColor(.keyColor)
                        Text("\(post.commentTotal ?? 0)")
                            .foregroundColor(.keyColor)
                            .font(.footnote)
                    }
                }
                .padding(.top, 2)
            }
            
            Spacer()
            
            // 이미지 썸네일
            if let firstImageURL = post.PostImages?.first?.imageURL, !firstImageURL.isEmpty {
                AsyncImage(url: URL(string: firstImageURL)) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFill()
                            .frame(width: 60, height: 60)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                            .shadow(radius: 2)
                    case .failure:
                        Image(systemName: "photo")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 60, height: 60)
                            .foregroundStyle(.gray)
                    @unknown default:
                        EmptyView()
                    }
                }
            }
        }
        .padding(.vertical, 2)
        .padding(.horizontal, 3)
    }
}

#Preview {
    let samplePost = Post(
        id: 1,
        title: "Sample Post Title",
        content: "This is the content of the sample post. It can contain a detailed description of the post.",
        categoryID: 1,
        userID: 1,
        isShow: true,
        likeTotal: 15,
        PostImages: [PostImage(id: 1, imageURL: "https://via.placeholder.com/150", postID: 1)],
        commentTotal: 5,
        createdAt: "20241111",
        updatedAt: "20241111",
        user: User(id: 1, email: "user@example.com", nickname: "JohnDoe", motto: "Live life!", profilePhoto: "https://via.placeholder.com/100")
    )
    PostRowView(post: samplePost)
}
