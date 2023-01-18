//
//  JointGoal_SwiftUIApp.swift
//  JointGoal_SwiftUI
//
//  Created by 이민지 on 2022/09/21.
//

import SwiftUI
import UIKit
import Firebase
import KakaoSDKCommon
import KakaoSDKAuth
import RxKakaoSDKAuth
import NaverThirdPartyLogin
import BackgroundTasks

// no changes in your AppDelegate class
class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        print(">> your code here !!")
        return true
    }
}

@main
struct TryApp: App {
    @StateObject var environmentViewModel = EnvironmentViewModel()
    @AppStorage("userUid") var userUid = ""
    @AppStorage("isMember") var isMember = UserDefaults.standard.bool(forKey: "isMember")
    
    // inject into SwiftUI life-cycle via adaptor !!!
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    init() {
        FirebaseApp.configure()
        
        // kakao
//        let kakaoAppKey = Bundle.main.infoDictionary?["KAKAO_NATIVE_APP_KEY"] ?? ""
        KakaoSDK.initSDK(appKey: "328f856da160a70f73f8d54217ddd6eb")
        
        // 네이버 앱으로 로그인 허용
        NaverThirdPartyLoginConnection.getSharedInstance().isNaverAppOauthEnable = true
        // 브라우저 로그인 허용
        NaverThirdPartyLoginConnection.getSharedInstance().isInAppOauthEnable = true
        // 네이버 로그인 세로모드 고정
        NaverThirdPartyLoginConnection.getSharedInstance().setOnlyPortraitSupportInIphone(true)
        // NaverThirdPartyConstantsForApp.h에 선언한 상수 등록
        NaverThirdPartyLoginConnection.getSharedInstance().serviceUrlScheme = kServiceAppUrlScheme
        NaverThirdPartyLoginConnection.getSharedInstance().consumerKey = kConsumerKey
        NaverThirdPartyLoginConnection.getSharedInstance().consumerSecret = kConsumerSecret
        NaverThirdPartyLoginConnection.getSharedInstance().appName = kServiceAppName
        
        ShareVar.userUid = userUid
        ShareVar.isMember = isMember
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .onOpenURL { url in
                    let _ = print("naver login \(url)")
                    if (AuthApi.isKakaoTalkLoginUrl(url)) {
                        _ = AuthController.handleOpenUrl(url: url)
                    } else if (NaverThirdPartyLoginConnection.getSharedInstance() != nil) {
                        let _ = print("naver login \(url)")
                        NaverThirdPartyLoginConnection
                            .getSharedInstance()
                            .receiveAccessToken(url)
                    }
                }
                .preferredColorScheme(.dark)
                .environmentObject(environmentViewModel)
        }
    }
}
