import SwiftUI

struct ChallengeDetailView: View {
    @Environment(\.presentationMode) var presentationMode
    let challengeId: Int
    @ObservedObject var viewModel: ChallengeViewModel
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                if let challenge = viewModel.selectedChallenge {
                    Group {
                        Text("기간: \(challenge.period)일")
                            .font(.headline)
                        
                        Text(challenge.description)
                            .font(.body)
                        
                        Text("참여자 수: \(challenge.participantCount)명")
                            .font(.subheadline)
                        
                        VStack(alignment: .leading) {
                            Text("보상: \(challenge.rewardName)")
                                .font(.headline)
                            
                            AsyncImage(url: URL(string: challenge.rewardImageUrl)) { image in
                                image
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: 200)
                            } placeholder: {
                                ProgressView()
                            }
                        }
                    }
                    .padding()
                } else if viewModel.isLoading {
                    ProgressView()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else if !viewModel.errorMessage.isEmpty {
                    Text(viewModel.errorMessage)
                        .foregroundColor(.red)
                        .padding()
                }
            }
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: Button(action: {
            presentationMode.wrappedValue.dismiss()
        }) {
            Image(systemName: "chevron.left")
                .foregroundColor(.keyColor)
        })
        .task {
            print("Fetching challenge detail for ID: \(challengeId)")
            await viewModel.fetchChallengeDetail(id: challengeId)
        }
    }
}

#Preview {
    NavigationView {
        ChallengeDetailView(challengeId: 1, viewModel: ChallengeViewModel())
    }
} 