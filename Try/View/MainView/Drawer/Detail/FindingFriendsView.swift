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
                    
                    Button {
                        drawerViewModel.friendsRequest(nickName: drawerViewModel.userList[index].nickName, state: 0)
                    } label: {
                        if isRequest {
                            RoundedRectangle(cornerRadius: 5)
                                .foregroundColor(.blue)
                                .frame(width: device.widthScale(60), height: device.heightScale(30))
                                .overlay {
                                    Text("요청취소")
                                        .defaultFont(size: 12)
                                }
                        } else {
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(Color.blue, lineWidth: 1)
                                .frame(width: device.widthScale(60), height: device.heightScale(30))
                                .overlay {
                                    Text("친구요청")
                                        .defaultFont(size: 12)
                                }
                        }
                        
                    }

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
                    
                    Button {
                        
                    } label: {
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(Color.blue, lineWidth: 1)
                            .frame(width: device.widthScale(60), height: device.heightScale(30))
                            .overlay {
                                Text("친구요청")
                                    .defaultFont(size: 12)
                            }
                    }

                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.vertical, 6)
                .padding(.horizontal, 20)
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
