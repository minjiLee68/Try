//
//  ShareInfoViewModel.swift
//  Try
//
//  Created by 이민지 on 2023/01/19.
//

import SwiftUI
import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

enum ShareInfoService {
    // MARK: Date
    static func dateString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateString = dateFormatter.string(from: Date())
        return dateString
    }
    
    //MARK: 내 정보 가져오기
    static func getMyUserInfo(completion: @escaping (UserInfo) -> ()) {
        let docRef = Firestore.firestore().collection(CollectionName.UserInfo.rawValue).document(ShareVar.userUid)
        docRef.addSnapshotListener { (docSnapshot, error) in
            guard let document = docSnapshot else { return }
            do {
                completion(try document.data(as: UserInfo.self))
            } catch {
                print("userInfoFetchData error -> \(error.localizedDescription)")
            }
        }
    }
    
    // MARK: 목표내용 저장하기
    static func addShareContent(nickName: String, profile: String, content: [DetailContent]) async throws {
        let docRef = Firestore.firestore().collection(CollectionName.UserInfo.rawValue)
        let userRef = try await docRef.document(ShareVar.userUid).getDocument()
        let userData = try userRef.data(as: UserInfo.self)
        let query = try await docRef.whereField("nickName", isEqualTo: ShareVar.selectName).getDocuments()
        let docId = query.documents.last?.documentID ?? ""
        
        let ref = docRef.document(ShareVar.userUid).collection(CollectionName.HabitShare.rawValue).document(docId)
        try ref.setData(from: Contents(
            time: self.dateString(),
            nickName: nickName,
            profile: profile,
            content: content)
        )
        do {
            for doc in query.documents {
                let otherRef = docRef.document(doc.documentID).collection(CollectionName.HabitShare.rawValue).document(ShareVar.userUid)
                try otherRef.setData(from: Contents(
                    time: self.dateString(),
                    nickName: userData.nickName,
                    profile: userData.userProfile,
                    content: content)
                )
            }
        } catch {
            print("addContent error \(error.localizedDescription)")
        }
    }
    
    // MARK: 소감 내용 편집하기
    static func updateShareContent(title: String, updateData: String, index: Int) async throws {
        let docRef = Firestore.firestore().collection(CollectionName.UserInfo.rawValue).document(ShareVar.userUid)
        let query = try await docRef.collection(CollectionName.HabitShare.rawValue)
            .whereField("id", isEqualTo: ShareVar.documentId).getDocuments()
        let docId = query.documents.last?.documentID ?? ""
        let ref = docRef.collection(CollectionName.HabitShare.rawValue).document(docId)
        // 중첩된 필드 경로 지정
        let nestedData: [String: Any] = [
            "content": [
                "contentTitle": title,
                "oneImpression": updateData
            ]
        ]
        try await ref.setData(nestedData, merge: true)
    }
    
    // MARK: 공유된 목표정보 가져오기
    static func getShareInfo(_ completion: @escaping (Contents) -> ()) {
        let docRef = Firestore.firestore().collection(CollectionName.UserInfo.rawValue).document(ShareVar.userUid)
        docRef.collection(CollectionName.HabitShare.rawValue).addSnapshotListener { (queryDoc, error) in
            guard let document = queryDoc else { return }
            do {
                for doc in document.documents {
                    let data = try doc.data(as: Contents.self)
                    completion(data)
                }
            } catch {
                print("getShareInfo Error \(error.localizedDescription)")
            }
        }
    }
    
    // MARK: 나와 연결된 사람
//    static func friendRequests(_ completion: @escaping([UserInfo]) -> ()) {
//        let docRef = Firestore.firestore().collection(CollectionName.UserInfo.rawValue).document(ShareVar.userUid)
//        let query = docRef.collection(CollectionName.FriendRequest.rawValue).whereField("state", isEqualTo: 1)
//        query.addSnapshotListener { (querySnapshot, error) in
//            do {
//                if let querySnapshot {
//                    for doc in querySnapshot.documents {
//                        completion([try doc.data(as: UserInfo.self)])
//                    }
//                }
//            } catch {
//                print("friendRequest error \(error.localizedDescription)")
//            }
//        }
//    }
    
//    static func friendRequests() async throws -> [UserInfo] {
//        let docRef = Firestore.firestore().collection(CollectionName.UserInfo.rawValue).document(ShareVar.userUid)
//        let query = docRef.collection(CollectionName.FriendRequest.rawValue).whereField("state", isEqualTo: 1)
//        let document = try await query.getDocuments()
//        return document.documents.compactMap({ doc in
//            try? doc.data(as: UserInfo.self)
//        })
//    }
    
    // MARK: 내가 연결하고 싶은 사람
//    static func otherUserConnect(code: String) async throws {
//        let docRef = Firestore.firestore().collection(CollectionName.UserInfo.rawValue)
//        let query = try await docRef.whereField("myCode", isEqualTo: code).getDocuments()
//        for doc in query.documents {
//            let data = try doc.data(as: Contents.self)
//            let ref = docRef.document(ShareVar.userUid).collection(CollectionName.ShareGoal.rawValue).document(code)
//            try ref.setData(from: Contents(
//                nickName: data.nickName,
//                profile: data.profile,
//                content: data.content)
//            )
//        }
//    }
}
