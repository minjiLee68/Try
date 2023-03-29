//
//  DrawerDetailView.swift
//  Try
//
//  Created by 이민지 on 2023/02/07.
//

import SwiftUI

struct DrawerDetailView: View {
    @StateObject var drawerViewModel = DrawerViewModel()
    @State var drawerType: DrawerType
    @State var title: String
    @State var isBack = false
    
    var body: some View {
        VStack {
            NavigationCustomBar(naviType: .drawerDetail, isButton: $isBack)
            
            switch drawerType {
            case .FindingFriends:
                FindingFriendsView()
            case .Observation:
                CalendarView()
            default:
                let _ = print("default")
            }
        }
        .frame(maxHeight: .infinity, alignment: .top)
        .onAppear {
            drawerViewModel.userInfoFetchData()
        }
    }
}
