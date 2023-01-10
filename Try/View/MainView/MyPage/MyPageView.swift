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
    
    @State var isRecomment = false
    @State var isSideBtn = false
    
    var body: some View {
        VStack(spacing: 0) {
            NavigationCustomBar(naviType: .mypage, isButton: $environmentViewModel.isSideBtn)
            
            WebImageView(url: myPageViewModel.userInfoData?.userProfile ?? "", width: device.widthScale(120), height: device.heightScale(120))
                .clipShape(Circle())
                .id(myPageViewModel.userInfoData?.uid ?? "")
                .padding(.top, 30)
            
            reCommendCodeView
            
            myFriendList
        }
        .onAppear {
            myPageViewModel.userInfoFetchData()
        }
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
            
            Button {
                isRecomment.toggle()
            } label: {
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
}
