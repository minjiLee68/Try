//
//  OtherPageView.swift
//  Try
//
//  Created by 이민지 on 2023/02/07.
//

import SwiftUI

struct OtherPageView: View {
    @EnvironmentObject var environmentViewModel: EnvironmentViewModel
    @StateObject var otherPageViewModel = OtherPageViewModel()
    
    @State var userUid: String
    @State var tabId = ""
    @State var searchText = ""
    
    @State var isRecomment = false
    @State var isSideBtn = false
    
    var body: some View {
        VStack(spacing: 0) {
            NavigationCustomBar(naviType: .mypage, isButton: $environmentViewModel.isSideBtn)
            
            WebImageView(url: otherPageViewModel.userInfoData?.userProfile ?? "", width: device.widthScale(120), height: device.heightScale(120))
                .clipShape(Circle())
                .id(otherPageViewModel.userInfoData?.uid ?? "")
                .padding(.top, 30)
            
            requestView
            
            myFriendList
        }
        .onAppear {
            otherPageViewModel.userInfoFetchData(userUid: userUid)
        }
        .frame(width: device.screenWidth, height: device.screenHeight)
    }
    
    // MARK: 친구요청 보내기
    var requestView: some View {
        HStack(spacing: 8) {
            Button {
                
            } label: {
                RoundedRectangle(cornerRadius: 6)
                    .stroke(Color.gray.opacity(0.5))
                    .frame(height: device.heightScale(40))
                    .overlay {
                        Text("친구 요청 보내기")
                            .foregroundColor(.white)
                            .defaultFont(size: 14)
                            .padding(.horizontal, -6)
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
            NavigationLink {
                EmptyView()
            } label: {
                HStack(spacing: 5) {
                    Text("친구 리스트 0")
                        .foregroundColor(.white)
                        .fontWeight(.bold)
                        .defaultFont(size: 16)
                        .padding(.horizontal, 20)
                        .padding(.top, 50)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
        }
    }
}

