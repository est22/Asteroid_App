//
//  ContentView.swift
//  Asteroid_front
//
//  Created by Lia An on 11/19/24.
//

import SwiftUI

struct ContentView: View {
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
}
