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
    
    
    // 파스텔 컬러 배열
    static let pastelColors: [Color] = [
        .pastelOrange, .pastelYellow, .pastelBlue, .pastelLavender,
        .pastelCoral, .pastelBeige, .pastelGreen
    ]
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
