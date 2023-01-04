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
            .modifier(AppBackgroundColor())
    }
    
    var mainView: some View {
        VStack(spacing: 15) {
            HeaderView()
            
            if !mainViewModel.goalContents.isEmpty {
                customCard
            } else {
                ifNotThereContent
            }
        }
        .padding([.horizontal, .top], 15)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .overlay {
            if isTabCard {
                DetailCardView(contentId: selectGoalContent?.id ?? "", isTab: $isTabCard, animation: smooth)
            }
        }
    }
    
    // MARK: Card View
    var customCard: some View {
        CustomCarousel_new(index: $currentIndex, items: mainViewModel.goalContents, cardPadding: 150) { contents, cardSize in
            RoundedRectangle(cornerRadius: 15, style: .continuous)
                .fill(Color.black)
                .frame(width: device.widthScale(cardSize.width), height: device.heightScale(cardSize.height))
                .shadow(color: .white.opacity(0.2), radius: 6)
                .overlay {
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
        RoundedRectangle(cornerRadius: 15, style: .continuous)
            .fill(Color.black)
            .frame(width: device.widthScale(270), height: device.heightScale(474))
            .shadow(color: .white.opacity(0.2), radius: 6)
            .overlay {
                VStack(spacing: 0) {
                    Spacer()
                    Text("추가하기")
                        .foregroundColor(.white)
                    Spacer()
                }
                .opacity(isTabCard ? 0 : 1)
            }
            .onTapGesture {
                withAnimation(.interactiveSpring(response: 0.5, dampingFraction: 0.8, blendDuration: 0.8)) {
                    isTabCard = true
                }
            }
            .scaleEffect(isTabCard ? 1.8 : 1, anchor: .center)
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
