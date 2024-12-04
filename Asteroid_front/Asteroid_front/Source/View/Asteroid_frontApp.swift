//
//  Asteroid_frontApp.swift
//  Asteroid_front
//
//  Created by Lia An on 11/19/24.
//

import SwiftUI

@main
struct Asteroid_frontApp: App {
    @StateObject private var authViewModel = AuthViewModel()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(authViewModel)
        }
    }
}