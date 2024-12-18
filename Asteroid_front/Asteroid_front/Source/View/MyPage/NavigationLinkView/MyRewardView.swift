//
//  MyRewardView.swift
//  Asteroid_front
//
//  Created by Lia An on 12/5/24.
//

import SwiftUI

struct MyRewardView: View {
    @StateObject private var viewModel = CompletedChallengeViewModel()
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .center, spacing: 20) {

                HStack {
                    Text("내 포인트: ")
                        .font(.system(size: 20, weight: .bold))
                    Text("\(viewModel.totalPoints)")
                        .foregroundColor(.keyColor)
                        .font(.system(size: 20, weight: .bold))
                }.padding()
                
//                Text("내가 모은 소행성").font(.system(size: 12))
                
//                #if DEBUG
//                // 디버그 모드에서만 보이는 샘플 데이터
//                if viewModel.completedChallenges.isEmpty {
//                    HStack(spacing: 16) {
//                        AsyncImage(url: URL(string: "https://t4.ftcdn.net/jpg/06/24/71/67/240_F_624716702_E4DEc0nj3IEQo7BhvVuDbAXVAldvHWNf.jpg")) { image in
//                            image
//                                .resizable()
//                                .scaledToFit()
//                                .frame(width: 60, height: 60)
//                                .clipShape(Circle())
//                        } placeholder: {
//                            Circle()
//                                .fill(Color.gray.opacity(0.2))
//                                .frame(width: 60, height: 60)
//                        }
//                        
//                        VStack(alignment: .leading, spacing: 4) {
//                            Text("<디버그모드 목업 미리보기용>")
//                                .font(.system(size: 18, weight: .bold))
//                            Text("월 500만원 이내 소비하기 챌린지 달성")
//                                .font(.system(size: 14))
//                                .foregroundColor(.gray)
//                        }
//                        Spacer()
//                    }
//                    .padding()
//                    .background(Color(UIColor.systemGray6))
//                    .cornerRadius(12)
//                    .padding(.horizontal)
//                }
//                #endif
                
                
                if let message = viewModel.message {
                    Text(message)
                        .font(.system(size: 16))
                        .foregroundColor(.gray)
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .center)
                } else {
                    LazyVStack(spacing: 16) {
                        ForEach(viewModel.completedChallenges, id: \.challengeName) { reward in
                            HStack(spacing: 16) {
                                AsyncImage(url: URL(string: reward.rewardImageUrl ?? "")) { image in
                                    image
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 60, height: 60)
                                        .clipShape(Circle())
                                } placeholder: {
                                    Circle()
                                        .fill(Color.gray.opacity(0.2))
                                        .frame(width: 60, height: 60)
                                }
                                
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(reward.rewardName ?? "")
                                        .font(.system(size: 18, weight: .bold))
                                    Text("\(reward.challengeName) 챌린지 달성")
                                        .font(.system(size: 14))
                                        .foregroundColor(.gray)
                                }
                                Spacer()
                            }
                            .padding()
                            .background(Color(UIColor.systemGray6))
                            .cornerRadius(12)
                        }
                    }
                    .padding()
                }
            }
        }
        .task {
            await viewModel.fetchCompletedChallenges()
        }
    }
}




#Preview {
    MyRewardView()
}
