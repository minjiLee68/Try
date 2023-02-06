//
//  ProfileEditorView.swift
//  Try
//
//  Created by 이민지 on 2023/01/12.
//

import SwiftUI

struct ProfileEditorView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject var profileViewModel = ProfileSettingViewModel()
    
    @State var isPickers = false
    @State var isImageChanged = false
    @State var isSave = false
    
    @State var nickName: String
    @State var introduce: String
    @State var reCommend: String
    
    @State var settingType: Setting
    
    @State private var userImage: UIImage = UIImage()
    
    let nickNameMaxCount = Int(8)
    let introduceMaxCount = Int(24)
    let reCommendedCount = Int(6)
    
    var body: some View {
        signUpView
    }
    
    // MARK: 회원가입 화면
    var signUpView: some View {
        VStack(spacing: 0) {
            ZStack {
                NavigationCustomBar(naviType: .profileEditor, isButton: .constant(false))
                
                Button {
                    profileViewModel.setUserData(image: userImage, nickName: nickName, introduce: introduce, code: reCommend)
                    dismiss()
                } label: {
                    Text("완료")
                        .foregroundColor(nickName.count >= 4 ? .white : .gray)
                }
                .disabled(
                    (settingType == .EditProfile && nickName.count >= 3) ||
                    (settingType == .EditCode && reCommend != "") ? false : true
                )
                .frame(maxWidth: .infinity, alignment: .trailing)
                .padding(.trailing, 20)
            }
            
            userProfile
                .sheet(isPresented: $isPickers) {
                    ProfilePicturePickerView(imageUpload: $userImage, isImageChanged: $isImageChanged)
                }
                .onChange(of: userImage) { newValue in
                    profileViewModel.uploadImage(image: newValue)
                    profileViewModel.imageUrl()
                }
            
            signUpContent
            
            oneLineIntroduce
            
            reCommendedCode
            
            Spacer()
        }
    }
    
    // MARK: 프로필 세팅
    var userProfile: some View {
        Button {
            isPickers.toggle()
        } label: {
            ZStack {
                Image("profile")
                    .mask(Circle().frame(width: 80, height: 80))
                    .frame(width: 80, height: 80)
                    .opacity(isImageChanged ? 0: 1)
                
                Image(uiImage: userImage)
                    .resizable()
                    .frame(width: 80, height: 80)
                    .clipShape(Circle())
                    .opacity(isImageChanged ? 1 : 0)
            }
        }
        .padding(.top, 50)
        .disabled(settingType == .EditCode ? true : false)
    }
    
    // MARK: 닉네임 세팅
    var signUpContent: some View {
        HStack {
            Text("닉네임 ")
                .foregroundColor(.white)
                .fontWeight(.medium)
            
            TextField("", text: $nickName)
                .padding(12)
                .background(Color.gray.opacity(0.1))
                .cornerRadius(6)
                .foregroundColor(settingType == .EditCode ? .gray : .white)
                .onChange(of: nickName) { newValue in
                    if nickName.count > nickNameMaxCount {
                        nickName = String(nickName.prefix(nickNameMaxCount))
                    }
                }
                .disabled(settingType == .EditCode ? true : false)
        }
        .padding(.horizontal, 20)
        .padding(.top, 40)
    }
    
    // MARK: 한줄 소개
    var oneLineIntroduce: some View {
        VStack {
            Text("한줄각오")
                .foregroundColor(.white)
                .fontWeight(.medium)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            TextField("", text: $introduce)
                .padding(12)
                .background(Color.gray.opacity(0.1))
                .cornerRadius(6)
                .foregroundColor(settingType == .EditCode ? .gray : .white)
                .onChange(of: introduce) { newValue in
                    if introduce.count > introduceMaxCount {
                        introduce = String(introduce.prefix(introduceMaxCount))
                    }
                }
                .disabled(settingType == .EditCode ? true : false)
        }
        .padding(.horizontal, 20)
        .padding(.top, 40)
    }
    
    // MARK: 추천인 코드
    var reCommendedCode: some View {
        VStack {
            Text("추천코드")
                .foregroundColor(.white)
                .fontWeight(.medium)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            TextField("", text: $reCommend)
                .padding(12)
                .background(Color.gray.opacity(0.1))
                .cornerRadius(6)
                .foregroundColor(Color.white)
                .onChange(of: reCommend) { newValue in
                    if reCommend.count > reCommendedCount {
                        reCommend = String(reCommend.prefix(reCommendedCount))
                    }
                }
        }
        .padding(.horizontal, 20)
        .padding(.top, 40)
    }
}

