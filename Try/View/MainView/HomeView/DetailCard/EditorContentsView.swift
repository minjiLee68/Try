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
            }
    }
}

struct SubContentView: View {
    @StateObject var mainViewModel: MainHomeViewModel
    @State var title: String
    @State var impression = ""
    @State var isMission = false
    
    @Binding var isTab: Bool
    
    var body: some View {
        ZStack {
            navigationBar
            VStack {
                detailContentView
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
            
            ForEach(0..<mainViewModel.detailContent.oneImpression.count, id: \.self) { index in
                Text(mainViewModel.detailContent.oneImpression[index])
                    .foregroundColor(.white)
            }
            
//            if let index = detailContent.firstIndex(where: {$0.contentTitle == title}) {
//                if !detailContent[index].oneImpression.isEmpty {
//                    Text(detailContent[index].oneImpression)
//                }
//            }
            
            HStack(spacing: 0) {
                TextField("한줄 소감", text: $impression)
                    .padding()
                    .padding(.leading, 6)
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(6)
                    .foregroundColor(Color.white)
                
                Button {
                    impression = ""
                    mainViewModel.detailContent.oneImpression.append(impression)
                } label: {
                    Text("전송")
                }
            }
            
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
                mainViewModel.setImpression(title: title, detailContent: mainViewModel.detailContent)
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
