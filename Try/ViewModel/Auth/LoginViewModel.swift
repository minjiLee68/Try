//
//  LoginViewModel.swift
//  Try
//
//  Created by 이민지 on 2022/12/28.
//

import SwiftUI
import UIKit
import Foundation
import RxSwift
import FirebaseFirestore
import FirebaseAuth
import KakaoSDKAuth
import KakaoSDKUser
import RxKakaoSDKAuth
import RxKakaoSDKUser
import NaverThirdPartyLogin
import Alamofire

class LoginViewModel: NSObject, ObservableObject {
    @Published var naverLoginInstance = NaverThirdPartyLoginConnection.getSharedInstance()
    @Published var isLoggedIn = false
    @AppStorage("userUid") var userUid = (UserDefaults.standard.string(forKey: "userUid") ?? "")
    @AppStorage("isMember") var isMember = UserDefaults.standard.bool(forKey: "isMember")
    
    let db = Firestore.firestore()
    let disposeBag = DisposeBag()
    
    func login(email: String, password: String) {
        // 파이어베이스 유저 생성 (이메일로 회원가입)
        Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
            if let error = error {
                print("파이어베이스 사용자 생성 실패 -> \(error.localizedDescription)")
                Auth.auth().signIn(withEmail: email, password: password)
                self.userUid = Auth.auth().currentUser?.uid ?? ""
            } else {
                self.userUid = Auth.auth().currentUser?.uid ?? ""
                print("파이어베이스 사용자 생성")
            }
            ShareVar.userUid = self.userUid
            self.ifUserDocuments(userUid: self.userUid)
            self.isLoggedIn = true
        }
    }
    
    // MARK: 유저 정보가 있는가?
    func ifUserDocuments(userUid: String) {
        self.db.collection(CollectionName.UserInfo.rawValue).getDocuments { (querySnapshot, error) in
            if let error {
                print("get document error : \(error.localizedDescription)")
            } else {
                guard let snapshot = querySnapshot else { return }
                for doc in snapshot.documents {
                    if userUid == doc.documentID {
                        print("docId \(doc.documentID)")
                        self.isMember = true
                        return
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
        if (UserApi.isKakaoTalkLoginAvailable()) {
            //카카오톡이 설치되어있다면 카카오톡을 통한 로그인 진행
            UserApi.shared.loginWithKakaoTalk {(oauthToken, error) in
                if let error = error {
                    print("loginWithKakaoTalk error \(error)")
                } else {
                    self.loginFirebase()
                    print("loginWithKakaoTalk success")
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
    
    // kakao app
    func handleLoginWithKakaoTalkApp() async -> Bool {
        await withCheckedContinuation({ continuation in
            UserApi.shared.rx.loginWithKakaoTalk()
                .subscribe (onNext: { oauthToken in
                    print("loginWithKakaoTalk success")
                    continuation.resume(returning: true)
                    _ = oauthToken
                }, onError: { error in
                    print("loginWithKakaoTalk error")
                    continuation.resume(returning: false)
                })
                .disposed(by: disposeBag)
        })
    }
    
    // kakao not app
    func handleWithKakaoAccount() async throws -> Bool {
        await withCheckedContinuation({ continuation in
            UserApi.shared.loginWithKakaoAccount { oauthToken, error in
                if let error = error {
                    print("kakao token error \(error)")
                    continuation.resume(returning: false)
                } else {
                    continuation.resume(returning: true)
                    _ = oauthToken
                }
            }
        })
    }
    
    // 로그인 정보 파이어베이스에 저장
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
    
    // 로그아웃
    func handleKakaoLogout() async -> Bool {
        await withCheckedContinuation{ continuation in
            UserApi.shared.rx.logout()
                .subscribe(onCompleted: {
                    print("kakao logout success")
                    continuation.resume(returning: true)
                }) { error in
                    print("kakao logout error")
                    continuation.resume(returning: false)
                }
                .disposed(by: disposeBag)
        }
    }
    
    func kakaoLogout() {
        Task {
            if await handleKakaoLogout() {
                isLoggedIn = false
            }
        }
    }
}

// MARK: Naver Login
extension LoginViewModel: UIApplicationDelegate, NaverThirdPartyLoginConnectionDelegate {
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
                
            case is FailResponse:
                let fail = res as! FailResponse
                print("Naver Login FailResponse \(fail)")
            default:
                print("Naver Login Fail")
            }
        }
    }
    
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
