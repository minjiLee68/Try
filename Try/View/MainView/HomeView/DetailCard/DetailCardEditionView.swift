//
//  DetailCardEditionView.swift
//  Try
//
//  Created by 이민지 on 2023/03/23.
//

import SwiftUI

struct DetailCardEditionView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject var mainViewModel: MainHomeViewModel
    
    @State var titleList = [String]()
    
    // MARK: Content
    @State var firstContent = ""
    @State var secondContent = ""
    @State var thirdContent = ""
    
    @State var isUserTab = false
    @State var cardType: DetailType
    
    // MARK: Date Picker
    @State private var picDate = Date()
    @State private var isPicDate = false
    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        return formatter
    }
    
    // MARK: Binding
    @Binding var isTab: Bool
    
    var body: some View {
        VStack(spacing: 25) {
            navigationBar
            
            HStack {
                VStack(spacing: 8) {
                    WebImageView(url: mainViewModel.userInfoData?.userProfile ?? "", width: device.widthScale(60), height: device.heightScale(60))
                        .clipShape(Circle())
                        .id(mainViewModel.userInfoData?.uid ?? "")
                    
                    Text(mainViewModel.userInfoData?.nickName ?? "")
                        .foregroundColor(.white)
                        .defaultFont(size: 13)
                }
                
                Spacer()
                
                if cardType == .Editable {
                    // MARK: 친구 선택
                    contactListView
                } else {
                    // MARK: 친구 선택 필요하지 않음
                    unalteredFriendView
                }
            }
            .padding(.horizontal, 20)
            
            Divider()
            
            // MARK: Setting and Content View
            settingAndContentView
        }
        .navigationBarBackButtonHidden()
        .frame(maxHeight: .infinity, alignment: .top)
        .onAppear {
            if cardType == .Details {
                mainViewModel.getContents()
            }
        }
        .onDisappear {
            hideKeyboard()
        }
    }
    
    // MARK: Setting and Content View
    var settingAndContentView: some View {
        VStack(spacing: 0) {
            notificationEnabledView
            ZStack {
                VStack(spacing: 20) {
                    TextField("첫번째 습관 만들기", text: $firstContent)
                        .padding()
                        .padding(.leading, 6)
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(6)
                        .foregroundColor(Color.white)
                        .disabled(cardType == .Editable ? false : true)
                    
                    TextField("두번째 습관 만들기", text: $secondContent)
                        .padding()
                        .padding(.leading, 6)
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(6)
                        .foregroundColor(Color.white)
                        .disabled(cardType == .Editable ? false : true)
                    
                    TextField("세번째 습관 만들기", text: $thirdContent)
                        .padding()
                        .padding(.leading, 6)
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(6)
                        .foregroundColor(Color.white)
                        .disabled(cardType == .Editable ? false : true)
                }
                .padding(.top, 25)
                
                // MARK: DatePicker
                if isPicDate {
                    DatePicker("", selection: $picDate, in: Date()..., displayedComponents: .date)
                        .labelsHidden()
                        .datePickerStyle(GraphicalDatePickerStyle())
                        .padding(.top, 10)
                        .background(Color.black, in: RoundedRectangle(cornerRadius: 20))
                        .onChange(of: picDate) { newValue in
                            ShareVar.startDate = mainViewModel.dateString(date: Date())
                            ShareVar.endDate = mainViewModel.dateString(date: picDate)
                        }
                }
            }
        }
    }
    
    // MARK: 알림, 기간 정하기
    var notificationEnabledView: some View {
        VStack {
            HStack(spacing: 20) {
                Button {
                    
                } label: {
                    HStack(spacing: 6) {
                        Image("alarm")
                        
                        Text("알림 추가하기")
                            .foregroundColor(.white)
                            .defaultFont(size: 16)
                    }
                }
                
                Button {
                    isPicDate.toggle()
                } label: {
                    HStack(spacing: 6) {
                        Image("routine")
                        
                        Text("기간 정하기")
                            .foregroundColor(.white)
                            .defaultFont(size: 16)
                    }
                }
            }
            .padding(.top, 5)
        }
    }
    
    // MARK: 친구 선택
    var contactListView: some View {
        Menu {
            ForEach(mainViewModel.connectionUsers.indices, id: \.self) { index in
                Button {
                    ShareVar.selectProfile = mainViewModel.connectionUsers[index].profile
                    ShareVar.selectName = mainViewModel.connectionUsers[index].nickName
                    isUserTab = true
                } label: {
                    Text(mainViewModel.connectionUsers[index].nickName)
                        .foregroundColor(.white)
                        .defaultFont(size: 13)
                }
            }
        } label: {
            VStack(spacing: 8) {
                if ShareVar.selectProfile.count == 0 {
                    Image("profile")
                        .mask(Circle().frame(width: device.widthScale(60), height: device.heightScale(60)))
                        .frame(width: device.widthScale(60), height: device.heightScale(60))
                } else {
                    WebImageView(url: ShareVar.selectProfile, width: device.widthScale(60), height: device.heightScale(60))
                        .clipShape(Circle())
                        .id(UUID())
                }
                
                Text(ShareVar.selectName)
                    .foregroundColor(.white.opacity(0.8))
                    .defaultFont(size: 13)
            }
        }
    }
    
    // MARK: 친구 선택이 필요하지 않은 구간
    var unalteredFriendView: some View {
        VStack(spacing: 8) {
            if mainViewModel.contents?.subProfile.count == 0 {
                Image("profile")
                    .mask(Circle().frame(width: device.widthScale(60), height: device.heightScale(60)))
                    .frame(width: device.widthScale(60), height: device.heightScale(60))
            } else {
                WebImageView(url: mainViewModel.contents?.subProfile ?? "", width: device.widthScale(60), height: device.heightScale(60))
                    .clipShape(Circle())
                    .id(UUID())
            }
            
            Text(mainViewModel.contents?.subNickName ?? "")
                .foregroundColor(.white.opacity(0.8))
                .defaultFont(size: 13)
        }
    }
    
    var navigationBar: some View {
        ZStack {
            NavigationCustomBar (
                naviType: cardType == .Details ? .cardEditor : .cardDetail,
                isButton: cardType == .Details ? .constant(false) : $isTab
            )
            
            Button {
                if cardType == .Editable {
                    titleList = [firstContent, secondContent, thirdContent]
                    
                    mainViewModel.addShareContent(type: cardType, content: titleList)
                }
                dismiss()
                hideKeyboard()
            } label: {
                if cardType == .Editable {
                    Text("확인")
                        .foregroundColor(isUserTab && titleList.count == 3 ? .white : .gray)
                } else {
                    Text("확인")
                        .foregroundColor(.white)
                }
            }
            .frame(maxWidth: .infinity, alignment: .trailing)
            .padding(.trailing, 20)
        }
        .padding(.top, 10)
    }
}
