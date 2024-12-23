import SwiftUI
import SlidingTabView

struct PostListView: View {
  @StateObject private var postVM = PostViewModel()
  @StateObject private var voteVM = BalanceVoteViewModel()
  @State private var searchData: String = ""
  @State private var selectedTabIndex = 0
  @State private var navigateToWriteView: Bool = false
  
  var body: some View {
    NavigationStack {
      VStack {
        // 검색창
        SearchBar(searchText: $searchData) {
          listLoad()
        }
        
        // 커뮤니티 카테고리 탭
        SlidingTabView(selection: $selectedTabIndex,
                       tabs: ["당근과채찍", "칭찬합시다", "골라주세요", "자유게시판"])
        
        // 카테고리별 게시물 목록
        if selectedTabIndex == 0 {
          postList(for: 1)
        } else if selectedTabIndex == 1 {
          postList(for: 2)
        } else if selectedTabIndex == 2 {
          voteList()
        } else if selectedTabIndex == 3 {
          postList(for: 4)
        }
        
        Spacer()
      }
      // 플로팅 버튼
      .overlay(
        VStack {
          Spacer()
          HStack {
            Spacer()
            FloatingButtonView {
              navigateToWriteView = true
            }
            .padding(.trailing, 50)
            .padding(.bottom, 70)
            .frame(width: 60, height: 60)
          }
        }
      )
      // 작성 화면으로 이동
      .navigationDestination(isPresented: $navigateToWriteView) {
          if selectedTabIndex == 2 {
              VoteWriteView()
          } else {
              PostWriteView(categoryID: selectedTabIndex + 1)
          }
      }
    }
    .onAppear {
      listLoad()
    }
    .onChange(of: selectedTabIndex) { _ in
      listLoad()
    }
  }
  
  private func listLoad() {
    if selectedTabIndex == 2 {
      voteVM.fetchVotes()
    } else {
      postVM.fetchPosts(categoryID: selectedTabIndex + 1, search: searchData)
    }
  }
  
  // 게시물 목록 표시
  private func postList(for categoryID: Int) -> some View {
    ScrollView {
      LazyVStack {
        if postVM.posts.isEmpty {
          Text("게시글이 없습니다.")
            .foregroundStyle(Color.keyColor)
        } else {
          postListContent(for: categoryID)
        }
      }.frame(maxWidth: .infinity, alignment: .leading)
    }
  }
  
  private func postListContent(for categoryID: Int) -> some View {
    ForEach(postVM.posts.filter { $0.categoryID == categoryID }, id: \.id) { post in
      NavigationLink(destination: PostDetailView(postID: post.id)) {
        PostRowView(post: post)
          .padding(.horizontal)
      }
      .onAppear {
        if post == postVM.posts.last {
          postVM.fetchPosts(categoryID: categoryID, search: searchData)
        }
      }
    }
  }
  
  // 밸런스투표 결과 표시
  private func voteList() -> some View {
    ScrollView {
      LazyVStack {
        if voteVM.votes.isEmpty {
          Text("투표가 없습니다.")
            .foregroundStyle(Color.keyColor)
        } else {
          ForEach(voteVM.votes, id: \.id) { vote in
            VoteRowView(balanceVote: vote)
              .padding(.horizontal)
              .onAppear {
                if vote == voteVM.votes.last {
                  voteVM.fetchVotes()
                }
              }
          }
        }
      }
    }
  }
}

#Preview {
  PostListView()
}
