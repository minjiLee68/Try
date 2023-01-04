//
//  LoginView.swift
//  Try
//
//  Created by 이민지 on 2022/12/28.
//

import SwiftUI

struct LoginView: View {
    @StateObject var viewModel = LoginViewModel()
    
    var body: some View {
        ZStack {
            if viewModel.isLogin {
                SignUpView()
            } else {
                loginView
            }
        }
        .frame(width: device.screenWidth)
        .modifier(AppBackgroundColor())
    }
    
    var loginView: some View {
        VStack(spacing: 0) {
            Spacer()
            
            Button {
                viewModel.handleKakaoLogin()
            } label: {
                Image("kakaoLogin")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: device.widthScale(350), height: device.heightScale(50))
            }
            .padding(.top, 30)
            
            Button {
                viewModel.naverLoginInstance?.requestThirdPartyLogin()
            } label: {
                Image("NaverLogin")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: device.widthScale(350), height: device.heightScale(50))
            }
            .padding(.top, 30)
            
            Spacer()
        }
    }
}
