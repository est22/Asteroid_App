//
//  Challenge.swift
//  Asteroid_front
//
//  Created by Lia An on 12/4/24.
//

import SwiftUI

struct Challenge: View {
    @StateObject private var viewModel = ChallengeViewModel()
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading) {
                    Text("진행중인 챌린지")
                        .font(.system(size: 20, weight: .bold))
                        .padding(.horizontal)
                        .padding(.top, 20)
                    
                    LazyVGrid(columns: columns, spacing: 16) {
                        ForEach(viewModel.challenges) { challenge in
                            NavigationLink(
                                destination: ChallengeDetailView(
                                    challengeId: challenge.id,
                                    challengeName: challenge.displayName,
                                    viewModel: viewModel
                                )
                            ) {
                                ChallengeCard(
                                    title: challenge.displayName,
                                    color: viewModel.randomPastelColor(forSection: "challenges")
                                )
                            }
                        }
                    }
                    .padding()
                }
            }
            .task {
                await viewModel.fetchChallenges()
            }
        }
    }
}


#Preview {
    Challenge()
}
