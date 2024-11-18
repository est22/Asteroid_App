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
//  static let primaryShadow = Color.primary.opacity(0.2)
//  static let secondaryText = Color(hex: "#6e6e6e")
//  static let background = Color(UIColor.systemGray6)
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
