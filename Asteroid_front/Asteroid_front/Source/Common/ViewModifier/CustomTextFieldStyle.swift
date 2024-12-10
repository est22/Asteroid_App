//
//  CustomTextFieldStyle.swift
//  Asteroid_front
//
//  Created by Lia An on 12/4/24.
//
import SwiftUI

struct CustomTextFieldStyle: ViewModifier {
    var isError: Bool = false
    
    func body(content: Content) -> some View {
        content
            .padding()
            .background(Color.white)
            .cornerRadius(10)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(isError ? Color.red : Color.gray.opacity(0.3), lineWidth: 1)
            )
    }
}
