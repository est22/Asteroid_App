import SwiftUI

struct ChallengeInfoSection: View {
    @ObservedObject var viewModel: ChallengeViewModel
    
    var body: some View {
        
        // 회색 배경 영역
        ZStack {
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(UIColor.systemGray6))
                .frame(maxWidth: .infinity)
            
            VStack(spacing: 16) {
                Text("\(viewModel.selectedChallenge?.description ?? "")")
                    .font(.system(size: 14))
                Text("챌린지 기간: \(viewModel.selectedChallenge?.period ?? 0)일")
                    .font(.system(size: 16, weight:.heavy))
                    .foregroundColor(.keyColor)
                
                AsyncImage(url: URL(string: viewModel.selectedChallenge?.rewardImageUrl ?? "")) { image in
                    image
                        .resizable()
                        .scaledToFit()
                        .frame(width: 140, height: 140)
                        .clipShape(Circle())
                } placeholder: {
                    ProgressView()
                        .frame(width: 140, height: 140)
                }
                
                Text("챌린지 달성 시 \(viewModel.selectedChallenge?.rewardName ?? "")을 받아요")
                    .font(.system(size: 14))
                    .multilineTextAlignment(.center)
                
                HStack {
                    Text("참여중인 유저")
                        .font(.system(size: 14))
                    Text("\(viewModel.selectedChallenge?.participantCount ?? 0)")
                        .foregroundColor(.orange)
                        .font(.system(size: 14, weight: .bold))
                    Text("명")
                        .font(.system(size: 14))
                }
            }
            .padding(16)
        }
        .padding(.horizontal, -10) // 회색 영역이 화면 가득 차게 설정
        
    }
}
