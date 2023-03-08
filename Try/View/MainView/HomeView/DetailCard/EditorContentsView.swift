//
//  EditorContentsView.swift
//  Try
//
//  Created by 이민지 on 2023/02/27.
//

import SwiftUI

struct EditorContentsView: View {
    @State var title: String
    @State var editorTitle = ""
    @State var index: Int
    
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
                SubContentView(title: title, index: index, isTab: $isCardTab)
                .onDisappear {
                    mode.wrappedValue.dismiss()
                }
            }
    }
}

struct SubContentView: View {
    @StateObject var mainViewModel = MainHomeViewModel()
    @State var title: String
    @State var impression = ""
    @State var index: Int
    
    @Binding var isTab: Bool
    
    var body: some View {
        VStack {
            navigationBar
            
            detailContentView
        }
    }
    
    var detailContentView: some View {
        VStack {
            Text(title)
                .font(.title2)
                .foregroundColor(.white)
            
            TextField("나의 소감", text: $impression)
                .padding()
                .padding(.leading, 6)
                .background(Color.gray.opacity(0.1))
                .cornerRadius(6)
                .foregroundColor(Color.white)
        }
    }
    
    var navigationBar: some View {
        ZStack {
            NavigationCustomBar(naviType: .cardDetail, isButton: $isTab)
            
            Button {
                mainViewModel.updateContent(title: title, impression: impression, index: index)
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
    }
}
