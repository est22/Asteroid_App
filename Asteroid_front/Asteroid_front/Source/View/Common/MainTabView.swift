//
//  MainTabView.swift
//  Asteroid_front
//
//  Created by Lia An on 12/4/24.
//

import SwiftUI

struct MainTabView: View {
    // Tab Bar
    private enum Tabs {
        case home, community, balanceVote, challenge, myPage
    }
    
    @State private var selectedTab: Tabs = .home // 기본값 home
    @StateObject private var postVM = PostViewModel()  // 여기서 생성
    
    var body: some View {
        TabView(selection: $selectedTab) {
            Group {
                home
                community
                balanceVote
                challenge
                myPage
            }
        }
        .tint(.keyColor)
        .edgesIgnoringSafeArea(.top)
    }
}

// 각 탭 뷰 정의
private extension MainTabView {
    var home: some View {
        Home()
            .tabItem {
                Image(systemName: "house.fill")
                Text("홈")
            }
            .tag(Tabs.home)
    }
    
    var community: some View {
        PostListView()
            .environmentObject(postVM)  // 환경에 등록
            .tabItem {
                Image(systemName: "ellipsis.message.fill")
                Text("커뮤니티")
            }
            .tag(Tabs.community)
    }
    
    var balanceVote: some View {
        VoteChoiceView()
            .tabItem {
                Image(systemName: "square.stack.3d.up")
                Text("밸런스")
            }
            .tag(Tabs.balanceVote)
    }
    
    var challenge: some View {
        Challenge()
            .tabItem {
                Image(systemName: "trophy.fill")
                Text("챌린지")
            }
            .tag(Tabs.challenge)
    }
    
    var myPage: some View {
        MyPage()
            .tabItem {
                Image(systemName: "person.fill")
                Text("마이페이지")
            }
            .tag(Tabs.myPage)
    }
}

#Preview {
    MainTabView()
}
