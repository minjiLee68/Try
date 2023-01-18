//
//  SignUpView.swift
//  Try
//
//  Created by 이민지 on 2022/12/28.
//

import SwiftUI

struct ProfileSettingView: View {
    @StateObject var profileViewModel = ProfileSettingViewModel()
    
    @State var isPickers = false
    @State var isImageChanged = false
    @State var isSave = false
    
    @State var nickName = ""
    @State var introduce = ""
    @State var reCommend = ""
    
    @State var nickNameField = "최소 4자 ~ 8자 입력 가능"
    @State var introduceField = "우리의 목표달성을 위한, 우리의 노력에 대한"
    @State var reCommendField = "추천 코드가 있나요?"
    
    @State private var userImage: UIImage = UIImage()
    
    let nickNameMaxCount = Int(8)
    let introduceMaxCount = Int(24)
    let reCommendedCount = Int(6)
    
    var body: some View {
        if profileViewModel.isProfile {
            MainView()
        } else {
            signUpView
        }
    }
    
    // MARK: 회원가입 화면
    var signUpView: some View {
        VStack(spacing: 0) {
            ZStack {
                NavigationCustomBar(naviType: .profileSetting, isButton: .constant(false))
                
                Button {
                    profileViewModel.setUserData(image: userImage, nickName: nickName, introduce: introduce, code: reCommend)
                    profileViewModel.isProfile = true
                } label: {
                    Text("완료")
                        .foregroundColor(nickName.count >= 4 ? .white : .gray)
                }
                .disabled(nickName.count >= 3 ? false : true)
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
    }
    
    // MARK: 닉네임 세팅
    var signUpContent: some View {
        HStack {
            Text("닉네임 ")
                .foregroundColor(.white)
                .fontWeight(.medium)
            
            TextField(nickNameField, text: $nickName)
                .padding(12)
                .background(Color.gray.opacity(0.1))
                .cornerRadius(6)
                .foregroundColor(Color.white)
                .onChange(of: nickName) { newValue in
                    if nickName.count > nickNameMaxCount {
                        nickName = String(nickName.prefix(nickNameMaxCount))
                    }
                }
        }
        .padding(.horizontal, 20)
        .padding(.top, 30)
    }
    
    // MARK: 한줄 소개
    var oneLineIntroduce: some View {
        VStack {
            Text("한줄각오")
                .foregroundColor(.white)
                .fontWeight(.medium)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            TextField(introduceField, text: $introduce)
                .padding(12)
                .background(Color.gray.opacity(0.1))
                .cornerRadius(6)
                .foregroundColor(Color.white)
                .onChange(of: introduce) { newValue in
                    if introduce.count > introduceMaxCount {
                        introduce = String(introduce.prefix(introduceMaxCount))
                    }
                }
        }
        .padding(.horizontal, 20)
        .padding(.top, 30)
    }
    
    // MARK: 추천인 코드
    var reCommendedCode: some View {
        VStack {
            Text("추천코드")
                .foregroundColor(.white)
                .fontWeight(.medium)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            TextField(reCommendField, text: $reCommend)
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
        .padding(.top, 30)
    }
}
