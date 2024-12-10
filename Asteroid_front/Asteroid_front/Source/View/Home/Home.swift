//
//  Home.swift
//  Asteroid_front
//
//  Created by Lia An on 12/4/24.
//

import SwiftUI

struct Home: View {
    @EnvironmentObject private var authViewModel: AuthViewModel
    
    var body: some View {
        VStack {
            Text("홈 화면")
            
            Button("로그아웃") {
                authViewModel.logout()
            }
            
        }
    }
}

#Preview {
    Home()
}
