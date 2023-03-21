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
    static func addShareContent(nickName: String, profile: String, content: [String]) async throws {
        let docRef = Firestore.firestore().collection(CollectionName.UserInfo.rawValue)
        let userRef = try await docRef.document(ShareVar.userUid).getDocument()
        let userData = try userRef.data(as: UserInfo.self)
        let query = try await docRef.whereField("nickName", isEqualTo: nickName).getDocuments()
        let docId = query.documents.last?.documentID ?? ""
        let ref = Firestore.firestore().collection(CollectionName.HabitShare.rawValue).document()
        try ref.setData(from: Contents(
            time: self.dateString(),
            uid: ShareVar.userUid,
            nickName: userData.nickName,
            profile: userData.userProfile,
            otherUid: docId,
            otherNickName: nickName,
            otherProfile: profile,
            content: content)
        )
    }
    
    // MARK: 내용 편집하기
    static func updateShareContent(title: String, detailContent: [Impression]) async throws {
        let docRef = Firestore.firestore().collection(CollectionName.HabitShare.rawValue)
        let query = try await docRef.whereField("id", isEqualTo: ShareVar.documentId).getDocuments()
        let docId = query.documents.first?.documentID ?? ""
        let content = try await docRef.document(docId).getDocument()
        let impressionRef = docRef.document(docId).collection(CollectionName.Impression.rawValue).document(title)
        do {
            try impressionRef.setData(
                from: DetailContent(
                    mainCheck: [try content.data(as: Contents.self).uid: 0],
                    subCheck: [try content.data(as: Contents.self).otherUid: 0],
                    impressions: detailContent),
                merge: true)
        } catch {
            print("Error UpdateShareContent")
        }
    }
    
    // MARK: isMissionCheck
    static func missionCheck(title: String, achieve: Int) async throws {
        let docRef = Firestore.firestore().collection(CollectionName.HabitShare.rawValue)
        let query = try await docRef.whereField("id", isEqualTo: ShareVar.documentId).getDocuments()
        let docId = query.documents.first?.documentID ?? ""
        let achieveRef = docRef.document(docId).collection(CollectionName.Impression.rawValue).document(title)
        let content = try await docRef.document(docId).getDocument()
        if try content.data(as: Contents.self).uid == ShareVar.userUid {
            try await achieveRef.updateData(["mainCheck": [ShareVar.userUid: achieve]])
        } else {
            try await achieveRef.updateData(["subCheck": [ShareVar.userUid: achieve]])
        }
    }
    
    // MARK: 해당 콘텐츠 가져오기
    static func getContents() async throws -> Contents {
        let docRef = Firestore.firestore().collection(CollectionName.HabitShare.rawValue)
        let query = try await docRef.whereField("id", isEqualTo: ShareVar.documentId).getDocuments()
        let docId = query.documents.first?.documentID ?? ""
        let content = try await docRef.document(docId).getDocument()
        return try content.data(as: Contents.self)
    }
    
    // MARK: 공유된 목표정보 가져오기
    static func getShareInfo(_ completion: @escaping (Contents) -> ()) {
        let docRef = Firestore.firestore().collection(CollectionName.HabitShare.rawValue)
            .whereField("uid", isEqualTo: ShareVar.userUid)
        docRef.addSnapshotListener { (queryDoc, error) in
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
    
    // MARK: 한줄 소감
    static func getImpression(title: String) async throws -> DetailContent {
        let docRef = Firestore.firestore().collection(CollectionName.HabitShare.rawValue)
        let query = try await docRef.whereField("id", isEqualTo: ShareVar.documentId).getDocuments()
        let docId = query.documents.first?.documentID ?? ""
        let getDoc = try await docRef.document(docId).collection(CollectionName.Impression.rawValue).document(title).getDocument()
        print("getDoc \(docId), \(try getDoc.data(as: DetailContent.self))")
        return try getDoc.data(as: DetailContent.self)
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
