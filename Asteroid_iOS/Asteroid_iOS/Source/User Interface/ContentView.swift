//
//  ContentView.swift
//  Asteroid_iOS
//
//  Created by 홍은영 on 11/13/24.
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
        .padding()
    }
}

#Preview {
    ContentView()
}
