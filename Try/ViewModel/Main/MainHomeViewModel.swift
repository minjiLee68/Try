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
    @Published var connectionUser: Connection?
    @Published var connection = [Connection]()
    @Published var goalContents = [Contents]()
    
    let db = Firestore.firestore()
    let docRef = Firestore.firestore().collection(CollectionName.UserInfo.rawValue)
    
    // MARK: 내 정보 가져오기
    func userInfoFetchData() {
        self.docRef.document(ShareVar.userUid).addSnapshotListener { (docSnapshot, error) in
            guard let document = docSnapshot else { return }
            do {
                self.userInfoData = try document.data(as: UserInfo.self)
                print("success Data \(String(describing: self.userInfoData))")
            } catch {
                print("error -> \(error.localizedDescription)")
            }
        }
        self.getShareGoal()
    }
    
    // MARK: 공유된 목표정보 가져오기
    func getShareGoal() {
        self.connection = [Connection(nickName: "김경빈", profile: "profile", code: ""), Connection(nickName: "하정수", profile: "profile", code: ""),Connection(nickName: "김시온", profile: "profile", code: "")]
        self.goalContents = [Contents(id: "0", nickName: "", profile: "", content: ["추가하기"])]
        self.docRef.document(ShareVar.userUid).collection(CollectionName.ShareGoal.rawValue).getDocuments { (snapshot, error) in
            if let error {
                print("error \(error.localizedDescription)")
                return
            }
            if let snapshot {
                for doc in snapshot.documents {
                    do {
                        let data = try doc.data(as: Contents.self)
                        self.goalContents.append(Contents(nickName: data.nickName, profile: data.profile, content: data.content))
                    } catch {
                        print("error \(error.localizedDescription)")
                    }
                }
            }
        }
    }
    
    // MARK: 목표내용 저장하기
    func addShareContent(content: [String]) {
        let query = self.docRef.whereField("nickName", isEqualTo: self.connectionUser?.nickName ?? "")
        query.getDocuments { querySnapshot, error in
            if let error {
                print("error -> \(error.localizedDescription)")
                return
            }
            
            if let querySnapshot {
                for doc in querySnapshot.documents {
                    let addRef = self.docRef.document(doc.documentID).collection(CollectionName.ShareGoal.rawValue)
                    do {
                        let data = try doc.data(as: Contents.self)
                        let _ = try addRef.addDocument(from: Contents(
                            nickName: self.userInfoData?.nickName ?? "",
                            profile: self.userInfoData?.userProfile ?? "",
                            content: content)
                        )
                        
                        self.addContent(contents: Contents(
                            nickName: data.nickName,
                            profile: data.profile,
                            content: content)
                        )
                    } catch {
                        print("error")
                    }
                }
            }
        }
    }
    
    func addContent(contents: Contents) {
        let addRef = self.docRef.document(ShareVar.userUid).collection(CollectionName.ShareGoal.rawValue)
        do {
            let _ = try addRef.addDocument(from: contents)
        } catch {
            print("error")
        }
    }
}
