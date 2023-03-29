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
    @State var cardType: DetailType
    @State var selectGoalContent: Contents?
    
    @State var isShowContent = false
    @State var isContactList = false
    @State var isUserTab = false
    
    @State var contentId: String
    @Binding var isTab: Bool
    
    // MARK: 기록보기
    @State private var isRecord = false
    
    var animation: Namespace.ID
    
    var body: some View {
        VStack(spacing: 20) {
            if cardType == .Editable {
                DetailCardEditionView(
                    mainViewModel: mainViewModel,
                    cardType: cardType,
                    isTab: $isTab)
            } else {
                navigationBar
                
                detailContents
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
            
            ZStack {
                VStack(spacing: 15) {
                    ForEach(0..<(selectGoalContent?.content.count ?? 0), id: \.self) { index in
                        if let content = selectGoalContent?.content {
                            EditorContentsView(title: content[index])
                        }
                    }
                }
                
                // MARK: 기록보기
                if isRecord {
                    CalendarView()
                        .background(Color.black)
                        .padding(.horizontal, 10)
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
                WebImageView(url: cardType == .Editable ? ShareVar.selectProfile : selectGoalContent?.subProfile ?? "",
                             width: device.widthScale(60), height: device.heightScale(60))
                    .clipShape(Circle())
                    .id(UUID())
                
                Text(cardType == .Editable ? ShareVar.selectName : selectGoalContent?.subNickName ?? "")
                    .foregroundColor(.white)
                    .defaultFont(size: 13)
            }
        }
        .padding(.horizontal, 20)
    }
}

// MARK: 기록보기
extension DetailCardView {
    // MARK: 기록 보기
    var recordExplorationView: some View {
        HStack(spacing: 0) {
            // MARK: 기간 
            Text("\(selectGoalContent?.startDate ?? "") ~ \(selectGoalContent?.endDate ?? "")")
                .foregroundColor(.white)
                .defaultFont(size: 16)
            
            Spacer()
            
            Button {
                isRecord.toggle()
            } label: {
                Image("record")
            }
        }
        .padding(.horizontal, 20)
        .padding(.top, 5)
    }
}


// MARK: navigation bar
extension DetailCardView {
    var navigationBar: some View {
        ZStack {
            NavigationCustomBar(naviType: .cardDetail, isButton: $isTab)
            
//            if cardType == .Details {
//                NavigationLink {
//                    DetailCardEditionView(
//                        mainViewModel: mainViewModel,
//                        cardType: cardType,
//                        isTab: $isTab)
//                } label: {
//                    Text("편집")
//                }
//                .frame(maxWidth: .infinity, alignment: .trailing)
//                .padding(.trailing, 20)
//            }
        }
        .padding(.top, 10)
    }
}
