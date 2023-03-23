//
//  MainView.swift
//  JointGoal_SwiftUI
//
//  Created by 이민지 on 2022/10/20.
//

import SwiftUI

struct HomeView: View {
    @StateObject var mainViewModel = MainHomeViewModel()
    @State var selectGoalContent: Contents?
    @State var cardType: DetailType = .Editable
    @State var currentIndex = 0
    
    @State var isTabCard = false
    @State var isResponse = false
    
    @Binding var drawerSelected: Bool
    
    @Namespace var smooth
    
    var body: some View {
        mainView
            .onAppear {
                mainViewModel.userInfoFetchData()
            }
            .modifier(AppBackgroundColor(viewModel: mainViewModel, currentIndex: $currentIndex))
    }
    
    var mainView: some View {
        VStack(spacing: 15) {
            HeaderView()
            
            customCard
        }
        .padding([.horizontal, .top], 15)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .overlay {
            if !mainViewModel.friendRequest.isEmpty {
                // MARK: 새로운 친구요청 여부
                NewFriendRequestView(isResponse: $isResponse)
                    .opacity(isResponse ? 0 : 1)
            }
            
            if isTabCard {
                DetailCardView(
                    mainViewModel: mainViewModel,
                    cardType: cardType,
                    selectGoalContent: selectGoalContent,
                    contentId: selectGoalContent?.id ?? "",
                    isTab: $isTabCard,
                    animation: smooth
                )
            }
        }
    }
    
    // MARK: Card View
    var customCard: some View {
        CustomCarousel_new(index: $currentIndex, items: mainViewModel.goalContents, cardPadding: 150) { contents, cardSize in
            RoundedRectangle(cornerRadius: 15)
                .fill(Color.black.opacity(0.9))
                .shadow(color: .white.opacity(0.2), radius: 6)
                .frame(width: device.widthScale(cardSize.width), height: device.heightScale(cardSize.height - 50))
                .overlay(content: {
                    cardContentView(content: contents)
                })
                .onTapGesture {
                    withAnimation(.interactiveSpring(response: 0.5, dampingFraction: 0.8, blendDuration: 0.8)) {
                        ShareVar.documentId = contents.id
                        selectGoalContent = contents
                        isTabCard = true
                        cardType = .Details
                    }
                }
                .matchedGeometryEffect(id: contents.id, in: smooth)
                .scaleEffect(mainViewModel.goalContents[currentIndex].id == contents.id && isTabCard ? 1.8 : 1, anchor: .center)
        }
        .padding(.horizontal, -30)
        .padding(.vertical)
        .opacity(isTabCard ? 0 : 1)
        .onAppear {
            currentIndex = 0
        }
    }
    
    // MARK: 카드 안에 들어갈 내용
    @ViewBuilder
    func cardContentView(content: Contents) -> some View {
        ZStack {
            VStack(spacing: 0) {
                if !content.profile.isEmpty {
                    WebImageView( url: content.profile, width: device.widthScale(120), height: device.heightScale(120))
                        .clipShape(Circle())
                        .id(content.id)
                        .frame(maxHeight: .infinity, alignment: .top)
                        .padding(.top, 50)
                } else {
                    defaultProfile
                }
                
                if !content.subProfile.isEmpty {
                    WebImageView( url: content.subProfile, width: device.widthScale(120), height: device.heightScale(120))
                        .clipShape(Circle())
                        .id(content.id)
                        .frame(maxHeight: .infinity, alignment: .top)
                        .padding(.top, 50)
                } else {
                    defaultProfile
                }
            }
            
//            Text(!ShareVar.isMainCheck ? content.nickName: content.subNickName)
//                .foregroundColor(.white)
//                .defaultFont(size: 18)
//                .frame(maxHeight: .infinity, alignment: .center)
        }
    }
    
    var defaultProfile: some View {
        Image("profile")
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: device.widthScale(120), height: device.heightScale(120))
            .clipShape(Circle())
            .frame(maxHeight: .infinity, alignment: .top)
            .padding(.top, 50)
    }
}


// MARK: 상단에 있는 뷰 (닉네임, 프로필..)
extension HomeView {
    // MARK: Header View
    @ViewBuilder
    func HeaderView() -> some View {
        VStack(spacing: 15) {
            Button {
                drawerSelected.toggle()
            } label: {
                Image("ic_placeholder")
                    .colorMultiply(.white)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            HStack {
                (Text("Hello ")
                    .fontWeight(.semibold) +
                 Text(mainViewModel.userInfoData?.nickName ?? "")
                    .fontWeight(.bold)
                )
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, alignment: .leading)
                
                NavigationLink(destination: MyPageView()) {
                    if mainViewModel.userInfoData?.userProfile == "" {
                        Image("profile")
                            .mask(Circle().frame(width: device.widthScale(50), height: device.heightScale(50)))
                            .frame(width: device.widthScale(50), height: device.heightScale(50))
                    } else {
                        WebImageView(url: "\(mainViewModel.userInfoData?.userProfile ?? "")", width: device.widthScale(50), height: device.heightScale(50))
                            .clipShape(Circle())
                            .id(mainViewModel.userInfoData?.uid ?? "")
                    }
                }
            }
            
            HStack(spacing: 0) {
                Text(mainViewModel.userInfoData?.introduce ?? "")
                    .font(.callout)
                    .foregroundColor(.gray)
                    .padding(.vertical, 15)
                
                Spacer()
                
                Button {
                    isTabCard = true
                    cardType = .Editable
                } label: {
                    Text("추가하기")
                        .defaultFont(size: 17)
                        .foregroundColor(.gray)
                }
            }
        }
        .opacity(isTabCard ? 0 : 1)
        .padding(.top, 5)
    }
}
