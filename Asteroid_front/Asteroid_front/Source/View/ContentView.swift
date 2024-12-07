//
//  ContentView.swift
//  Asteroid_front
//
//  Created by Lia An on 11/19/24.
//

import SwiftUI
// Text("소행성").font(.starFontB(size: 24))
struct ContentView: View {
    @EnvironmentObject private var viewModel: AuthViewModel
    
    var body: some View {
        if viewModel.isLoggedIn {
            if !viewModel.isInitialProfileSet {
                InitialProfileView()
            } else {
                MainTabView()
            }
        } else {
            if viewModel.isRegistering {
                RegisterView(isRegistering: $viewModel.isRegistering)
            } else {
                LoginView()
            }
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(AuthViewModel())
}
