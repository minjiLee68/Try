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

    @State var selectGoalContent: Contents?
    @State var cardType: DetailType
    @State var defaultProfile = ""
    @State var defaultNickName = "이름"
    
    @State var isShowContent = false
    @State var isContactList = false
    @State var isUserTab = false
    
    @State var firstContent = ""
    @State var secondContent = ""
    @State var thirdContent = ""
    @State var code = ""
    
    @State var contentId: String
    @Binding var isTab: Bool
    
    var animation: Namespace.ID
    
    var body: some View {
        VStack(spacing: 20) {
            navigationBar
            
            if cardType == .Editable {
                detailContents
            } else {
                goalListSetting
            }
            
            Spacer()
        }
        .background(.black)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .ignoresSafeArea(.keyboard, edges: .bottom)
        .onAppear {
            mainViewModel.getShareUser()
        }
    }
    
    var detailContents: some View {
        VStack(spacing: 25) {
            topTitle
            
            VStack(spacing: 15) {
                ForEach(0..<(selectGoalContent?.content?.count ?? 0), id: \.self) { index in
                    HStack(alignment: .center, spacing: 0) {
                        Text(selectGoalContent?.content?[index] ?? "")
                            .foregroundColor(.white)
                    }
                }
            }
        }
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
            
            VStack(spacing: 8) {
                WebImageView(url: cardType == .Additional ? self.defaultProfile : selectGoalContent?.profile ?? "",
                             width: device.widthScale(50), height: device.heightScale(50))
                    .clipShape(Circle())
                    .id(UUID())
                
                Text(cardType == .Additional ? self.defaultNickName : selectGoalContent?.nickName ?? "")
                    .foregroundColor(.white)
                    .defaultFont(size: 13)
            }
        }
        .padding(.horizontal, 20)
        .padding(.top, 30)
    }
    
    var navigationBar: some View {
        ZStack {
            NavigationCustomBar(naviType: .cardDetail, isButton: $isTab)
            
            Button {
                mainViewModel.addShareContent(
                    nickName: self.defaultNickName,
                    profile: self.defaultProfile,
                    content: [firstContent,secondContent,thirdContent]
                )
                isTab.toggle()
            } label: {
                Text("확인")
                    .foregroundColor(isUserTab ? .white : .gray)
            }
            .frame(maxWidth: .infinity, alignment: .trailing)
            .padding(.trailing, 20)
            .disabled(isUserTab ? false : true)
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
//        .matchedGeometryEffect(id: contentId, in: animation)
//        .transition(.asymmetric(insertion: .identity, removal: .offset(y:0.5)))
    }
}


// MARK: dropdown menu
extension DetailCardView {
    var contactListView: some View {
        Menu {
            ForEach(0..<mainViewModel.connectionUsers.count, id: \.self) { index in
                Button {
                    self.defaultProfile = mainViewModel.connectionUsers[index].profile
                    self.defaultNickName = mainViewModel.connectionUsers[index].nickName
                    isUserTab = true
                } label: {
                    Text(mainViewModel.connectionUsers[index].nickName)
                        .foregroundColor(.white)
                        .defaultFont(size: 13)
                }
            }
        } label: {
            VStack(spacing: 8) {
                if self.defaultProfile.count == 0 {
                    Image("profile")
                        .mask(Circle().frame(width: device.widthScale(60), height: device.heightScale(60)))
                        .frame(width: device.widthScale(60), height: device.heightScale(60))
                }
                
                Text(self.defaultNickName)
                    .foregroundColor(.white.opacity(0.8))
                    .defaultFont(size: 13)
            }
        }
    }
}
