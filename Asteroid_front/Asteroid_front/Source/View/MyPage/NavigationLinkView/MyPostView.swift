import SwiftUI
import SlidingTabView

struct MyPostView: View {
  @State private var selectedTabIndex = 0
  @EnvironmentObject var myVM: MyPageViewModel
  @StateObject private var postVM = PostViewModel()
  @StateObject private var voteVM = BalanceVoteViewModel()
  
  var body: some View {
    NavigationStack {
      VStack {
        // 카테고리 분류
        SlidingTabView(selection: $selectedTabIndex,
                       tabs: ["커뮤니티", "밸런스 투표"])
        
        // 내가 작성한 커뮤니티 글
        if selectedTabIndex == 0 {
          myPost()
        }
        // 내가 작성한 밸런스 투표
        else if selectedTabIndex == 1 {
          myVote()
        }
        
        Spacer()
      }
    }
    .onAppear {
      myVM.fetchMyPosts()
    }
  }
  
  // 내 커뮤니티 글
  private func myPost() -> some View {
    List {
      if myVM.posts.isEmpty {
        Text("게시글이 없습니다.")
          .foregroundStyle(Color.gray)
      } else {
        ForEach(myVM.posts.filter { [1, 2, 4].contains($0.categoryID) }, id: \.id) { post in
          NavigationLink(destination: PostDetailView(postID: post.id)) {
            PostRowView(post: post)
          }
          .swipeActions(edge: .trailing) {
            deletePostAction(post: post)
          }
        }
      }
    }
    .listStyle(.plain)
  }
  
  // 내 밸런스 투표
  private func myVote() -> some View {
    List {
      if myVM.votes.isEmpty {
        Text("투표가 없습니다.")
          .foregroundStyle(Color.gray)
      } else {
        ForEach(myVM.votes, id: \.id) { vote in
          MyVoteRowView(balanceVote: vote)
            .swipeActions(edge: .trailing) {
              deleteVoteAction(vote: vote)
            }
        }
      }
    }
    .listStyle(.plain)
  }
  
  // 게시글 삭제 액션
  private func deletePostAction(post: Post) -> some View {
      Button(role: .destructive) {
        withAnimation {
          myVM.posts.removeAll { $0.id == post.id }
          postVM.deletePost(postId: post.id)
        }
      } label: {
        Label("삭제", systemImage: "trash")
      }
      .tint(Color.red.opacity(0.8))
    }
  
  // 밸런스 투표 삭제 액션
  private func deleteVoteAction(vote: BalanceVote) -> some View {
      Button(role: .destructive) {
        withAnimation {
          myVM.votes.removeAll { $0.id == vote.id }
          voteVM.deleteVote(voteId: vote.id)
        }
      } label: {
        Label("삭제", systemImage: "trash")
      }
      .tint(Color.red.opacity(0.8))
    }
}

#Preview {
  let vm = MyPageViewModel()
  MyPostView().environmentObject(vm)
}
