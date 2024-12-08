//
//  MyPage.swift
//  Asteroid_front
//
//  Created by Lia An on 12/4/24.
//

import SwiftUI

struct MyPage: View {
    @StateObject private var profileViewModel = ProfileViewModel()
    @State private var showingEditProfile = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                // 프로필 이미지와 수정 버튼
                ZStack(alignment: .bottomTrailing) {
                    if let profilePhoto = profileViewModel.profilePhoto, let url = URL(string: profilePhoto) {
                        AsyncImage(url: url) { image in
                            image
                                .resizable()
                                .scaledToFill()
                                .frame(width: 100, height: 100)
                                .clipShape(Circle())
                        } placeholder: {
                            Image(systemName: "person.circle.fill")
                                .resizable()
                                .frame(width: 100, height: 100)
                                .foregroundColor(.gray)
                        }
                    } else {
                        Image(systemName: "person.circle.fill")
                            .resizable()
                            .frame(width: 100, height: 100)
                            .foregroundColor(.gray.opacity(0.5))
                    }
                    
                    Button(action: {
                        showingEditProfile = true
                    }) {
                        Image(systemName: "pencil.circle.fill")
                            .resizable()
                            .frame(width: 32, height: 32)
                            .foregroundColor(Color.keyColor)
                            .background(Circle().fill(Color.white))
                    }
                    .offset(x: 8, y: -8)
                }
                .padding(.bottom, 20)
                
                // 닉네임과 소비좌우명
                HStack {
                    VStack(alignment: .leading, spacing: 15) {
                        HStack {
                            Text("닉네임")
                                .font(.system(size: 16, weight: .bold))
                            Spacer()
                            Text(profileViewModel.nickname)
                                .font(.system(size: 16))
                        }
                        
                        HStack {
                            Text("소비좌우명")
                                .font(.system(size: 16, weight: .bold))
                            Spacer()
                            Text(profileViewModel.motto)
                                .font(.system(size: 16))
                        }
                    }
                    .padding(.horizontal, 25)
                }
                
                Divider()
                    .padding(.vertical, 10)
                
                // 네비게이션 링크 버튼들
                VStack(spacing: 12) {
                    NavigationLink(destination: MessageView()) {
                        MyPageButton(title: "내 쪽지함", emoji: "✉️")
                    }
                    
                    NavigationLink(destination: MyPostView()) {
                        MyPageButton(title: "내 게시글", emoji: "✏️")
                    }
                    
                    NavigationLink(destination: MyCommentView()) {
                        MyPageButton(title: "내 댓글", emoji: "💭")
                    }
                    
                    NavigationLink(destination: LikedPostView()) {
                        MyPageButton(title: "좋아요한 게시글", emoji: "👍")
                    }
                    
                    NavigationLink(destination: MyRewardView()) {
                        MyPageButton(title: "내 챌린지 보상", emoji: "🎯")
                    }
                }
                .padding(.horizontal, 20)
                
//                Spacer()
            }
            .navigationBarTitleDisplayMode(.inline)
            .sheet(isPresented: $showingEditProfile) {
                EditProfileView(viewModel: profileViewModel)
                    .environmentObject(profileViewModel)
                    .presentationDetents([.medium])
            }
            .task {
                do {
                    try await profileViewModel.fetchProfile()
                } catch {
                    print("프로필 불러오기 실패: \(error.localizedDescription)")
                    // 필요한 경우 에러 처리 로직 추가
                    // 예: 알림 표시, 에러 상태 업데이트 등
                }
            }
        }
    }
}

struct MyPageButton: View {
    let title: String
    let emoji: String
    
    var body: some View {
        HStack {
            Text(title)
                .font(.system(size: 16))
                .foregroundColor(.black)
            Spacer()
            Text(emoji)
                .font(.system(size: 20))
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color.white)
        .cornerRadius(15)
        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
    }
}

#Preview {
    NavigationView {
        MyPage()
            .environmentObject(AuthViewModel())
    }
}
