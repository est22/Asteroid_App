//
//  MyOngoingChallengeView.swift
//  Asteroid_front
//
//  Created by Lia An on 12/6/24.
//

import SwiftUI

struct MyOngoingChallengeView: View {
    @StateObject private var viewModel = ChallengeViewModel()
    
    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            VStack(alignment: .leading, spacing: 12) {
                Text("내 챌린지")
                    .font(.system(size: 20, weight: .bold))
                    .padding(.horizontal)
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        if viewModel.participatingChallenges.isEmpty {
                            ChallengeCard(title: "주중에 대중교통 이용하기", imageName: "주중에 대중교통 이용하기")
                        } else {
                            ForEach(Array(viewModel.participatingChallenges.enumerated()), id: \.element.id) { index, challenge in
                                NavigationLink(
                                    destination: ChallengeDetailView(
                                        challengeId: challenge.id,
                                        challengeName: challenge.displayName,
                                        viewModel: viewModel
                                    )
                                ) {
                                    ChallengeCard(
                                        title: challenge.displayName,
                                        imageName: challenge.displayName
                                    )
                                }
                            }
                        }
                    }
                    .padding(.horizontal)
                }
            }
        }
        .task {
            await viewModel.fetchParticipatingChallenges()
        }
    }
}

#Preview {
    MyOngoingChallengeView()
}
