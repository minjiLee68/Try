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
            loginView
        }
        .frame(width: device.screenWidth)
        .overlay {
            if viewModel.isMember {
                MainView()
            } else if viewModel.isLoggedIn && !viewModel.isMember {
                ProfileSettingView()
            }
        }
    }
    
    var loginView: some View {
        VStack(spacing: 0) {
            Spacer()
            
            Button {
                viewModel.handleKakaoLogin()
                environmentViewModel.loginType = LoginType.kakao.rawValue
            } label: {
                Image("kakaoLogin")
                    .resizable()
                    .frame(width: device.widthScale(350), height: device.heightScale(50))
            }
            .padding(.top, 30)
            
            Button {
                viewModel.naverLoginDelegate()
                viewModel.naverLoginInstance?.requestThirdPartyLogin()
                environmentViewModel.loginType = LoginType.naver.rawValue
            } label: {
                Image("NaverLogin")
                    .resizable()
                    .frame(width: device.widthScale(350), height: device.heightScale(50))
            }
            .padding(.top, 30)
            
            Button {
                environmentViewModel.loginType = LoginType.apple.rawValue
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
