import SwiftUI
import DeckKit

struct VoteChoiceView: View {
//    let images = ["person", "person.circle"]
//    @State private var currentIndex = 0
    @State var cards: [BalanceVote]
    
    var body: some View {
        // 카드 넘기기
        DeckView($cards) { card in
            VStack {
                // 상단 이미지
                VoteImageView(imageName: card.image1) {
                    print("Top Image Selected")
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                
                // 정보
                VoteInfoView(
                    title: card.title,
                    description: card.description!,
                    userName: card.user.nickname!,
                    profileImageName: card.user.profilePhoto!
                )
                
                // 하단 이미지
                VoteImageView(imageName: card.image2) {
                    print("Bottom Image Selected")
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
        }
        .padding()
    }
}

#Preview {
    let sample = [
        BalanceVote(
            id: 1,
            title: "Vote 1",
            description: "This is a test description",
            user: User(id: 1, email: "eee", nickname: "rrr", motto: "qqq", profilePhoto: "asas"),
            image1: "person",
            image2: "person.circle",
            vote1Count: 0,
            vote2Count: 0,
            isShow: true,
            createdAt: Date(),
            updatedAt: Date()
        )
    ]
    VoteChoiceView(cards: sample)
}
