//
//  ColorExtension.swift
//  Asteroid_iOS
//
//  Created by Lia An on 11/18/24.
//

import SwiftUI

extension Color {
    static let keyColor = Color(hex: "#A2C0ED")
    static let color1 = Color(hex: "#EBBDA1")
    static let color2 = Color(hex: "#FBD960")
    static let color3 = Color(hex: "#A2D9A0")
    static let color4 = Color(hex: "#94C373")
    
    // 파스텔 컬러 추가
    static let pastelOrange = Color(hex: "#f8decc")
    static let pastelYellow = Color(hex: "#FFFFBA")
    static let pastelLavender = Color(hex: "#d9cdf7")
    static let pastelCoral = Color(hex: "#FFD6D6")
    static let pastelBeige = Color(hex: "#FFB3BA")
    static let pastelBlue = Color(hex: "#def0fb")
    static let pastelGreen = Color(hex: "#def7d2")
}

extension Color {
  init(hex: String) {
    let scanner = Scanner(string: hex)
    _ = scanner.scanString("#")
    
    var rgb: UInt64 = 0
    scanner.scanHexInt64(&rgb)
    
    let r = Double((rgb >> 16) & 0xFF) / 255.0
    let g = Double((rgb >>  8) & 0xFF) / 255.0
    let b = Double((rgb >>  0) & 0xFF) / 255.0
    self.init(red: r, green: g, blue: b)
  }
}

// 그라디언트 배열 추가
extension LinearGradient {
    static let pastelGradients: [LinearGradient] = [
        LinearGradient(
            colors: [.pastelOrange.opacity(0.8), .pastelOrange.opacity(0.4)],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        ),
        LinearGradient(
            colors: [.pastelYellow.opacity(0.8), .pastelYellow.opacity(0.4)],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        ),
        LinearGradient(
            colors: [.pastelBlue.opacity(0.8), .pastelBlue.opacity(0.4)],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        ),
        LinearGradient(
            colors: [.pastelLavender.opacity(0.8), .pastelLavender.opacity(0.4)],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        ),
        LinearGradient(
            colors: [.pastelCoral.opacity(0.8), .pastelCoral.opacity(0.4)],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        ),
        LinearGradient(
            colors: [.pastelBeige.opacity(0.8), .pastelBeige.opacity(0.4)],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        ),
        LinearGradient(
            colors: [.pastelGreen.opacity(0.8), .pastelGreen.opacity(0.4)],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    ]
}
