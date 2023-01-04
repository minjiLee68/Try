//
//  SignUpView.swift
//  Try
//
//  Created by 이민지 on 2022/12/28.
//

import SwiftUI

struct SignUpView: View {
    @StateObject var signUpViewModel = SignUpViewModel()
    
    @State var isPickers = false
    @State var isImageChanged = false
    @State var isSave = false
    
    @State var nickName = ""
    @State var introduce = ""
    @State var nickNameField = "최소 4자 ~ 8자 입력 가능"
    @State var introduceField = "우리의 목표달성을 위한, 우리의 노력에 대한"
    
    @State private var userImage: UIImage = UIImage()
    
    let nickNameMaxCount = Int(8)
    let introduceMaxCount = Int(24)
    
    var body: some View {
        if signUpViewModel.isLogin {
            MainView()
        } else {
            signUpView
        }
    }
    
    // MARK: 회원가입 화면
    var signUpView: some View {
        VStack(spacing: 0) {
            ZStack {
                NavigationCustomBar(naviType: .signUp)
                
                Button {
                    signUpViewModel.setUserData(image: userImage, nickName: nickName, introduce: introduce)
                    print("완료")
                } label: {
                    Text("완료")
                        .foregroundColor(nickName.count >= 4 ? .white : .gray)
                }
                .disabled(nickName.count >= 4 ? false : true)
                .frame(maxWidth: .infinity, alignment: .trailing)
                .padding(.trailing, 20)
            }
            
            userProfile
                .sheet(isPresented: $isPickers) {
                    ProfilePicturePickerView(imageUpload: $userImage, isImageChanged: $isImageChanged)
                }
                .onChange(of: userImage) { newValue in
                    signUpViewModel.uploadImage(image: newValue)
                    signUpViewModel.imageUrl()
                }
            
            signUpContent
            
            oneLineIntroduce
            
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
}
