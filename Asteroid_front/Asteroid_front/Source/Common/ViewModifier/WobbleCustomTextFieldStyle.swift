//
//  WobbleCustomTextFieldStyle.swift
//  Asteroid_front
//
//  Created by Lia An on 12/4/24.
//


import SwiftUI

struct WobbleCustomTextFieldStyle: ViewModifier {
    var isError: Bool = false  // 에러 상태를 받는 파라미터 추가
    
    func body(content: Content) -> some View {
        content
            .padding()
            .background(Color.white)
            .cornerRadius(10)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(isError ? Color.red : Color.gray.opacity(0.3), lineWidth: 1)  // 에러 상태에 따라 테두리 색상 변경
            )
    }
}
