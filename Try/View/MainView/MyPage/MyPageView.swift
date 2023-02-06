//
//  MyPageView.swift
//  Try
//
//  Created by 이민지 on 2023/01/04.
//

import SwiftUI
import Contacts

struct MyPageView: View {
    @EnvironmentObject var environmentViewModel: EnvironmentViewModel
    @StateObject var myPageViewModel = MyPageViewModel()
    @State var tabId = ""
    @State var searchText = ""
    @State var recommend = ""
    
    @State var isRecomment = false
    @State var isSideBtn = false
    
    var body: some View {
        VStack(spacing: 0) {
            NavigationCustomBar(naviType: .mypage, isButton: $environmentViewModel.isSideBtn)
            
            VStack(spacing: 8) {
                if myPageViewModel.userInfoData?.userProfile == "" {
                    Image("profile")
                        .mask(Circle().frame(width: device.widthScale(120), height: device.heightScale(120)))
                        .frame(width: device.widthScale(120), height: device.heightScale(120))
                        .padding(.top, 30)
                } else {
                    WebImageView(url: myPageViewModel.userInfoData?.userProfile ?? "", width: device.widthScale(120), height: device.heightScale(120))
                        .clipShape(Circle())
                        .id(myPageViewModel.userInfoData?.uid ?? "")
                        .padding(.top, 30)
                }
                
                NavigationLink(destination: ProfileEditorView(
                    nickName: myPageViewModel.userInfoData?.nickName ?? "",
                    introduce: myPageViewModel.userInfoData?.introduce ?? "",
                    reCommend: myPageViewModel.userInfoData?.reCommendCode ?? "",
                    settingType: .EditProfile)
                ) {
                    Text("프로필 편집")
                        .defaultFont(size: 14)
                }
            }
            
            reCommendCodeView
            
            myFriendList
            
            logoutView
        }
        .onAppear {
            myPageViewModel.userInfoFetchData()
        }
        .overlay(content: {
//            ZStack {
//                RoundedRectangle(cornerRadius: 6)
//                    .fill(Color.black)
//                    .shadow(color: Color.gray.opacity(0.6), radius: 6)
//                    .frame(width: device.widthScale(260), height: device.heightScale(260))
//                    .frame(maxHeight: .infinity, alignment: .center)
//                    .overlay {
//                        VStack {
//                            ZStack {
//                                TextField("코드 입력", text: $recommend)
//                            }
//                            .padding(.horizontal, 15)
//                            
//                            Button {
//                                myPageViewModel.getShareUser(code: recommend)
//                            } label: {
//                                Text("확인")
//                            }
//                        }
//                    }
//            }
        })
        .frame(width: device.screenWidth, height: device.screenHeight)
    }
    
    // MARK: 추천 코드
    var reCommendCodeView: some View {
        HStack(spacing: 8) {
            NavigationLink(destination: ReCommendedCodeView()) {
                RoundedRectangle(cornerRadius: 6)
                    .stroke(Color.gray.opacity(0.5))
                    .frame(height: device.heightScale(40))
                    .overlay {
                        Text("추천인 코드 보내기")
                            .foregroundColor(.white)
                            .defaultFont(size: 14)
                            .padding(.horizontal, -10)
                            .frame(maxWidth: .infinity, alignment: .center)
                    }
            }
            
            NavigationLink(destination: ProfileEditorView(
                nickName: myPageViewModel.userInfoData?.nickName ?? "",
                introduce: myPageViewModel.userInfoData?.introduce ?? "",
                reCommend: myPageViewModel.userInfoData?.reCommendCode ?? "",
                settingType: .EditCode)
            ) {
                RoundedRectangle(cornerRadius: 6)
                    .stroke(Color.gray.opacity(0.5))
                    .frame(height: device.heightScale(40))
                    .overlay {
                        Text("추천인 코드 입력하기")
                            .foregroundColor(.white)
                            .defaultFont(size: 14)
                            .padding(.horizontal, -10)
                            .frame(maxWidth: .infinity, alignment: .center)
                    }
            }
        }
        .padding(.top, 30)
        .padding(.horizontal, 20)
    }
    
    // MARK: 친구 리스트
    var myFriendList: some View {
        VStack {
            Text("내 친구 ")
                .foregroundColor(.white)
                .fontWeight(.bold)
                .defaultFont(size: 14)
                .padding(.horizontal, 20)
                .padding(.top, 50)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
    
    // MARK: 로그아웃
    var logoutView: some View {
        Button {
            switch environmentViewModel.loginType {
            case LoginType.kakao.rawValue:
                myPageViewModel.kakaoLogout()
            case LoginType.naver.rawValue:
                myPageViewModel.oauth20ConnectionDidFinishDeleteToken()
                print("네이버")
            case LoginType.apple.rawValue:
                print("애플")
            default:
                print("default")
            }
        } label: {
            Text("로그아웃 하기")
        }
        .padding(.top, 15)
    }
}
