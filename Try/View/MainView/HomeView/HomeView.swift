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
                newFriendRequestView
                    .opacity(isResponse ? 0 : 1)
            }
            
            if isTabCard {
                DetailCardView(
                    mainViewModel: mainViewModel,
                    selectGoalContent: selectGoalContent,
                    cardType: cardType,
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
                        cardType = .Editable
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
                if content.profile != "" {
                    WebImageView(url: content.profile, width: device.widthScale(120), height: device.heightScale(120))
                        .clipShape(Circle())
                        .id(content.id)
                        .frame(maxHeight: .infinity, alignment: .top)
                        .padding(.top, 50)
                } else {
                    Image("profile")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: device.widthScale(120), height: device.heightScale(120))
                        .clipShape(Circle())
                        .frame(maxHeight: .infinity, alignment: .top)
                        .padding(.top, 50)
                }
            }
            
            Text(content.nickName)
                .foregroundColor(.white)
                .defaultFont(size: 18)
                .frame(maxHeight: .infinity, alignment: .center)
        }
    }
    
    // MARK: 새로운 친구요청
    var newFriendRequestView: some View {
        RoundedRectangle(cornerRadius: 10)
            .fill(Color.black)
            .shadow(color: .white.opacity(0.2), radius: 5)
            .overlay(content: {
                VStack(alignment: .center ,spacing: 0) {
                    Text("새로운 친구요청이 있습니다!")
                        .font(.title3)
                        .defaultFont(size: 16)
                        .foregroundColor(.white)
                    
                    ForEach(mainViewModel.friendRequest.indices, id: \.self) { i in
                        HStack(spacing: 15) {
                            WebImageView(url: mainViewModel.friendRequest[i].profile, width: device.widthScale(40), height: device.heightScale(40))
                                .clipShape(Circle())
                                .id(mainViewModel.friendRequest[i].uid)
                            
                            Text(mainViewModel.friendRequest[i].nickName)
                                .foregroundColor(.white)
                            
                            Spacer()
                            
                            HStack(spacing: 6) {
                                Button {
                                    mainViewModel.friendsResponse(
                                        id: mainViewModel.friendRequest[i].uid,
                                        state: RequestStatus.refusal.rawValue
                                    )
                                    isResponse.toggle()
                                } label: {
                                    RoundedRectangle(cornerRadius: 5)
                                        .stroke(Color.blue)
                                        .frame(width: device.widthScale(60), height: device.heightScale(30))
                                        .overlay {
                                            Text("거절")
                                                .defaultFont(size: 12)
                                        }
                                }
                                
                                Button {
                                    mainViewModel.friendsResponse(
                                        id: mainViewModel.friendRequest[i].uid,
                                        state: RequestStatus.accept.rawValue
                                    )
                                    isResponse.toggle()
                                } label: {
                                    RoundedRectangle(cornerRadius: 5)
                                        .stroke(Color.blue)
                                        .frame(width: device.widthScale(60), height: device.heightScale(30))
                                        .overlay {
                                            Text("수락")
                                                .defaultFont(size: 12)
                                        }
                                }
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.vertical, 6)
                    }
                }
            })
            .frame(width: device.screenWidth - 30)
            .frame(maxHeight: .infinity)
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
                    cardType = .Additional
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
