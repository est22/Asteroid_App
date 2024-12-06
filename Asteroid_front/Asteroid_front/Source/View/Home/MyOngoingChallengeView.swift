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
            // 인기 챌린지
            VStack(alignment: .leading, spacing: 12) {
                Text("인기 챌린지")
                    .font(.system(size: 20, weight: .bold))
                    .padding(.horizontal)
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        // 각 섹션별로 별도의 색상 인덱스를 사용
                        ForEach(0..<10) { index in
                            ChallengeCard(
                                title: "인기 챌린지 \(index + 1)",
                                color: viewModel.randomPastelColor(forSection: "popular")
                            )
                        }
                    }
                    .padding(.horizontal)
                }
            }
            
            // 참여중인 챌린지
            VStack(alignment: .leading, spacing: 12) {
                Text("내 챌린지")
                    .font(.system(size: 20, weight: .bold))
                    .padding(.horizontal)
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach(viewModel.participatingChallenges) { challenge in
                            ChallengeCard(
                                title: challenge.challengeName!,
                                color: viewModel.randomPastelColor(forSection: "participating")
                            )
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

struct ChallengeCard: View {
    let title: String
    let color: Color
    
    var body: some View {
        VStack {
            Text(title)
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(.black)
                .multilineTextAlignment(.center)
                .padding()
        }
        .frame(width: 150, height: 150)
        .background(color)
        .cornerRadius(12)
    }
}

#Preview {
    MyOngoingChallengeView()
}
