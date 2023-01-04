//
//  FireStoreManager.swift
//  Try
//
//  Created by 이민지 on 2022/12/27.
//

import SwiftUI
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseStorage

class MainHomeViewModel: ObservableObject {
    @Published var userInfoData: UserInfo?
    @Published var goalContents = [Contents]()
    
    let db = Firestore.firestore()
    let docRef = Firestore.firestore().collection(CollectionName.UserInfo.rawValue).document(ShareVar.userUid)
    
    func userInfoFetchData() {
        self.docRef.addSnapshotListener { (docSnapshot, error) in
            guard let document = docSnapshot else { return }
            do {
                self.userInfoData = try document.data(as: UserInfo.self)
                print("success Data \(String(describing: self.userInfoData))")
            } catch {
                print("error -> \(error.localizedDescription)")
            }
        }
    }
    
    func addContent(contents: Contents) {
        let addRef = self.docRef.collection(CollectionName.Goal.rawValue)
        do {
            let _ = try addRef.addDocument(from: contents)
        } catch {
            print("error")
        }
    }
}
