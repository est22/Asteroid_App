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
        GridItem(.fixed(150), spacing: 20),  // 그리드 아이템 사이 가로 간격; 카드 너비와 동일하게 150으로 설정
        GridItem(.fixed(150))
    ]
    // let columns = Array(repeating: GridItem(.fixed(170), spacing: 12), count: 2)
    
    var body: some View {
        NavigationView {
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading) {
                    Text("진행중인 챌린지")
                        .font(.system(size: 20, weight: .bold))
                        .padding(.horizontal, 12)// 좌우 패딩
                        .padding(.top, 20)
                        .padding(.leading, 10)
                    
                    LazyVGrid(columns: columns, spacing: 18) { // 그리드 아이템 사이 세로 간격; 
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
                                    imageName: challenge.displayName
                                )
                            }
                        }
                    }
                    .padding(12)
                }
            }
            .task {
                await viewModel.fetchChallenges()
            }
        }
    }
}

struct ChallengeCard: View {
    let title: String
    let imageName: String
    
    var body: some View {
        ZStack {
            Image(imageName)
                .resizable()
                .scaledToFill()
                .frame(width: 150, height: 150)
                .clipped()
                .cornerRadius(12)
            
            VStack {
                Spacer()
                Text(title)
                    .font(.system(size: 17, weight: .bold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 4)
                    .background(Color.black.opacity(0.5)) // 텍스트 배경
                    
            }
            .frame(height: 150) // 카드의 높이에 맞추기
        }
        .frame(width: 150, height: 150)
    }
}

#Preview {
    Challenge()
}
