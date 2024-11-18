//
//  FontExtension.swift
//  Asteroid_iOS
//
//  Created by Lia An on 11/18/24.
//
import SwiftUI

func checkfont() {
    for family in UIFont.familyNames {
        print(family)
        for name in UIFont.fontNames(forFamilyName: family) {
            print(name)
        }
    }
}


struct AppFontName {
    static let star_B = "Hakgyoansim Byeolbichhaneul OTF B"
    static let star_L = "Hakgyoansim Byeolbichhaneul OTF L"
}

extension Font {
    static func starFontB(size: CGFloat) -> Font {
        return Font.custom(AppFontName.star_B, size: size)
    }
    
    static func starFontL(size: CGFloat) -> Font {
        return Font.custom(AppFontName.star_L, size: size)
    }
}
