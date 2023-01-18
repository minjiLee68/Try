//
//  DetailCardView.swift
//  Try
//
//  Created by 이민지 on 2022/12/31.
//

import SwiftUI

struct DetailCardView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject var mainViewModel: MainHomeViewModel
    
    @State var contents: Contents?
    @State var defaultProfile = "profile"
    @State var defaultNickName = "이름"
    
    @State var isShowContent = false
    @State var isContactList = false
    @State var firstContent = ""
    @State var secondContent = ""
    @State var thirdContent = ""
    
    @State var contentId: String
    @Binding var isTab: Bool
    
    var animation: Namespace.ID
    
    var body: some View {
        VStack(spacing: 20) {
            navigationBar
            
            if contents != nil {
                detailContents
            } else {
                goalListSetting
            }
            
            Spacer()
        }
        .background(.black)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .onAppear {
            mainViewModel.userInfoFetchData()
        }
        .onDisappear {
            
        }
        .ignoresSafeArea(.keyboard, edges: .bottom)
    }
    
    var detailContents: some View {
        VStack(spacing: 25) {
            topTitle
            
            VStack(spacing: 15) {
                HStack(alignment: .center, spacing: 0) {
                    Text("안녕하세요")
                        .foregroundColor(.white)
                }
                HStack(alignment: .center, spacing: 0) {
                    Text("안녕하세요")
                        .foregroundColor(.white)
                }
                HStack(alignment: .center, spacing: 0) {
                    Text("안녕하세요")
                        .foregroundColor(.white)
                }
            }
        }
        .matchedGeometryEffect(id: contentId, in: animation)
        .transition(.asymmetric(insertion: .identity, removal: .offset(y:0.5)))
    }
    
    var topTitle: some View {
        HStack(spacing: 0) {
            VStack(spacing: 8) {
                WebImageView(url: mainViewModel.userInfoData?.userProfile ?? "", width: device.widthScale(50), height: device.heightScale(50))
                    .clipShape(Circle())
                    .id(mainViewModel.userInfoData?.uid ?? "")
                
                Text(mainViewModel.userInfoData?.nickName ?? "")
                    .foregroundColor(.white)
                    .defaultFont(size: 13)
            }
            
            Spacer()
            
            if contents?.nickName.count != 0 {
                VStack(spacing: 8) {
                    WebImageView(url: contents?.profile ?? "", width: device.widthScale(50), height: device.heightScale(50))
                        .clipShape(Circle())
                        .id(contents?.id ?? "")
                }
                Text(contents?.nickName ?? "")
                    .foregroundColor(.white)
                    .defaultFont(size: 13)
            } else {
                
            }
        }
        .padding(.horizontal, 20)
        .padding(.top, 30)
    }
    
    var navigationBar: some View {
        ZStack {
            NavigationCustomBar(naviType: .detail, isButton: $isTab)
            
            Button {
                mainViewModel.addShareContent(nickName: self.defaultNickName, content: [firstContent, secondContent, thirdContent])
                isTab.toggle()
            } label: {
                Text("확인")
            }
            .frame(maxWidth: .infinity, alignment: .trailing)
            .padding(.trailing, 20)
        }
        .onChange(of: isTab) { newValue in
            hideKeyboard()
        }
    }
}

// MARK: 친구 선택, 목표 설정
extension DetailCardView {
    var goalListSetting: some View {
        VStack(spacing: 0) {
            HStack {
                VStack(spacing: 8) {
                    WebImageView(url: mainViewModel.userInfoData?.userProfile ?? "", width: device.widthScale(60), height: device.heightScale(60))
                        .clipShape(Circle())
                        .id(mainViewModel.userInfoData?.uid ?? "")
                    
                    Text(mainViewModel.userInfoData?.nickName ?? "")
                        .foregroundColor(.white)
                        .defaultFont(size: 13)
                }
                
                Spacer()
                
                contactListView
            }
            .padding(.horizontal, 20)
            
            VStack(spacing: 20) {
                TextField("첫번째 목표", text: $firstContent)
                    .padding()
                    .padding(.leading, 6)
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(6)
                    .foregroundColor(Color.white)
                
                TextField("두번째 목표", text: $secondContent)
                    .padding()
                    .padding(.leading, 6)
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(6)
                    .foregroundColor(Color.white)
                
                TextField("세번째 목표", text: $thirdContent)
                    .padding()
                    .padding(.leading, 6)
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(6)
                    .foregroundColor(Color.white)
            }
            .padding(.top, 40)
        }
    }
}


// MARK: dropdown menu
extension DetailCardView {
    var contactListView: some View {
        Menu {
            ForEach(0..<mainViewModel.connection.count, id: \.self) { index in
                Button {
                    self.defaultProfile = mainViewModel.connection[index].profile
                    self.defaultNickName = mainViewModel.connection[index].nickName
                } label: {
                    Text(mainViewModel.connection[index].nickName)
                        .foregroundColor(.white)
                        .defaultFont(size: 13)
                }
            }
        } label: {
            VStack(spacing: 8) {
                Image(self.defaultProfile)
                    .mask(Circle().frame(width: device.widthScale(60), height: device.heightScale(60)))
                    .frame(width: device.widthScale(60), height: device.heightScale(60))
                
                Text(self.defaultNickName)
                    .foregroundColor(.white.opacity(0.8))
                    .defaultFont(size: 13)
            }
        }
    }
}
