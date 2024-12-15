import SwiftUI
import SlidingTabView

struct MyPostView: View {
    @State private var selectedTabIndex = 0
    @EnvironmentObject var vm: MyPageViewModel
    
    var body: some View {
        NavigationStack {
            VStack {
                // 카테고리 분류
                SlidingTabView(selection: $selectedTabIndex,
                               tabs: ["커뮤니티", "밸런스 투표"])
                
                // 내가 작성한 커뮤니티 글
                if selectedTabIndex == 0 {
                    listView(tab: selectedTabIndex)
                    
                // 내가 작성한 밸런스 투표
                } else if selectedTabIndex == 1 {
                    listView(tab: selectedTabIndex)
                }
                
                Spacer()
            }
        }
        .onAppear {
            vm.fetchMyPosts(size: 10)
        }
    }
    
    // 카테고리별 게시물 목록 표시
    private func listView(tab: Int) -> some View {
        ScrollView {
            LazyVStack {
                if vm.posts.isEmpty && vm.votes.isEmpty {
                    Text("게시글이 없습니다.")
                        .foregroundStyle(Color.keyColor)
                } else {
                    // 각 탭에 맞는 데이터 필터링
                    if tab == 0 { // 커뮤니티
                        // 커뮤니티 게시글만 필터링하여 표시
                        ForEach(vm.posts.filter { [1, 2, 4].contains($0.categoryID) }, id: \.id) { post in
                            PostRowView(post: post)
                        }
                        
                        // 네비게이션 일단 보류
//                        ForEach(vm.posts.filter { [1, 2, 4].contains($0.categoryID) }, id: \.id) { post in
//                            NavigationLink(destination: PostDetailView(post: post)) {
//                                PostRowView(post: post)
//                            }
//                        }
                    } else { // 밸런스 투표
                        // 밸런스 투표만 표시
//                        ForEach(vm.votes, id: \.id) { vote in
//                            VoteRowView(balanceVote: vote)
//                        }
                    }
                }
            }
        }
    }
}

#Preview {
    let vm = MyPageViewModel()
    MyPostView().environmentObject(vm)
}
