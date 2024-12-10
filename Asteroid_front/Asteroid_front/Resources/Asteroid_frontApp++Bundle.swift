//
//  Asteroid_frontApp++Bundle.swift
//  Asteroid_front
//
//  Created by Lia An on 12/5/24.
//

import Foundation

extension Bundle {
    var kakaoNativeAppKey: String {
        guard let path = self.path(forResource: "API_KEY", ofType: "plist"),
              let plist = NSDictionary(contentsOfFile: path),
              let value = plist["KAKAO_NATIVE_APP_KEY"] as? String else {
            fatalError("API_KEY.plist에서 KAKAO_NATIVE_APP_KEY를 찾을 수 없습니다.")
        }
        return value
    }
}
