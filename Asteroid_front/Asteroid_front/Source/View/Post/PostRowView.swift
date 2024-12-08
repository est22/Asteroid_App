import SwiftUI

struct PostRowView: View {
    let post: Post

    var body: some View {
        HStack(alignment: .top, spacing: 10) {
            // 제목, 내용
            VStack(alignment: .leading, spacing: 5) {
                Text(post.title)
                    .font(.headline)
                    .foregroundStyle(.primary)
                    .lineLimit(1)

                Text(post.content)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .lineLimit(2)
            }
            Spacer()
            
            // 이미지
            if let firstImageURL = post.images.first?.imageURL, !firstImageURL.isEmpty {
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
        .padding()
    }
}

#Preview {
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
        images: [PostImage(id: 1, imageURL: "https://via.placeholder.com/150", postID: 1)],
        commentTotal: 5, user: sampleUser
    )
    PostRowView(post: samplePost)
}
