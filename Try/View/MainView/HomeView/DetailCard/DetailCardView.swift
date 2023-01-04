//
//  DetailCardView.swift
//  Try
//
//  Created by 이민지 on 2022/12/31.
//

import SwiftUI

struct DetailCardView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject var mainViewModel = MainHomeViewModel()
    
    @State var contents: Contents?
    
    @State var isShowContent = false
    @State var contentId: String
    
    @Binding var isTab: Bool
    
    var animation: Namespace.ID
    
    var body: some View {
        VStack(spacing: 20) {
            navigationBar

            if contents != nil {
                detailContents
            } else {
                
            }
            
            Spacer()
        }
        .background(.black)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .onAppear {
            mainViewModel.userInfoFetchData()
        }
    }
    
    var detailContents: some View {
        VStack(spacing: 0) {
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
            .frame(maxHeight: .infinity, alignment: .center)
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
        HStack {
            Button {
                withAnimation(.easeOut(duration: 0.35)) {
                    isTab = false
                }
            } label: {
                Text("닫기")
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            Button {
                if let contents {
                    mainViewModel.addContent(contents: contents)
                }
            } label: {
                Text("확인")
            }
        }
        .padding(.horizontal, 20)
        .padding(.top, 5)
    }
}

// MARK: 친구 선택, 목표 설정
extension DetailCardView {
    
}
