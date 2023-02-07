//
//  DrawerView.swift
//  Try
//
//  Created by 이민지 on 2023/02/07.
//

import SwiftUI

struct DrawerView: View {
    @StateObject var drawerViewModel = DrawerViewModel()
    @State var drawerType: DrawerType = .Empty
    @State var isSelected = false
    @State var drawerTitle = ""
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                headerView
                
                drawerList
            }
            .ignoresSafeArea(.all)
            .frame(maxHeight: .infinity, alignment: .top)
            .padding(.top, 50)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .frame(width: device.screenWidth - 60)
        .background(
            Color.black
                .ignoresSafeArea(.container, edges: .vertical)
        )
        .frame(maxWidth: .infinity, alignment: .leading)
        .onAppear {
            drawerViewModel.userInfoFetchData()
            drawerViewModel.drawerList()
        }
    }
    
    // MARK: Header
    var headerView: some View {
        VStack(spacing: 12) {
            WebImageView(url: drawerViewModel.userInfoData?.userProfile ?? "",width: device.widthScale(120), height: device.heightScale(120))
                .clipShape(Circle())
                .id(UUID())
            
            Text(drawerViewModel.userInfoData?.nickName ?? "")
                .defaultFont(size: 14)
                .foregroundColor(.white)
                .font(.title2)
        }
        .padding([.top, .leading], 20)
        .frame(maxWidth: .infinity, alignment: .center)
    }
    
    // MARK: List
    var drawerList: some View {
        VStack(alignment: .leading, spacing: 8) {
            NavigationLink(
                destination: DrawerDetailView(drawerType: drawerType, title: drawerTitle),
                isActive: $isSelected,
                label: {})
            
            ForEach(drawerViewModel.drawers.indices, id: \.self) { index in
                Divider()
                Button {
                    drawerTitle = drawerViewModel.drawers[index].drawerList
                    drawerType = drawerViewModel.drawers[index].type
                    isSelected.toggle()
                } label: {
                    Text(drawerViewModel.drawers[index].drawerList)
                        .fontWeight(.bold)
                        .defaultFont(size: 14)
                        .foregroundColor(.white)
                        .padding(.vertical, 8)
                        .padding(.leading, 20)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
        }
        .padding(.top, 20)
    }
}
