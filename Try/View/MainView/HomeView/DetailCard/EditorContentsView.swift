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
                mainViewModel.getContents()
            }
    }
}

struct SubContentView: View {
    @StateObject var mainViewModel: MainHomeViewModel
    @State var impressions = [Impression]()
    @State var title: String
    @State var impression = ""
    @State var isMission = false
    @State var isMainCheck = false
    
    @State private var achieve = 0
    @State private var scrollingCellIndex = 0
    @State private var index = 0
    
    @Binding var isTab: Bool
    
    var body: some View {
        VStack {
            navigationBar
            
            missionSave
            
            Divider()
            
            ScrollViewReader { proxy in
                ScrollView(.vertical, showsIndicators: false) {
                    detailContentView(proxy: proxy)
                }
            }
            commentSendView
        }
        .onTapGesture {
            scrollingCellIndex = 0
            hideKeyboard()
        }
        .onAppear {
            isMainOrSub()
            if let impressions = mainViewModel.detailContent?.impressions {
                impressions.forEach { impression in
                    self.impressions.append(impression)
                }
            }
        }
    }
    
    var missionSave: some View {
        VStack(spacing: 12) {
            Text(title)
                .foregroundColor(.white)
                .font(.title2)
                .frame(maxWidth: .infinity, alignment: .center)
            
            HStack(spacing: 0) {
                Text(mainViewModel.contents?.nickName ?? "")
                    .font(.title2)
                    .foregroundColor(.white)
                
                Spacer()
                
                Button {
                    isMission.toggle()
                    if isMission {
                        is_Check()
                    } else {
                        is_NotCheck()
                    }
                } label: {
                    Text("미션완료")
                        .font(.title2)
                        .foregroundColor(isMission ? .white : .gray)
                }
            }
            .padding(.horizontal, 20)
            
            HStack(spacing: 0) {
                Text(mainViewModel.contents?.otherNickName ?? "")
                    .font(.title2)
                    .foregroundColor(.white)
                
                Spacer()
                
                if isContentUid() {
                    if let subCheck = mainViewModel.detailContent?.subCheck {
                        Text("미션완료")
                            .font(.title2)
                            .foregroundColor((subCheck.first(where: {$0.value == 1}) != nil) ? .white : .gray)
                    }
                } else {
                    if let mainCheck = mainViewModel.detailContent?.mainCheck {
                        Text("미션완료")
                            .font(.title2)
                            .foregroundColor((mainCheck.first(where: {$0.value == 1}) != nil) ? .white : .gray)
                    }
                }
            }
            .padding(.horizontal, 20)
        }
    }
    
    @ViewBuilder
    func detailContentView(proxy: ScrollViewProxy) -> some View {
        LazyVStack {
            ForEach(0..<impressions.count, id: \.self) { index in
                VStack(alignment: .leading, spacing: 10) {
                    HStack(spacing: 6) {
                        Text(impressions[index].nickName)
                            .foregroundColor(.white)
                            .defaultFont(size: 14)
                        
                        Text(impressions[index].introduce)
                            .foregroundColor(.gray)
                            .defaultFont(size: 12)
                    }
                    
                    Text(impressions[index].oneImpression)
                        .foregroundColor(.white)
                        .defaultFont(size: 18)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .onChange(of: scrollingCellIndex) { newValue in
                    // MARK: 답변 달았을 때 -> 내가 작성한 답글이 있는 인덱스로 scroll이동
                    withAnimation {
                        proxy.scrollTo(newValue, anchor: .top)
                    }
                }
            }
            .padding(.top, 16)
        }
        .padding(.horizontal, 20)
    }
    
    var commentSendView: some View {
        HStack(spacing: 8) {
            TextField("한줄 소감", text: $impression)
                .padding()
                .padding(.leading, 6)
                .background(Color.gray.opacity(0.1))
                .cornerRadius(6)
                .foregroundColor(Color.white)
                .onTapGesture {
                    // MARK: 답변 달았을 때 -> 내가 작성한 답글이 있는 인덱스로 scroll이동
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                        scrollingCellIndex = impressions.count - 1
                    }
                }
                .onChange(of: impression) { newValue in
                    // MARK: 답변 달았을 때 -> 내가 작성한 답글이 있는 인덱스로 scroll이동
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                        scrollingCellIndex = impressions.count - 1
                    }
                }
            
            Button {
                impressions.append(
                    Impression(
                        nickName: mainViewModel.userInfoData?.nickName ?? "",
                        introduce: mainViewModel.userInfoData?.introduce ?? "",
                        oneImpression: impression)
                )
                mainViewModel.setImpression(title: title, detailContent: impressions)
                mainViewModel.getImpression(title: title)
                impression = ""
            } label: {
                Text("전송")
            }
        }
        .frame(maxWidth: .infinity, alignment: .bottom)
        .padding(.horizontal, 20)
        .padding(.bottom, 5)
    }
    
    var navigationBar: some View {
        ZStack {
            NavigationCustomBar(naviType: .cardDetail, isButton: $isTab)
            
            Button {
                mainViewModel.setAchieveCheck(title: title, achieve: achieve)
                isTab.toggle()
            } label: {
                Text("확인")
                    .foregroundColor(isMission ? .white : .gray)
            }
            .frame(maxWidth: .infinity, alignment: .trailing)
            .padding(.trailing, 20)
            .disabled(isMission ? false : true)
        }
        .padding(.top, 10)
        .onChange(of: isTab) { newValue in
            hideKeyboard()
        }
        .frame(maxWidth: .infinity, alignment: .top)
    }
    
    // MARK: 미션완료 main인지 sub인지 구분하기
    func isMainOrSub() {
        if isContentUid() {
            if let check = mainViewModel.detailContent?.mainCheck[ShareVar.userUid] {
                if check == 1 {
                    isMission = true
                } else {
                    isMission = false
                }
            }
        } else {
            if let check = mainViewModel.detailContent?.subCheck[ShareVar.userUid] {
                if check == 1 {
                    isMission = true
                } else {
                    isMission = false
                }
            }
        }
    }
    
    func is_Check() {
        if isContentUid() {
            if let check = mainViewModel.detailContent?.mainCheck[ShareVar.userUid] {
                achieve = check + 1
            }
        } else {
            if let check = mainViewModel.detailContent?.subCheck[ShareVar.userUid] {
                achieve = check + 1
            }
        }
    }
    
    func is_NotCheck() {
        if isContentUid() {
            if let check = mainViewModel.detailContent?.mainCheck[ShareVar.userUid] {
                achieve = check - 1
            }
        } else {
            if let check = mainViewModel.detailContent?.subCheck[ShareVar.userUid] {
                achieve = check - 1
            }
        }
    }
    
    func isContentUid() -> Bool {
        if ((mainViewModel.detailContent?.mainCheck.first(where: {$0.key == ShareVar.userUid})) != nil) {
            return true
        } else {
            return false
        }
    }
}
