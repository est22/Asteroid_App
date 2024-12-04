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
    @State private var isRegistering = false
    
    var body: some View {
        if authViewModel.isLoggedIn {
            Home()
        } else {
            if isRegistering {
                RegisterView(isRegistering: $isRegistering)
            } else {
                LoginView(isRegistering: $isRegistering)
            }
        }
    }
}

#Preview {
    ContentView()
}
