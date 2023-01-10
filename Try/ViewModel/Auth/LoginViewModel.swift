//
//  LoginViewModel.swift
//  Try
//
//  Created by 이민지 on 2022/12/28.
//

import SwiftUI
import UIKit
import Foundation
import FirebaseFirestore
import FirebaseAuth
import KakaoSDKAuth
import KakaoSDKUser
import NaverThirdPartyLogin
import Alamofire

class LoginViewModel: NSObject, ObservableObject {
    @Published var naverLoginInstance = NaverThirdPartyLoginConnection.getSharedInstance()
    @Published var isLogin = false
    @Published var isLoggedIn = false
    @AppStorage("userUid") var userUid = ""
    @AppStorage("isMember") var isMember = false
    @AppStorage("recommendCode") var recommendCode = ""
    
    let db = Firestore.firestore()
    
    func login(email: String, password: String) {
        // 파이어베이스 유저 생성 (이메일로 회원가입)
        Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
            self.isLogin = true
            if let error = error {
                print("파이어베이스 사용자 생성 실패 -> \(error.localizedDescription)")
                Auth.auth().signIn(withEmail: email, password: password)
            } else {
                print("파이어베이스 사용자 생성")
            }
            self.userUid = Auth.auth().currentUser?.uid ?? ""
            ShareVar.userUid = Auth.auth().currentUser?.uid ?? ""
            
            self.db.collection(CollectionName.UserInfo.rawValue).getDocuments { (querySnapshot, error) in
                if let error {
                    print("get document error : \(error.localizedDescription)")
                } else {
                    if let querySnapshot {
                        for doc in querySnapshot.documents {
                            if self.userUid == doc.documentID {
                                self.isMember = true
                            }
                        }
                    }
                }
            }
        }
    }
}

// MARK: Kakao Login
extension LoginViewModel {
    // MARK: Kakao User Info
    func handleKakaoLogin() {
        if self.isMember {
            ShareVar.userUid = self.userUid
            self.isLogin = true
        } else {
            if (UserApi.isKakaoTalkLoginAvailable()) {
                //카카오톡이 설치되어있다면 카카오톡을 통한 로그인 진행
                UserApi.shared.loginWithKakaoTalk {(oauthToken, error) in
                    if let error = error {
                        print("에러",error)
                    } else {
                        self.loginFirebase()
                        _ = oauthToken
                    }
                }
            } else {
                //카카오톡이 설치되어있지 않다면 사파리를 통한 로그인 진행
                UserApi.shared.loginWithKakaoAccount() {(oauthToken, error) in
                    if let error = error {
                        print("에러",error)
                    } else {
                        self.loginFirebase()
                        _ = oauthToken
                    }
                }
            }
        }
    }
    
    // 로그아웃
    func handleKakaoLogout() async -> Bool {
        await withCheckedContinuation({ continuation in
            UserApi.shared.logout { error in
                if let error = error {
                    print(error)
                    continuation.resume(returning: false)
                } else {
                    continuation.resume(returning: true)
                }
            }
        })
    }
    
    func kakaoLogout() {
        Task {
            if await handleKakaoLogout() {
                isLoggedIn = false
            }
        }
    }
    
    func loginFirebase() {
        UserApi.shared.me { user, error in
            if let error = error {
                print("kakao user info error \(error.localizedDescription)")
            } else {
                print("kakao user info \(user?.kakaoAccount?.email ?? ""), \(String(describing: user?.id))")
                self.login(email: (user?.kakaoAccount?.email ?? ""), password: "\(String(describing: user?.id))")
            }
        }
    }
}

// MARK: Naver Login
extension LoginViewModel: NaverThirdPartyLoginConnectionDelegate {
    func naverLoginDelegate() {
        self.naverLoginInstance?.delegate = self
    }
    
    //로그인 성공시 naver userInfo 가져오기
    private func getNaverInfo() {
        guard let isValidAccessToken = self.naverLoginInstance?.isValidAccessTokenExpireTimeNow() else { return }
        
        if !isValidAccessToken {
            print("Token Invalid")
            return
            
        }
        
        guard let tokenType = naverLoginInstance?.tokenType else { return }
        guard let accessToken = naverLoginInstance?.accessToken else { return }
        let authorization = "\(tokenType) \(accessToken)"
        
        LoginService.naverLogin(authorization: authorization, type: response_naver_login.self) { res in
            switch res {
            case is response_naver_login:
                let model = res as! response_naver_login
                let email = model.response.email
//                let signupType = "naver"
                let socialID = model.response.id
                self.login(email: email, password: socialID)
                
                print("Naver Login Success \(model.message)")
                print("Naver Login Info:\(email) \(socialID)")
                
            case is FailResponse:
                let fail = res as! FailResponse
//                self.alertType = LoginAlerts(id: .Naver)
                print("Naver Login Fail \(fail.message)")
                
            default:
                print("Naver Login Fail")
                
            }
        }
    }
    
//    private func getNaverInfo() {
//        guard let isValidAccessToken = self.naverLoginInstance?.isValidAccessTokenExpireTimeNow() else { return }
//
//        if !isValidAccessToken {
//            return
//        }
//
//        guard let tokenType = naverLoginInstance?.tokenType else { return }
//        guard let accessToken = naverLoginInstance?.accessToken else { return }
//        let authorization = "\(tokenType) \(accessToken)"
//    }
    
    // 로그인에 성공한 경우 호출
    func oauth20ConnectionDidFinishRequestACTokenWithAuthCode() {
        print("Success login")
        getNaverInfo()
    }
    
    // referesh token
    func oauth20ConnectionDidFinishRequestACTokenWithRefreshToken() {
        //        naverLoginInstance?.accessToken
    }
    
    // 로그아웃
    func oauth20ConnectionDidFinishDeleteToken() {
        naverLoginInstance?.requestDeleteToken()
        print("log out")
    }
    
    // 모든 error
    func oauth20Connection(_ oauthConnection: NaverThirdPartyLoginConnection!, didFailWithError error: Error!) {
        print("error = \(error.localizedDescription)")
    }
}
