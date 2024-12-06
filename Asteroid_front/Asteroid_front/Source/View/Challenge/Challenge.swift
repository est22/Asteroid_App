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
                    Text("진행중 챌린지")
                        .font(.system(size: 20, weight: .bold))
                        .padding(.horizontal)
                    
                    LazyVGrid(columns: columns, spacing: 16) {
                        ForEach(viewModel.challenges) { challenge in
                            NavigationLink(destination: ChallengeDetailView(challengeId: challenge.id, viewModel: viewModel)) {
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
            .navigationTitle("챌린지")
            .navigationBarTitleDisplayMode(.inline)
            .task {
                await viewModel.fetchChallenges()
            }
        }
    }
}


#Preview {
    Challenge()
}
