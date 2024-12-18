import SwiftUI
import SlidingTabView

struct PostListView: View {
  @StateObject private var postVM = PostViewModel()
  @StateObject private var voteVM = BalanceVoteViewModel()
  @State private var searchData: String = ""
  @State private var selectedTabIndex = 0
  @State private var navigateToWriteView: Bool = false
  @Environment(\.scenePhase) private var scenePhase
  
  var body: some View {
    NavigationStack {
      VStack(spacing: 0) {
        // 검색창
        SearchBar(searchText: $searchData) {
          Task {
            await refreshData()
          }
        }
        .padding(.vertical, 4)
        
        // 커뮤니티 카테고리 탭
        VStack(spacing: 0) {
            SlidingTabView(selection: $selectedTabIndex,
                           tabs: ["당근과채찍", "칭찬합시다", "골라주세요", "자유게시판"],
                           font: .system(size: 16, weight: .medium),
                           activeAccentColor: .keyColor,
                           inactiveAccentColor: .black,
                           selectionBarColor: .keyColor,
                           inactiveTabColor: .white)
                .padding(.vertical, 4)
        }
        .tint(.black)
        
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
            .padding(.trailing, 45)
            .padding(.bottom, 100)
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
      Task {
        await refreshData()
      }
    }
    .onChange(of: selectedTabIndex) { _ in
      Task {
        await refreshData()
      }
    }
    .onChange(of: scenePhase) { newPhase in
      if newPhase == .active {
        Task {
          await refreshData()
        }
      }
    }
  }
  
  private func refreshData() async {
    if selectedTabIndex == 2 {
      await voteVM.fetchVotes()
    } else {
      await postVM.fetchPosts(categoryID: selectedTabIndex + 1, search: searchData)
    }
  }
  
  // 게시물 목록 표시
  private func postList(for categoryID: Int) -> some View {
    ScrollView(showsIndicators: false) {
      RefreshControl(coordinateSpace: .named("RefreshControl")) {
        Task {
          await refreshData()
        }
      }
      
      LazyVStack {
        if postVM.posts.isEmpty {
          Text("게시글이 없습니다.")
            .foregroundStyle(Color.keyColor)
        } else {
          postListContent(for: categoryID)
        }
      }.frame(maxWidth: .infinity, alignment: .leading)
    }
    .coordinateSpace(name: "RefreshControl")
  }
  
  private func postListContent(for categoryID: Int) -> some View {
    ForEach(postVM.posts.filter { $0.categoryID == categoryID }, id: \.id) { post in
      VStack(spacing: 0) {
        NavigationLink(destination: PostDetailView(postID: post.id)) {
          PostRowView(post: post)
            .padding(.horizontal, 4)
            .padding(.vertical, 4)
        }
        
        Divider()
          .background(Color.gray.opacity(0.3))
      }
      .onAppear {
        if post == postVM.posts.last {
          Task {
            await refreshData()
          }
        }
      }
    }
  }
  
  // 밸런스투표 결과 표시
  private func voteList() -> some View {
    ScrollView {
        LazyVStack(spacing: 0) {
            if voteVM.votes.isEmpty {
                Text("투표가 없습니다.")
                    .foregroundStyle(Color.keyColor)
            } else {
                ForEach(voteVM.votes, id: \.id) { vote in
                    VStack(spacing: 0) {
                        VoteRowView(balanceVote: vote)
                            .padding(.horizontal)
                            .padding(.top, 10)
                            .onAppear {
                                if vote == voteVM.votes.last {
                                    Task {
                                      await voteVM.fetchVotes()
                                    }
                                }
                            }
                        
                        Divider()
                            .background(Color.gray.opacity(0.3))
                    }
                }
            }
        }
    }
    .padding(.top, 0)
  }
}

#Preview {
  PostListView()
}
