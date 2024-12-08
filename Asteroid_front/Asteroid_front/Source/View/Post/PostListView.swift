import SwiftUI
import SlidingTabView

struct PostListView: View {
    @State private var query: String = ""
    @State private var selectedTabIndex = 0
    let posts:[Post]

    var body: some View {
        NavigationStack {
            VStack {
                SearchBar(searchText: $query){}
                
                SlidingTabView(selection: self.$selectedTabIndex,
                               tabs: ["당근과채찍", "칭찬합시다", "골라주세요", "자유게시판"])
                
                if selectedTabIndex == 0 {
                    ScrollView {
                        LazyVStack {
                            if self.posts.isEmpty {
                                Text("게시글이 없습니다.")
                                    .foregroundColor(.gray)
                            } else {
                                ForEach(self.posts, id: \.id) { post in
                                    NavigationLink(destination: PostDetailView(post: posts[0])) {
                                        PostRowView(post: post)
                                            .padding(.horizontal)
                                    }
                                }
                            }
                        }
                    }
                } else if selectedTabIndex == 1 {
                    Text("칭찬합시다 View")
                } else if selectedTabIndex == 2 {
                    Text("골라주세요 View")
                } else if selectedTabIndex == 3 {
                    Text("자유게시판 View")
                }
                
                Spacer()
            }
        }
    }
}

#Preview {
    let user = User(id: 1, email: "user@example.com", nickname: "JohnDoe", motto: "Live life!", profilePhoto: "https://via.placeholder.com/100")
    
    let samplePost = [
            Post(
                id: 1,
                title: "Title",
                content: "This is a sample content for a post. It can be up to two lines.This is a sample content for a post. It can be up to two lines.",
                categoryID: 1,
                userID: 1,
                isShow: true,
                likeTotal: 10,
                images: [PostImage(id: 1, imageURL: "https://via.placeholder.com/150", postID: 1)],
                commentTotal: 1, user: user
        ),
          Post(
              id: 2,
              title: "Title",
              content: "This is a sample content for a post. It can be up to two lines.This is a sample content for a post. It can be up to two lines.",
              categoryID: 1,
              userID: 1,
              isShow: true,
              likeTotal: 10,
              images: [PostImage(id: 1, imageURL: "https://via.placeholder.com/150", postID: 1)],
              commentTotal: 2, user: user
          )
      ]
    PostListView(posts: samplePost)
}
