//
//  MyPage.swift
//  Asteroid_front
//
//  Created by Lia An on 12/4/24.
//

import SwiftUI

struct MyPage: View {
    @EnvironmentObject private var viewModel: AuthViewModel
    @State private var showingEditProfile = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                // 프로필 이미지와 수정 버튼
                ZStack(alignment: .bottomTrailing) {
                    if let profilePhoto = viewModel.profilePhoto, let url = URL(string: profilePhoto) {
                        AsyncImage(url: url) { image in
                            image
                                .resizable()
                                .scaledToFill()
                                .frame(width: 120, height: 120)
                                .clipShape(Circle())
                        } placeholder: {
                            Image(systemName: "person.circle.fill")
                                .resizable()
                                .frame(width: 120, height: 120)
                                .foregroundColor(.gray)
                        }
                    } else {
                        Image(systemName: "person.circle.fill")
                            .resizable()
                            .frame(width: 120, height: 120)
                            .foregroundColor(.gray)
                    }
                    
                    Button(action: {
                        showingEditProfile = true
                    }) {
                        Image(systemName: "pencil.circle.fill")
                            .resizable()
                            .frame(width: 32, height: 32)
                            .foregroundColor(.white)
                            .background(Circle().fill(Color.keyColor))
                    }
                    .offset(x: 5, y: 5)
                }
                .padding(.top, 20)
                
                // 닉네임과 소비좌우명
                HStack {
                    VStack(alignment: .leading, spacing: 15) {
                        HStack {
                            Text("닉네임")
                                .font(.system(size: 16, weight: .bold))
                            Spacer()
                            Text(viewModel.nickname)
                                .font(.system(size: 16))
                        }
                        
                        HStack {
                            Text("소비좌우명")
                                .font(.system(size: 16, weight: .bold))
                            Spacer()
                            Text(viewModel.motto)
                                .font(.system(size: 16))
                        }
                    }
                    .padding(.horizontal, 20)
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
                    
                    NavigationLink(destination: ChallengeRewardsView()) {
                        MyPageButton(title: "내 챌린지 보상", emoji: "🎯")
                    }
                }
                .padding(.horizontal, 20)
                
                Spacer()
            }
            .navigationBarTitleDisplayMode(.inline)
            .sheet(isPresented: $showingEditProfile) {
                EditProfileView(currentNickname: viewModel.nickname, currentMotto: viewModel.motto)
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
