//
//  ChallengeRankingView.swift
//  Asteroid_front
//
//  Created by Lia An on 12/6/24.
//

import SwiftUI

struct ChallengeRankingView: View {
    @StateObject private var viewModel = ChallengeRankingViewModel()
    @State private var selectedFilter = 0
    @State private var selectedChallengeId: Int? = nil
    
    var filteredRankings: [ChallengeRanking] {
        if selectedFilter == 1 {
            return viewModel.filterRankings(by: selectedChallengeId)
        }
        return viewModel.rankings
    }
    
    var body: some View {
        VStack(spacing: 4) {
            // 고정될 제목 부분
            HStack {
                Text("🏆챌린지 랭킹")
                    .font(.system(size: 20, weight: .bold))
                Spacer()
            }
            .padding(.horizontal)
            .background(Color.white)
            .zIndex(1)
            
            // 애니메이션이 적용될 필터와 랭킹 부분
            VStack(spacing: 8) {
                // 필터 버튼
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        FilterButton(title: "포인트순", isSelected: selectedFilter == 0) {
                            withAnimation(.spring()) {
                                selectedFilter = 0
                            }
                        }
                        FilterButton(title: "챌린지별 랭킹", isSelected: selectedFilter == 1) {
                            withAnimation(.spring()) {
                                selectedFilter = 1
                            }
                        }
//                        FilterButton(title: "주간랭킹", isSelected: selectedFilter == 2) {
//                            withAnimation(.spring()) {
//                                selectedFilter = 2
//                            }
//                        }
                    }
                    .padding(.horizontal)
                }
                
                // 챌린지별 필터가 선택된 경우에만 챌린지 목록 표시
                if selectedFilter == 1 {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 8) {
                            ChallengeFilterButton(
                                title: "전체",
                                isSelected: selectedChallengeId == nil
                            ) {
                                selectedChallengeId = nil
                            }
                            
                            ForEach(viewModel.rankings, id: \.challengeId) { ranking in
                                ChallengeFilterButton(
                                    title: ranking.challengeName,
                                    isSelected: selectedChallengeId == ranking.challengeId
                                ) {
                                    selectedChallengeId = ranking.challengeId
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                }
                
                // 랭킹 리스트
                VStack(spacing: 0) {
                    ForEach(0..<min(5, filteredRankings.first?.topUsers.count ?? 0), id: \.self) { index in
                        if let user = filteredRankings.first?.topUsers[index] {
                            RankingRow(ranking: user, rank: index + 1)
                            
                            if index < 4 {
                                Divider()
                                    .padding(.horizontal)
                            }
                        }
                    }
                }
                .background(Color(.systemBackground))
                .cornerRadius(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.keyColor, lineWidth: 1)
                )
                .padding(.horizontal)
            }
            .transition(.move(edge: .top))
        }
        .frame(height: UIScreen.main.bounds.height * 0.45)
        .task {
            await viewModel.fetchRankings()
        }
    }
}

struct RankingRow: View {
    let ranking: UserRanking?
    let rank: Int
    
    var body: some View {
        HStack(spacing: 12) {
            // 순위 표시
            switch rank {
            case 1:
                Text("🥇")
                    .frame(width: 24)
            case 2:
                Text("🥈")
                    .frame(width: 24)
            case 3:
                Text("🥉")
                    .frame(width: 24)
            default:
                Text("#\(rank)")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.gray)
                    .frame(width: 24)
            }
            
            // 프로필 이미지
            if let profilePicture = ranking?.profilePicture {
                AsyncImage(url: URL(string: profilePicture)) { image in
                    image
                        .resizable()
                        .scaledToFill()
                } placeholder: {
                    Image(systemName: "person.circle.fill")
                        .resizable()
                }
                .frame(width: 32, height: 32)
                .clipShape(Circle())
            } else {
                Image(systemName: "person.circle.fill")
                    .resizable()
                    .frame(width: 32, height: 32)
                    .foregroundColor(.gray)
            }
            
            // 닉네임과 좌우명을 VStack으로 배치
            VStack(alignment: .leading, spacing: 2) {
                Text(ranking?.nickname ?? "챌린지에 참여해서 순위에 들어보세요!")
                    .font(.system(size: 15, weight: .medium))
                
                if let motto = ranking?.motto {
                    Text(motto)
                        .font(.system(size: 12))
                        .foregroundColor(.gray)
                }
            }
            
            Spacer()
            
            // 포인트
            HStack(spacing: 0) {
                Text("\(ranking?.credit ?? 0)")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(.keyColor)
                Text("점")
                    .font(.system(size: 14))
                    .foregroundColor(.gray)
            }
        }
        .padding(.vertical, 8) 
        .padding(.horizontal)
    }
}

struct FilterButton: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 14, weight: isSelected ? .semibold : .regular))
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(isSelected ? Color.keyColor : Color.gray.opacity(0.1))
                .foregroundColor(isSelected ? .white : .black)
                .cornerRadius(20)
        }
    }
}

struct ChallengeFilterButton: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 13))
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(isSelected ? Color.keyColor.opacity(0.2) : Color.gray.opacity(0.1))
                .foregroundColor(isSelected ? .keyColor : .gray)
                .cornerRadius(15)
        }
    }
}
#Preview {
    ChallengeRankingView()
}
