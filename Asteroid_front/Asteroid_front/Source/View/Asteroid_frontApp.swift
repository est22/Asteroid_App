//
//  Asteroid_frontApp.swift
//  Asteroid_front
//
//  Created by Lia An on 11/19/24.
//

import SwiftUI
import KakaoSDKCommon
import KakaoSDKAuth

@main
struct Asteroid_frontApp: App {
    @StateObject private var authViewModel = AuthViewModel()
    @StateObject private var socialAuthManager = SocialAuthManager()
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(authViewModel)
                .environmentObject(socialAuthManager)
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        // 카카오 개발자 콘솔에서 제공하는 네이티브 앱 키로 SDK 초기화
        let kakaoNativeAppKey = Bundle.main.kakaoNativeAppKey
        KakaoSDK.initSDK(appKey: kakaoNativeAppKey)
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
            if (AuthApi.isKakaoTalkLoginUrl(url)) {
                return AuthController.handleOpenUrl(url: url)
            }

            return false
        }
    
}
