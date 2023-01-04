//
//  MainView.swift
//  JointGoal_SwiftUI
//
//  Created by 이민지 on 2022/10/20.
//

import SwiftUI

struct MainView: View {
    @StateObject var mainViewModel = MainHomeViewModel()
    @State var currentTab: Tab = .home
    @State var selectGoalContent: Contents?
    @State var currentIndex: Int = 0
    @State var isTabCard = false
    //    @State var isDetailView = false
    
    @Namespace var animation
    @Namespace var smooth
    
    var body: some View {
        mainView
            .onAppear {
                mainViewModel.userInfoFetchData()
            }
            .modifier(AppBackgroundColor())
    }
    
    var mainView: some View {
        VStack(spacing: 15) {
            HeaderView()
            
            if !mainViewModel.goalContents.isEmpty {
                customCard
            } else {
                
            }
            
            tabBar()
        }
        .padding([.horizontal, .top], 15)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .overlay {
            if let selectGoalContent, isTabCard {
                DetailCardView(goalContent: selectGoalContent, isTab: $isTabCard, animation: smooth)
            }
        }
    }
    
    // MARK: Card View
    var customCard: some View {
        CustomCarousel_new(index: $currentIndex, items: mainViewModel.goalContents, cardPadding: 150) { contents, cardSize in
            RoundedRectangle(cornerRadius: 15, style: .continuous)
                .fill(Color.black)
                .frame(width: cardSize.width, height: cardSize.height)
                .shadow(color: .white.opacity(0.2), radius: 6)
                .overlay {
                    if mainViewModel.goalContents.isEmpty {
                        ifNotThereContent
                    } else {
                        // MARK: Applying Matched Geometry
                        if isTabCard && selectGoalContent?.id == contents.id {
                            // 카드 안에 들어갈 내용
                            CardContentView()
                        } else {
                            // 카드 안에 들어갈 내용
                            CardContentView()
                                .matchedGeometryEffect(id: contents.id, in: smooth)
                        }
                    }
                }
                .onTapGesture {
                    withAnimation(.interactiveSpring(response: 0.5, dampingFraction: 0.8, blendDuration: 0.8)) {
                        selectGoalContent = contents
                        isTabCard = true
                    }
                }
                .scaleEffect(mainViewModel.goalContents[currentIndex].id == contents.id && isTabCard ? 1.8 : 1, anchor: .center)
        }
        .padding(.horizontal, -30)
        .padding(.vertical)
        .opacity(isTabCard ? 0 : 1)
    }
    
    // MARK: Not Card Content
    var ifNotThereContent: some View {
        VStack(spacing: 0) {
            Spacer()
            Button {
                withAnimation(.interactiveSpring(response: 0.5, dampingFraction: 0.8, blendDuration: 0.8)) {
                    isTabCard = true
                }
            } label: {
                Text("추가하기")
                    .foregroundColor(.white)
            }
            Spacer()
        }
    }
}


// MARK: 상단에 있는 뷰 (닉네임, 프로필..)
extension MainView {
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
                
                Button {
                    
                } label: {
                    WebImageView(url: "\(mainViewModel.userInfoData?.userProfile ?? "")", width: device.widthScale(50), height: device.heightScale(50))
                        .clipShape(Circle())
                        .id(mainViewModel.userInfoData?.uid ?? "")
                }

            }
            
            Text(mainViewModel.userInfoData?.introduce ?? "")
                .font(.callout)
                .foregroundColor(.gray)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.vertical, 15)
        }
        .opacity(isTabCard ? 0 : 1)
    }
}

extension MainView {
    @ViewBuilder
    func tabBar() -> some View {
        HStack(spacing: 0) {
            ForEach(Tab.allCases, id: \.rawValue) { tab in
                VStack(spacing: -2) {
                    Image(tab.rawValue)
                        .renderingMode(.template)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 28, height: 28)
                        .foregroundColor(currentTab == tab ? .white : .gray.opacity(0.6))
                    
                    if currentTab == tab {
                        Circle()
                            .fill(.white)
                            .frame(width: 5, height: 5)
                            .offset(y: 10)
                            .matchedGeometryEffect(id: "TAB", in: animation)
                    }
                }
                .frame(maxWidth: .infinity)
                .contentShape(Rectangle())
                .onTapGesture {
                    withAnimation {
                        currentTab = tab
                    }
                }
            }
        }
        .padding(.horizontal)
        .padding(.bottom, 10)
        .opacity(isTabCard ? 0 : 1)
    }
}
