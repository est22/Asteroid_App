//
//  ContentView.swift
//  Asteroid_front
//
//  Created by Lia An on 11/19/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("소행성").font(.starFontB(size: 24))
        }
    }
}

#Preview {
    ContentView()
}
