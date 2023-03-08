//
//  FindingFriendsView.swift
//  Try
//
//  Created by 이민지 on 2023/02/07.
//

import SwiftUI

struct FindingFriendsView: View {
    @StateObject var drawerViewModel = DrawerViewModel()
    
    @State var searchText = ""
    @State var isRequest = false
    
    var body: some View {
        VStack {
            friendsSearchView
            
            searchListMode()
        }
        .onAppear {
            drawerViewModel.userInfoFetchData()
            drawerViewModel.getUserList()
        }
    }
    
    @ViewBuilder
    func searchListMode() -> some View {
        switch drawerViewModel.listMode {
        case .allList:
            findingFriends
        case .filtering:
            searchResultView
        }
    }
    
    // MARK: 친구 찾기
    var findingFriends: some View {
        VStack {
            ForEach(drawerViewModel.userList.indices, id: \.self) { index in
                Divider()
                
                HStack(spacing: 15) {
                    WebImageView(url: drawerViewModel.userList[index].userProfile, width: device.widthScale(40), height: device.heightScale(40))
                        .clipShape(Circle())
                        .id(drawerViewModel.userList[index].uid)
                    
                    Text(drawerViewModel.userList[index].nickName)
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    // 요청 상태 view
                    requestStatus(index: index)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.vertical, 6)
                .padding(.horizontal, 20)
            }
        }
        .padding(.top, 20)
    }
    
    // MARK: 친구 검색 결과
    var searchResultView: some View {
        VStack {
            let filter = drawerViewModel.userList.filter({$0.nickName.contains(searchText)})
            ForEach(filter.indices, id: \.self) { index in
                Divider()
                
                HStack(spacing: 15) {
                    WebImageView(url: filter[index].userProfile, width: device.widthScale(40), height: device.heightScale(40))
                        .clipShape(Circle())
                        .id(filter[index].uid)
                    
                    Text(filter[index].nickName)
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    // 요청 상태 view
                    requestStatus(index: index)

                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.vertical, 6)
                .padding(.horizontal, 20)
            }
        }
    }
    
    // MARK: 요청 상태
    @ViewBuilder
    func requestStatus(index: Int) -> some View {
        if drawerViewModel.userList[index].id != drawerViewModel.userInfoData?.id ?? "" {
            Button {
                if drawerViewModel.userList[index].status == RequestStatus.defaults.rawValue {
                    drawerViewModel.friendsRequest(id: drawerViewModel.userList[index].id, state: RequestStatus.wait.rawValue)
                } else {
                    drawerViewModel.friendsRequest(id: drawerViewModel.userList[index].id, state: RequestStatus.defaults.rawValue)
                }
            } label: {
                if drawerViewModel.userList[index].status == RequestStatus.wait.rawValue {
                    RoundedRectangle(cornerRadius: 5)
                        .stroke(Color.blue)
                        .frame(width: device.widthScale(60), height: device.heightScale(30))
                        .overlay {
                            Text("요청취소")
                                .defaultFont(size: 12)
                        }
                } else if drawerViewModel.userList[index].status == RequestStatus.defaults.rawValue{
                    RoundedRectangle(cornerRadius: 5)
                        .stroke(Color.blue)
                        .frame(width: device.widthScale(60), height: device.heightScale(30))
                        .overlay {
                            Text("친구요청")
                                .defaultFont(size: 12)
                        }
                }
            }
        }
    }
    
    // MARK: 친구 검색
    var friendsSearchView: some View {
        ZStack {
            TextField("이름 검색", text: $searchText)
                .padding(8)
                .background(Color.gray.opacity(0.1))
                .cornerRadius(6)
                .foregroundColor(Color.white)
                .onChange(of: searchText) { newValue in
                    if searchText == "" {
                        drawerViewModel.listMode = .allList
                    } else {
                        drawerViewModel.listMode = .filtering
                    }
                }
        }
        .padding(.horizontal, 20)
    }
}
