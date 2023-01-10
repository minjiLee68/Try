//
//  JointGoal_SwiftUIApp.swift
//  JointGoal_SwiftUI
//
//  Created by 이민지 on 2022/09/21.
//

import SwiftUI
import Firebase
import KakaoSDKCommon
import KakaoSDKAuth
import NaverThirdPartyLogin
import BackgroundTasks

@main
struct TryApp: App {
    @StateObject var environmentViewModel = EnvironmentViewModel()
    @AppStorage("userUid") var userUid = ""
    @AppStorage("isLogin") var isLogin = false
    
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
        ShareVar.isMember = isLogin
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .onOpenURL { url in
                    if (AuthApi.isKakaoTalkLoginUrl(url)) {
                        _ = AuthController.handleOpenUrl(url: url)
                    }
                    if (NaverThirdPartyLoginConnection
                        .getSharedInstance() != nil)
                    {
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
