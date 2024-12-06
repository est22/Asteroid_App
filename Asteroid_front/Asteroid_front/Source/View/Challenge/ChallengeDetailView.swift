//
//  ChallengeDetailView.swift
//  Asteroid_front
//
//  Created by Lia An on 12/6/24.
//

import SwiftUI

struct ChallengeDetailView: View {
    @Environment(\.presentationMode) var presentationMode
    let challengeId: Int
    let challengeName: String
    @ObservedObject var viewModel: ChallengeViewModel

    var body: some View {
        ZStack {
            ScrollView {
                VStack(spacing: 24) {
                    // 챌린지 제목
                    Text(challengeName)
                        .font(.system(size: 22, weight: .bold))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 16)
                        .padding(.top, 8)

                    // 기간과 보상 (배경 포함)
                    VStack(spacing: 16) {
                        // 배경 네모 영역
                        ZStack {
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Color(UIColor.systemGray6)) // 네모 배경 색상 (사진처럼 밝은 그레이)
                                .frame(maxWidth: .infinity)
                                .padding(.horizontal, 16)

                            VStack(spacing: 12) {
                                Text("챌린지 기간: \(viewModel.selectedChallenge?.period ?? 0)주")
                                    .font(.system(size: 16, weight: .regular))
                                    .foregroundColor(.secondary)

                                // 이미지
                                AsyncImage(url: URL(string: viewModel.selectedChallenge?.rewardImageUrl ?? "")) { image in
                                    image
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 140, height: 140) // 적절한 크기 조정
                                        .clipShape(Circle())
                                } placeholder: {
                                    ProgressView()
                                        .frame(width: 140, height: 140)
                                }

                                // 텍스트
                                Text("챌린지 달성 시 \(viewModel.selectedChallenge?.rewardName ?? "리워드")을 받아요")
                                    .font(.system(size: 14, weight: .regular))
                                    .multilineTextAlignment(.center)
                            }
                            .padding(16) // 배경 안쪽 여백
                        }
                    }

                    // 참여자 정보
                    VStack(spacing: 12) {
                        Text("참여중인 유저 \(viewModel.selectedChallenge?.participantCount ?? 0)명")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(.orange)

                        Text("유저 참여 현황")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.secondary)

                        // 유저 그리드
                        LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 12), count: 4), spacing: 12) {
                            ForEach(0..<30, id: \.self) { _ in
                                Image(systemName: "person.crop.circle.fill")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 60, height: 60) // 적절한 아이콘 크기
                                    .foregroundColor(.gray)
                            }
                        }
                        .padding(.horizontal, 16)
                    }
                }
            }

            // Floating Action Button
            VStack {
                Spacer()
                Button(action: {
                    // 참여 액션 추가
                }) {
                    Text("나도 참여하기")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.black)
                        .cornerRadius(12)
                        .shadow(color: .black.opacity(0.2), radius: 4, x: 0, y: 4)
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 16)
            }
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarItems(
            leading: Button(action: {
                presentationMode.wrappedValue.dismiss()
            }) {
                Image(systemName: "chevron.left")
                    .foregroundColor(.primary)
            }
        )
        .task {
            await viewModel.fetchChallengeDetail(id: challengeId)
        }
    }
}

#Preview {
    NavigationView {
        ChallengeDetailView(
            challengeId: 1,
            challengeName: "3일 동안 현금만 사용하기",
            viewModel: ChallengeViewModel()
        )
    }
}
