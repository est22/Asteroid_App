import SwiftUI

struct PostRankingView: View {
  @StateObject private var viewModel = RankingViewModel()
  @State private var selectedFilter = 0
   
  var filteredRankings: [PostRanking] {
    viewModel.postRankings 
  }
  
  var body: some View {
    VStack(spacing: 8) {
      // 고정될 제목 부분
      HStack {
        Text("💬 인기 게시글")
          .font(.system(size: 18, weight: .bold))
        Spacer()
      }
      .padding(.horizontal)
      .background(Color.white)
      .zIndex(1)
      
      VStack(spacing: 8) {
        // 필터 버튼
        ScrollView(.horizontal, showsIndicators: false) {
          HStack(spacing: 5) {
            FilterButton(title: "당근과채찍", isSelected: selectedFilter == 0) {
              withAnimation(.spring()) {
                selectedFilter = 0
                Task { await viewModel.fetchPostRankings(categoryId: 1) }
              }
            }
            FilterButton(title: "칭찬합시다", isSelected: selectedFilter == 1) {
              withAnimation(.spring()) {
                selectedFilter = 1
                Task { await viewModel.fetchPostRankings(categoryId: 2) }
              }
            }
            FilterButton(title: "자유게시판", isSelected: selectedFilter == 2) {
              withAnimation(.spring()) {
                selectedFilter = 2
                Task { await viewModel.fetchPostRankings(categoryId: 4) }
              }
            }
          }
          .padding(.horizontal)
        }
        
        // 랭킹 리스트
        VStack(spacing: 0) {
          let topRankings = filteredRankings.prefix(5)
          
          
          ForEach(Array(topRankings.enumerated()), id: \.element.id) { index, ranking in
            CommunityRankingRow(ranking: ranking, rank: index + 1)
            
            if index < 4 {
              Divider()
                .padding(.horizontal)
            }
          }
        }
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .overlay(
          RoundedRectangle(cornerRadius: 12)
            .stroke(Color.keyColor, lineWidth: 1)
        )
        .padding(.horizontal)
      }
      .transition(.move(edge: .top))
    }
    .frame(height: UIScreen.main.bounds.height * 0.3)
    .task {
      await viewModel.fetchPostRankings(categoryId: 1)
    }
  }
}

struct CommunityRankingRow: View {
  let ranking: PostRanking
  let rank: Int
  
  var body: some View {
    HStack(spacing: 12) {
      // 순위 표시
      switch rank {
      case 1:
        Text("🥇")
          .frame(width: 24)
      case 2:
        Text("🥈")
          .frame(width: 24)
      case 3:
        Text("🥉")
          .frame(width: 24)
      default:
        Text("#\(rank)")
          .font(.system(size: 14, weight: .medium))
          .foregroundColor(.gray)
          .frame(width: 24)
      }
      // 게시글 제목을 NavigationLink로 감싸기
      NavigationLink(destination: PostDetailView(postID: ranking.id)) {
        Text(ranking.title)
          .font(.system(size: 15, weight: .medium))
          .lineLimit(1)
          .foregroundColor(.black)  // 링크 색상을 검정으로 유지
      }
      
      Spacer()
      
      // 좋아요 수
      Text("👍 \(ranking.likeTotal)")
        .font(.system(size: 14))
        .foregroundColor(.gray)
    }
    .padding(.vertical, 8)
    .padding(.horizontal)
  }
}

#Preview {
  PostRankingView()
}
