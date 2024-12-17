import SwiftUI

struct VoteRowView: View {
    var balanceVote: BalanceVote
    
    // 득표율 계산
    var totalVotes: Int {
        return balanceVote.vote1Count + balanceVote.vote2Count
    }
    
    var vote1Percentage: Double {
        return totalVotes > 0 ? Double(balanceVote.vote1Count) / Double(totalVotes) : 0
    }
    
    var vote2Percentage: Double {
        return totalVotes > 0 ? Double(balanceVote.vote2Count) / Double(totalVotes) : 0
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            // 프로필, 닉네임, 제목
            UserInfoView(
                profileImageURL: balanceVote.user.profilePhoto,
                nickname: balanceVote.user.nickname,
                title: balanceVote.title,
                createdAt: balanceVote.createdAt,
                userID: balanceVote.userID,
                isCurrentUser: balanceVote.userID == UserDefaults.standard.integer(forKey: "UserID"),
                onEditTap: {
                    // 수정 기능
                },
                onDeleteTap: {
                    // 삭제 기능
                },
                onReportTap: {
                    // 신고 기능
                }
            )
            
            // 내용
            Text(balanceVote.description)
                .font(.footnote)
                .foregroundColor(.gray)
        }
        
        // 사진 및 결과 Bar
        VStack(alignment: .center){
            // 이미지
            HStack(alignment: .center) {
                Spacer()
                AsyncImage(url: URL(string: balanceVote.image1)) { image in
                    image.resizable()
                        .scaledToFill()
                        .frame(width: 120, height: 120)
                        .clipped()
                } placeholder: {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle())
                        .frame(width: 120, height: 120)
                }
                
                Spacer()

                AsyncImage(url: URL(string: balanceVote.image2)) { image in
                    image.resizable()
                        .scaledToFill()
                        .frame(width: 120, height: 120)
                        .clipped()
                } placeholder: {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle())
                        .frame(width: 120, height: 120)
                }
                Spacer()
            }
            
            // 투표 결과
            HStack(spacing: 0) {
                // 첫 번째 투표
                Rectangle()
                    .fill(Color.keyColor)
                    .frame(width: CGFloat(vote1Percentage) * UIScreen.main.bounds.width * 0.8, height: 10)
                
                // 두 번째 투표
                Rectangle()
                    .fill(Color.color1)
                    .frame(width: CGFloat(vote2Percentage) * UIScreen.main.bounds.width * 0.8, height: 10)
            }
            .cornerRadius(50)
            
            // 퍼센트 텍스트
            HStack {
                Text("\(String(format: "%.1f", vote1Percentage * 100))%")
                    .font(.caption)
                    .foregroundStyle(Color.keyColor)
                Spacer()
                Text("\(String(format: "%.1f", vote2Percentage * 100))%")
                    .font(.caption)
                    .foregroundStyle(Color.color1)
            }
        }
        .padding()
    }
}

#Preview {
  let user = UserProfile(
        nickname: "John Doe",
        profilePhoto: "johnProfileImage"
    )
    
    // 예시 BalanceVote 생성
    let balanceVote = BalanceVote(
        id: 1,
        title: "Which image do you prefer?",
        description: "Vote for the best image.",
        image1: "https://img1.daumcdn.net/thumb/R1280x0.fjpg/?fname=http://t1.daumcdn.net/brunch/service/user/cnoC/image/kQMuuagu-nSEu5MvmcSPrOI0nAk",
        image2: "https://img1.daumcdn.net/thumb/R1280x0.fjpg/?fname=http://t1.daumcdn.net/brunch/service/user/cnoC/image/kQMuuagu-nSEu5MvmcSPrOI0nAk",
        vote1Count: 150,
        vote2Count: 100,
        isShow: true,
        createdAt: "20241111",
        updatedAt: "20241111",
        user: user,
        userId: 1
    )
    
    VoteRowView(balanceVote: balanceVote)
}
