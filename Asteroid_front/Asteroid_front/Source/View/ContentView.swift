//
//  ContentView.swift
//  Asteroid_front
//
//  Created by Lia An on 11/19/24.
//

import SwiftUI
// Text("소행성").font(.starFontB(size: 24))
struct ContentView: View {
    @EnvironmentObject private var authViewModel: AuthViewModel
    
    var body: some View {
        if authViewModel.isLoggedIn {
            Home()
        } else {
            if authViewModel.isRegistering {
                RegisterView(isRegistering: $authViewModel.isRegistering)
            } else {
                LoginView(isRegistering: $authViewModel.isRegistering)
            }
        }
    }
}

#Preview {
    ContentView()
}