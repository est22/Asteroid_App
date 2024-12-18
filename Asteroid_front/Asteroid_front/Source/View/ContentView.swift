//
//  ContentView.swift
//  Asteroid_front
//
//  Created by Lia An on 11/19/24.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject private var authViewModel: AuthViewModel
    @EnvironmentObject var postViewModel: PostViewModel
    
    var body: some View {
        Group {
            if authViewModel.isLoggedIn {
                if !authViewModel.isInitialProfileSet {
                    InitialProfileView()
                } else {
                    MainTabView()
                }
            } else {
                if authViewModel.isRegistering {
                    RegisterView(isRegistering: $authViewModel.isRegistering)
                } else {
                    LoginView()
                }
            }
        }
    }
}

#Preview {
  ContentView().environmentObject(AuthViewModel())
}

