//
//  EditorContentsView.swift
//  Try
//
//  Created by 이민지 on 2023/02/27.
//

import SwiftUI

struct EditorContentsView: View {
    @StateObject var mainViewModel = MainHomeViewModel()
    @State var title: String
    
    @State private var isCardTab = false
    @Environment(\.presentationMode) var mode
    
    var body: some View {
        RoundedRectangle(cornerRadius: 6)
            .fill(Color.gray.opacity(0.1))
            .frame(width: device.screenWidth - 20, height: device.heightScale(150))
            .overlay {
                Text(title)
                    .foregroundColor(.white)
            }
            .onTapGesture {
                isCardTab = true
            }
            .fullScreenCover(isPresented: $isCardTab) {
                SubContentView(mainViewModel: mainViewModel, title: title, isTab: $isCardTab)
                    .onDisappear {
                        mode.wrappedValue.dismiss()
                    }
            }
            .onAppear {
                mainViewModel.getImpression(title: title)
                mainViewModel.getUserInfo()
            }
    }
}

struct SubContentView: View {
    @StateObject var mainViewModel: MainHomeViewModel
    @State var impressions = [Impression]()
    @State var title: String
    @State var impression = ""
    @State var isMission = false
    
    @Binding var isTab: Bool
    
    var body: some View {
        VStack {
            ZStack {
                navigationBar
                
                ScrollView(.vertical) {
                    detailContentView
                }
                
                HStack(spacing: 0) {
                    TextField("한줄 소감", text: $impression)
                        .padding()
                        .padding(.leading, 6)
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(6)
                        .foregroundColor(Color.white)
                    
                    Button {
                        impressions.append(
                            Impression(
                                nickName: mainViewModel.userInfoData?.nickName ?? "",
                                introduce: mainViewModel.userInfoData?.introduce ?? "",
                                oneImpression: impression)
                        )
                        mainViewModel.setImpression(title: title, detailContent: impressions)
                        impression = ""
                    } label: {
                        Text("전송")
                    }
                }
                .frame(maxHeight: .infinity, alignment: .bottom)
            }
            .onTapGesture {
                hideKeyboard()
            }
            .onAppear {
                if let impressions = mainViewModel.detailContent?.impressions {
                    impressions.forEach { impression in
                        self.impressions.append(impression)
                    }
                }

            }
        }
    }
    
    var detailContentView: some View {
        VStack {
            HStack(spacing: 0) {
                Text(title)
                    .font(.title2)
                    .foregroundColor(.white)
                
                Spacer()
                
                Button {
                    isMission.toggle()
                } label: {
                    Text("미션완료")
                        .font(.title2)
                        .foregroundColor(isMission ? .white : .gray)
                }
            }
            
            Divider()
            
            ForEach(0..<impressions.count, id: \.self) { index in
                VStack(alignment: .leading, spacing: 10) {
                    HStack(spacing: 6) {
                        Text(impressions[index].nickName)
                            .foregroundColor(.white)
                            .defaultFont(size: 16)
                        
                        Text(impressions[index].introduce)
                            .foregroundColor(.gray)
                            .defaultFont(size: 14)
                    }
                    
                    Text(impressions[index].oneImpression)
                        .foregroundColor(.white)
                        .defaultFont(size: 18)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(.top, 16)
        }
        .padding(.horizontal, 20)
    }
    
    var navigationBar: some View {
        ZStack {
            NavigationCustomBar(naviType: .cardDetail, isButton: $isTab)
            
            Button {
//                if let index = detailContent.firstIndex(where: { $0.contentTitle == title }) {
//                    detailContent[index].oneImpression.append(impression)
//                }
                isTab.toggle()
            } label: {
                Text("확인")
                    .foregroundColor(!title.isEmpty ? .white : .gray)
            }
            .frame(maxWidth: .infinity, alignment: .trailing)
            .padding(.trailing, 20)
            .disabled(!title.isEmpty ? false : true)
        }
        .padding(.top, 10)
        .onChange(of: isTab) { newValue in
            hideKeyboard()
        }
        .frame(maxHeight: .infinity, alignment: .top)
    }
}
