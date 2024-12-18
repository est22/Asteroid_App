import SwiftUI
import DeckKit

struct VoteChoiceView: View {
  @StateObject var voteVM = BalanceVoteViewModel()
  @State private var showResultOverlay = false       // 투표 결과 오버레이 표시
  @State private var updatedCard: BalanceVote? = nil // 현재 카드의 로컬 상태
  @State private var userVoted: [Int] = []      // 사용자가 투표한 항목
  
  var body: some View {
    VStack{
      if voteVM.votes.isEmpty {
        Text("새로운 투표가 없습니다.")
          .font(.headline)
          .foregroundStyle(Color.color1)
          .padding()
      } else {
        // 밸런스 투표 카드
        DeckView($voteVM.votes) { card in
          ZStack{
            // 투표하지 않은 항목만 보여주기
//            if !userVoted.contains(card.id) {
              VStack {
                // 상단 이미지
                VoteImageView(imageURL: card.image1) {
                  submitVote(for: card.id, option: 1, card: card)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .overlay(
                  overlayView(for: card, option: 1)
                )
                
                // 하단 이미지
                VoteImageView(imageURL: card.image2) {
                  submitVote(for: card.id, option: 2, card: card)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .overlay(
                  overlayView(for: card, option: 2)
                )
              }
              .frame(maxWidth: .infinity, maxHeight: .infinity)
              .padding()
              .background(
                RoundedRectangle(cornerRadius: 20)
                  .fill(Color.white)
              )
              
              // 작성자 정보
              VoteInfoView(
                title: card.title,
                description: card.description,
                userName: card.user!.nickname,
                profileImageName: card.user?.profilePhoto ?? ""
              )
            }
//          }
        }
        .padding(.bottom, 30)
      }
    }
    .onAppear {
      voteVM.fetchVotes()
    }
  }
  
  // 투표
  private func submitVote(for voteId: Int, option: Int, card: BalanceVote) {
    // 로컬에 투표 결과 적용
    var updatedCard = card
    if option == 1 {
      updatedCard.vote1Count += 1
    } else {
      updatedCard.vote2Count += 1
    }
    self.updatedCard = updatedCard // 현재 카드 상태 저장
    userVoted.append(voteId) // 투표한 항목 추가
    
    // 서버에 투표 결과 적용
    voteVM.submitVote(voteId: voteId, option: option)
    
    showResultOverlay = true
    
    // 자동으로 카드 넘기기
    Task {
      try? await Task.sleep(nanoseconds: 1_000_000_000)
      withAnimation {
        voteVM.votes.removeFirst()
        showResultOverlay = false // 오버레이 숨기기
        self.updatedCard = nil
      }
    }
  }
  
  // 득표율 계산
  private func percentage(for card: BalanceVote, option: Int) -> Double {
    let cardToUse = updatedCard ?? card
    let vote1 = cardToUse.vote1Count
    let vote2 = cardToUse.vote2Count
    let totalVotes = vote1 + vote2
    guard totalVotes > 0 else { return 0 }
    
    return option == 1
    ? Double(vote1) / Double(totalVotes)
    : Double(vote2) / Double(totalVotes)
  }
  
  // 득표율 오버레이
  private func overlayView(for card: BalanceVote, option: Int) -> some View {
    ZStack {
      if showResultOverlay {
        Color.black.opacity(0.5)
        Text("\(String(format: "%.1f", percentage(for: card, option: option) * 100))%")
          .foregroundColor(.white)
          .font(.title)
          .bold()
      }
    }
  }
}

#Preview {
  VoteChoiceView()
}
