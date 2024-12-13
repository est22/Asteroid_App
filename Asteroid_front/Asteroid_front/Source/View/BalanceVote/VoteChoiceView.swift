import SwiftUI
import DeckKit

struct VoteChoiceView: View {
    @StateObject var voteVM = BalanceVoteViewModel()
    
    var body: some View {
        // 카드 넘기기
        DeckView($voteVM.votes) { card in
            ZStack{
                VStack {
                    // 상단 이미지
                    VoteImageView(imageURL: card.image1) {
                        print("Top Image Selected")
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    
                    // 하단 이미지
                    VoteImageView(imageURL: card.image2) {
                        print("Top Image Selected")
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
                    userName: (card.user?.nickname!)!,
                    profileImageName: (card.user?.profilePhoto!)!
                )
            }
            
        }
        .padding()
    }
}

#Preview {
    VoteChoiceView()
}
