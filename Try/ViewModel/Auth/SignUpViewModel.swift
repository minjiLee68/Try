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

class SignUpViewModel: ObservableObject {
    @Published var profileImage = ""
    @AppStorage("isLogin") var isLogin = false
    
    let db = Firestore.firestore()
    let storageRef = Storage.storage().reference().child("profile/\(ShareVar.userUid)")
    
    func setUserData(image: UIImage, nickName: String, introduce: String) {
        let collectionRef = db.collection(CollectionName.UserInfo.rawValue).document(ShareVar.userUid)
        do {
            try collectionRef.setData(from: UserInfo(nickName: nickName, userProfile: self.profileImage, introduce: introduce))
            isLogin = true
        } catch {
            print("error")
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
    
    func imageUrl()  {
        let storageUrl = Storage.storage().reference(withPath: "profile/\(ShareVar.userUid)")
        storageUrl.downloadURL { url, error in
            self.profileImage = url?.absoluteString ?? ""
        }
    }
}
