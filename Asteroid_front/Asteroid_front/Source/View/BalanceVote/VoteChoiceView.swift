import SwiftUI
import DeckKit

struct VoteChoiceView: View {
  @StateObject var voteVM = BalanceVoteViewModel()
  @State private var currentIndex = 0
  
  var body: some View {
    VStack{
      // 카드 넘기기
      DeckView($voteVM.votes) { card in
        ZStack{
          VStack {
            // 상단 이미지
            VoteImageView(imageURL: card.image1) {
              submitVote(for: card.id, option: "image1")
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            // 하단 이미지
            VoteImageView(imageURL: card.image2) {
              submitVote(for: card.id, option: "image2")
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
          }
          .frame(maxWidth: .infinity, maxHeight: .infinity)
          .padding()
          .background(
            RoundedRectangle(cornerRadius: 20)
              .fill(Color.white)
              .shadow(radius: 10)
          )
          
          // 정보
          VoteInfoView(
            title: card.title,
            description: card.description,
            userName: card.user.nickname,
            profileImageName: card.user.profilePhoto
          )
        }
        
      }
      .padding()
    }
    .onAppear {
      voteVM.fetchVotes()
    }
  }
  
  // 투표
  private func submitVote(for voteId: Int, option: String) {
    voteVM.submitVote(voteId: voteId, option: option)
    
    // 다음 카드로 이동
    withAnimation {
      if currentIndex < voteVM.votes.count - 1 {
        currentIndex += 1
      }
    }
  }
}

#Preview {
  VoteChoiceView()
}
