//
//  SignUpViewModel.swift
//  Try
//
//  Created by 이민지 on 2022/12/28.
//

import SwiftUI
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseAuth
import FirebaseStorage

class ProfileSettingViewModel: ObservableObject {
    @Published var profileImage = ""
    @AppStorage("isProfile") var isProfile = false
    @AppStorage("myCode") var myCode = ""
    @AppStorage("reCommendCode") var reCommendCode = ""
    @AppStorage("isMember") var isMember = UserDefaults.standard.bool(forKey: "isMember")
    
    let db = Firestore.firestore()
    let storageRef = Storage.storage().reference().child("profile/\(ShareVar.userUid)")
    let collectionRef = Firestore.firestore().collection(CollectionName.UserInfo.rawValue).document(ShareVar.userUid)
    
    func setUserData(image: UIImage, nickName: String, introduce: String, code: String) {
        self.uniqueCode(code: code)
        self.getShareUser(code: code)
        do {
            try self.collectionRef.setData(from: UserInfo(
                nickName: nickName,
                userProfile: self.profileImage,
                introduce: introduce,
                reCommendCode: code,
                myCode: self.myCode)
            )
        } catch {
            print("error")
        }
        self.isMember = true
    }
    
    // MARK: 나와 연결된 사람 찾기
    func getShareUser(code: String) {
        Task {
            try await ShareInfoService.otherUserConnect(code: code)
        }
    }
    
    func uploadImage(image: UIImage) {
        let data = image.jpegData(compressionQuality: 0.2)
        let metaData = StorageMetadata()
        metaData.contentType = "\(ShareVar.userUid)/jpg"
        if let data = data {
            storageRef.putData(data, metadata: metaData)
        }
    }
    
    func imageUrl() {
        let storageUrl = Storage.storage().reference(withPath: "profile/\(ShareVar.userUid)")
        storageUrl.downloadURL { url, error in
            self.profileImage = url?.absoluteString ?? ""
        }
    }
    
    func defaultImageUrl() {
        let storageUrl = Storage.storage().reference(withPath: "profile/defaultProfile.png")
        storageUrl.downloadURL { url, error in
            self.profileImage = url?.absoluteString ?? ""
        }
    }
    
    // MARK: 내 고유 코드
    func uniqueCode(code: String) {
        let rand = Int.random(in: 111111..<999999)
        self.myCode = String(rand)
        self.reCommendCode = code
    }
}
