//
//  LoginView.swift
//  Try
//
//  Created by 이민지 on 2022/12/28.
//

import SwiftUI

struct LoginView: View {
    @EnvironmentObject var environmentViewModel: EnvironmentViewModel
    @StateObject var viewModel = LoginViewModel()
    
    var body: some View {
        ZStack {
            if !viewModel.isLoggedIn {
                loginView
            } else if !viewModel.isMember && viewModel.isLoggedIn {
                ProfileSettingView()
            }
            
            if viewModel.isMember && viewModel.isLoggedIn {
                MainView()
            }
        }
        .frame(width: device.screenWidth)
    }
    
    var loginView: some View {
        VStack(spacing: 0) {
            Spacer()
            
            Button {
                ShareVar.loginType = LoginType.kakao.rawValue
                viewModel.handleKakaoLogin()
            } label: {
                Image("kakaoLogin")
                    .resizable()
                    .frame(width: device.widthScale(350), height: device.heightScale(50))
            }
            .padding(.top, 30)
            
            Button {
                ShareVar.loginType = LoginType.naver.rawValue
                viewModel.naverLoginDelegate()
                viewModel.naverLoginInstance?.requestThirdPartyLogin()
            } label: {
                Image("NaverLogin")
                    .resizable()
                    .frame(width: device.widthScale(350), height: device.heightScale(50))
            }
            .padding(.top, 30)
            
            Button {
                ShareVar.loginType = LoginType.apple.rawValue
            } label: {
                Image("AppleLogin")
                    .resizable()
                    .frame(width: device.widthScale(350), height: device.heightScale(50))
            }
            .padding(.top, 30)
            
            Spacer()
        }
    }
}
