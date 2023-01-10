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
    @AppStorage("recommendCode") var recommendCode = ""
    
    let db = Firestore.firestore()
    let storageRef = Storage.storage().reference().child("profile/\(ShareVar.userUid)")
    let collectionRef = Firestore.firestore().collection(CollectionName.UserInfo.rawValue).document(ShareVar.userUid)
    
    func setUserData(image: UIImage, nickName: String, introduce: String, code: String) {
        self.myCode()
        do {
            try self.collectionRef.setData(from: UserInfo(
                nickName: nickName,
                userProfile: self.profileImage,
                introduce: introduce,
                reCommendCode: code,
                myCode: self.recommendCode
            ))
            isLogin = true
        } catch {
            print("error")
        }
        
        if code != "" {
            self.recommendCodeOverlap(code: code)
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
    
    // MARK: 추천 코드 입력
    func recommendCodeOverlap(code: String) {
        let query = db.collection(CollectionName.UserInfo.rawValue).whereField("myCode", isEqualTo: code)
        query.getDocuments { (snapshot, error) in
            if error != nil { return }
            for doc in snapshot!.documents {
                do {
                    let data = try doc.data(as: Contents.self)
                    let ref = self.collectionRef.collection(CollectionName.ShareGoal.rawValue)
                    let _ = try ref.addDocument(from: Contents(nickName: data.nickName, profile: data.profile, content: data.content))
                } catch {
                    print("error \(error.localizedDescription)")
                }
            }
        }
    }
    
    // MARK: 내 고유 코드
    func myCode() {
        let rand = Int.random(in: 111111..<999999)
        self.recommendCode = String(rand)
    }
}
