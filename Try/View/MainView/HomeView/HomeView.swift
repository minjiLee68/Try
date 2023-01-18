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
    @State var currentIndex = 0
    @State var isTabCard = false
    //    @State var isDetailView = false
    
    @Namespace var smooth
    
    var body: some View {
        mainView
            .onAppear {
                mainViewModel.userInfoFetchData()
            }
            .modifier(AppBackgroundColor(currentIndex: $currentIndex))
    }
    
    var mainView: some View {
        VStack(spacing: 15) {
            HeaderView()
            
            customCard
        }
        .padding([.horizontal, .top], 15)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .overlay {
            if isTabCard {
                DetailCardView(mainViewModel: mainViewModel, contentId: selectGoalContent?.id ?? "", isTab: $isTabCard, animation: smooth)
            }
        }
    }
    
    // MARK: Card View
    var customCard: some View {
        CustomCarousel_new(index: $currentIndex, items: mainViewModel.goalContents, cardPadding: 150) { contents, cardSize in
            cardContentView(content: contents)
                .frame(width: device.widthScale(cardSize.width), height: device.heightScale(cardSize.height - 50))
                .background(Color.black)
                .clipShape(RoundedRectangle(cornerRadius: 15, style: .continuous))
                .shadow(color: .white.opacity(0.2), radius: 6)
                .onTapGesture {
                    withAnimation(.interactiveSpring(response: 0.5, dampingFraction: 0.8, blendDuration: 0.8)) {
                        selectGoalContent = contents
                        isTabCard = true
                    }
                }
                .matchedGeometryEffect(id: contents.id, in: smooth)
                .scaleEffect(mainViewModel.goalContents[currentIndex].id == contents.id && isTabCard ? 1.8 : 1, anchor: .center)
        }
        .padding(.horizontal, -30)
        .padding(.vertical)
        .opacity(isTabCard ? 0 : 1)
    }
    
    // MARK: 카드 안에 들어갈 내용
    @ViewBuilder
    func cardContentView(content: Contents) -> some View {
        ZStack {
            VStack(spacing: 0) {
    //            if content.profile != "" {
    //                WebImageView(url: content.profile, width: device.widthScale(120), height: device.heightScale(120))
    //                    .clipShape(Circle())
    //                    .id(content.id)
    //            } else {
    //                Image(content.profile)
    //                    .resizable()
    //                    .aspectRatio(contentMode: .fill)
    //                    .frame(width: device.widthScale(120), height: device.heightScale(120))
    //                    .clipShape(Circle())
    //            }
                Image(content.profile)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: device.widthScale(120), height: device.heightScale(120))
                    .clipShape(Circle())
                    .frame(maxHeight: .infinity, alignment: .top)
                    .padding(.top, 50)
            }
            
            Text(content.nickName)
                .foregroundColor(.white)
                .defaultFont(size: 18)
                .frame(maxHeight: .infinity, alignment: .center)
        }
    }
}


// MARK: 상단에 있는 뷰 (닉네임, 프로필..)
extension HomeView {
    // MARK: Header View
    @ViewBuilder
    func HeaderView() -> some View {
        VStack(spacing: 15) {
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
            
            Text(mainViewModel.userInfoData?.introduce ?? "")
                .font(.callout)
                .foregroundColor(.gray)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.vertical, 15)
        }
        .opacity(isTabCard ? 0 : 1)
        .padding(.top, 20)
    }
}
