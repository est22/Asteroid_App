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
        GridItem(.flexible(), spacing: 12), // 그리드 아이템 사이 가로 간격
        GridItem(.flexible())
    ]
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading) {
                    Text("진행중인 챌린지")
                        .font(.system(size: 20, weight: .bold))
                        .padding(.horizontal, 12) // 좌우 패딩
                        .padding(.top, 20)
                    
                    LazyVGrid(columns: columns, spacing: 12) { // 그리드 아이템 사이 세로 간격
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
                    .padding(12) // 그리드와 화면 사이의 간격
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
