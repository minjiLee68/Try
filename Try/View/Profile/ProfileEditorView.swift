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
                    profileViewModel.setUserData(image: userImage, nickName: profileViewModel.nickName, introduce: profileViewModel.introduce)
                    dismiss()
                } label: {
                    Text("완료")
                }
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
            
//            reCommendedCode
            
            Spacer()
        }
        .onAppear {
            profileViewModel.userInfoFetchData()
        }
    }
    
    // MARK: 프로필 세팅
    var userProfile: some View {
        Button {
            isPickers.toggle()
        } label: {
            ZStack {
                WebImageView(url: profileViewModel.profileImage, width: device.widthScale(80), height: device.heightScale(80))
                    .clipShape(Circle())
                    .id(UUID())
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
            
            TextField("", text: $profileViewModel.nickName)
                .padding(12)
                .background(Color.gray.opacity(0.1))
                .cornerRadius(6)
                .foregroundColor(.white)
                .onChange(of: profileViewModel.nickName) { newValue in
                    if profileViewModel.nickName.count > nickNameMaxCount {
                        profileViewModel.nickName = String(profileViewModel.nickName.prefix(nickNameMaxCount))
                    }
                }
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
            
            TextField("", text: $profileViewModel.introduce)
                .padding(12)
                .background(Color.gray.opacity(0.1))
                .cornerRadius(6)
                .foregroundColor(.white)
                .onChange(of: profileViewModel.introduce) { newValue in
                    if profileViewModel.introduce.count > introduceMaxCount {
                        profileViewModel.introduce = String(profileViewModel.introduce.prefix(introduceMaxCount))
                    }
                }
        }
        .padding(.horizontal, 20)
        .padding(.top, 40)
    }
    
//    // MARK: 추천인 코드
//    var reCommendedCode: some View {
//        VStack {
//            Text("추천코드")
//                .foregroundColor(.white)
//                .fontWeight(.medium)
//                .frame(maxWidth: .infinity, alignment: .leading)
//
//            TextField("", text: $reCommend)
//                .padding(12)
//                .background(Color.gray.opacity(0.1))
//                .cornerRadius(6)
//                .foregroundColor(Color.white)
//                .onChange(of: reCommend) { newValue in
//                    if reCommend.count > reCommendedCount {
//                        reCommend = String(reCommend.prefix(reCommendedCount))
//                    }
//                }
//        }
//        .padding(.horizontal, 20)
//        .padding(.top, 40)
//    }
}

