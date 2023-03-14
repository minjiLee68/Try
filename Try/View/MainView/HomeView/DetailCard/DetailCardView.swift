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
    @State var detailContent = [DetailContent]()
    @State var cardType: DetailType
    
    @State var firstContent = ""
    @State var secondContent = ""
    @State var thirdContent = ""
    
    @State var isShowContent = false
    @State var isContactList = false
    @State var isUserTab = false
    
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
    }
    
    var detailContents: some View {
        VStack(spacing: 25) {
            topTitle
            
            Divider()
            
            recordExplorationView
            
            VStack(spacing: 15) {
                ForEach(0..<(selectGoalContent?.content.count ?? 0), id: \.self) { index in
                    EditorContentsView(
                        title: selectGoalContent?.content[index].contentTitle ?? "",
                        detailContent: selectGoalContent?.content ?? [DetailContent]())
                }
            }
        }
//        .matchedGeometryEffect(id: contentId, in: animation)
//        .transition(.asymmetric(insertion: .identity, removal: .offset(y:0.5)))
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
                WebImageView(url: cardType == .Additional ? ShareVar.selectProfile : selectGoalContent?.profile ?? "",
                             width: device.widthScale(60), height: device.heightScale(60))
                    .clipShape(Circle())
                    .id(UUID())
                
                Text(cardType == .Additional ? ShareVar.selectName : selectGoalContent?.nickName ?? "")
                    .foregroundColor(.white)
                    .defaultFont(size: 13)
            }
        }
        .padding(.horizontal, 20)
    }
}

// MARK: 친구 선택, 목표 설정
extension DetailCardView {
    var goalListSetting: some View {
        VStack(spacing: 25) {
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
            
            Divider()
            
            notificationEnabledView
            
            VStack(spacing: 20) {
                TextField("첫번째 습관 만들기", text: $firstContent)
                    .padding()
                    .padding(.leading, 6)
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(6)
                    .foregroundColor(Color.white)
                
                TextField("두번째 습관 만들기", text: $secondContent)
                    .padding()
                    .padding(.leading, 6)
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(6)
                    .foregroundColor(Color.white)
                
                TextField("세번째 습관 만들기", text: $thirdContent)
                    .padding()
                    .padding(.leading, 6)
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(6)
                    .foregroundColor(Color.white)
            }
        }
//        .matchedGeometryEffect(id: contentId, in: animation)
//        .transition(.asymmetric(insertion: .identity, removal: .offset(y:0.5)))
    }
}

// MARK: 알림, 기간 설정
extension DetailCardView {
    // MARK: 알림, 기간 정하기
    var notificationEnabledView: some View {
        HStack(spacing: 18) {
            Button {
                
            } label: {
                HStack(spacing: 6) {
                    Image("alarm")
                    
                    Text("알림 추가하기")
                        .foregroundColor(.white)
                        .defaultFont(size: 16)
                }
            }
            
            Button {
                
            } label: {
                HStack(spacing: 6) {
                    Image("routine")
                    
                    Text("기간 정하기")
                        .foregroundColor(.white)
                        .defaultFont(size: 16)
                }
            }
        }
        .padding(.top, 5)
    }
    
    // MARK: 기록 보기
    var recordExplorationView: some View {
        HStack(spacing: 0) {
            Text("2023.02.10 ~ 2023.03.10")
                .foregroundColor(.white)
                .defaultFont(size: 16)
            
            Spacer()
            
            Button {
                
            } label: {
                Image("record")
            }
        }
        .padding(.horizontal, 20)
        .padding(.top, 5)
    }
}


// MARK: dropdown menu and navigation bar
extension DetailCardView {
    var contactListView: some View {
        Menu {
            ForEach(mainViewModel.connectionUsers.indices, id: \.self) { index in
                Button {
                    ShareVar.selectProfile = mainViewModel.connectionUsers[index].profile
                    ShareVar.selectName = mainViewModel.connectionUsers[index].nickName
                    isUserTab = true
                } label: {
                    Text(mainViewModel.connectionUsers[index].nickName)
                        .foregroundColor(.white)
                        .defaultFont(size: 13)
                }
            }
        } label: {
            VStack(spacing: 8) {
                if ShareVar.selectProfile.count == 0 {
                    Image("profile")
                        .mask(Circle().frame(width: device.widthScale(60), height: device.heightScale(60)))
                        .frame(width: device.widthScale(60), height: device.heightScale(60))
                } else {
                    WebImageView(url: ShareVar.selectProfile, width: device.widthScale(60), height: device.heightScale(60))
                        .clipShape(Circle())
                        .id(UUID())
                }
                
                Text(ShareVar.selectName)
                    .foregroundColor(.white.opacity(0.8))
                    .defaultFont(size: 13)
            }
        }
    }
    
    var navigationBar: some View {
        ZStack {
            NavigationCustomBar(naviType: .cardDetail, isButton: $isTab)
            
            Button {
                if cardType == .Additional {
                    detailContent = [
                        DetailContent(contentTitle: firstContent, oneImpression: ""),
                        DetailContent(contentTitle: secondContent, oneImpression: ""),
                        DetailContent(contentTitle: thirdContent, oneImpression: "")
                    ]
                }
                
                mainViewModel.addShareContent(
                    nickName: ShareVar.selectName,
                    profile: ShareVar.selectProfile,
                    content: detailContent
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
        .padding(.top, 10)
        .onChange(of: isTab) { newValue in
            hideKeyboard()
        }
    }
}
