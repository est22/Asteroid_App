//
//  SkeletonView.swift
//  Asteroid_front
//
//  Created by Lia An on 12/10/24.
//

import SwiftUI

struct SkeletonView: View {
    @State private var isAnimating = false
    
    // 커스텀 색상 설정
    let startColor: Color
    let middleColor: Color
    let endColor: Color
    
    init(
        startColor: Color = Color.gray.opacity(0.1),
        middleColor: Color = Color.gray.opacity(0.2),
        endColor: Color = Color.gray.opacity(0.1)
    ) {
        self.startColor = startColor
        self.middleColor = middleColor
        self.endColor = endColor
    }
    
    var body: some View {
        LinearGradient(
            gradient: Gradient(
                colors: [startColor, middleColor, endColor]
            ),
            startPoint: .leading,
            endPoint: .trailing
        )
        .aspectRatio(1, contentMode: .fit)
        .offset(x: isAnimating ? 400 : -400)
        .animation(
            Animation.linear(duration: 1.5)
                .repeatForever(autoreverses: false),
            value: isAnimating
        )
        .onAppear {
            isAnimating = true
        }
    }
}

#Preview {
    VStack(spacing: 20) {
        // 기본 스켈레톤
        SkeletonView()
        
        // 커스텀 색상 스켈레톤
        SkeletonView(
            startColor: Color.blue.opacity(0.1),
            middleColor: Color.blue.opacity(0.2),
            endColor: Color.blue.opacity(0.1)
        )
        
        // 앱 테마 색상 스켈레톤
        SkeletonView(
            startColor: Color.keyColor.opacity(0.1),
            middleColor: Color.keyColor.opacity(0.2),
            endColor: Color.keyColor.opacity(0.1)
        )
    }
    .padding()
}
