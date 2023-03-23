//
//  NewFriendRequestView.swift
//  Try
//
//  Created by 이민지 on 2023/03/23.
//

import SwiftUI

struct NewFriendRequestView: View {
    @StateObject var mainViewModel = MainHomeViewModel()
    
    @Binding var isResponse: Bool
    
    var body: some View {
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
            .onAppear {
                mainViewModel.newFriendRequest()
            }
    }
}
