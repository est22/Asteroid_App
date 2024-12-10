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
        Group {
            if authViewModel.isLoggedIn {
                if !authViewModel.isInitialProfileSet {
                    InitialProfileView()
                        .onAppear {
                            print("Displaying InitialProfileView")
                        }
                } else {
                    MainTabView()
                        .onAppear {
                            print("Displaying MainTabView")
                        }
                }
            } else {
                if authViewModel.isRegistering {
                    RegisterView(isRegistering: $authViewModel.isRegistering)
                        .onAppear {
                            print("Displaying RegisterView")
                        }
                } else {
                    LoginView()
                        .onAppear {
                            print("Displaying LoginView")
                        }
                }
            }
        }
        .onChange(of: authViewModel.isLoggedIn) { newValue in
            print("ContentView detected isLoggedIn change to: \(newValue)")
        }
        .onChange(of: authViewModel.isInitialProfileSet) { newValue in
            print("ContentView detected isInitialProfileSet change to: \(newValue)")
        }
        .onAppear {
            print("ContentView appeared - Current State:")
            print("isLoggedIn: \(authViewModel.isLoggedIn)")
            print("isInitialProfileSet: \(authViewModel.isInitialProfileSet)")
            print("isRegistering: \(authViewModel.isRegistering)")
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(AuthViewModel())
}

