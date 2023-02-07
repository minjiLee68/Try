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
    //MARK: 내 정보 가져오기
    static func getMyUserInfo() async throws -> UserInfo {
        let docRef = Firestore.firestore().collection(CollectionName.UserInfo.rawValue).document(ShareVar.userUid)
        let ref = try await docRef.getDocument()
        return try ref.data(as: UserInfo.self)
    }
    
    // MARK: 목표내용 저장하기
    static func addShareContent(nickName: String, profile: String, content: [String]) async throws {
        let docRef = Firestore.firestore().collection(CollectionName.UserInfo.rawValue)
        let ref = docRef.document(ShareVar.userUid).collection(CollectionName.HabitShare.rawValue).document()
        try ref.setData(from: Contents(nickName: nickName, profile: profile, content: content))
        
        let userRef = try await docRef.document(ShareVar.userUid).getDocument()
        let userData = try userRef.data(as: UserInfo.self)
        let otherRef = docRef.document(userRef.documentID).collection(CollectionName.HabitShare.rawValue).document()
        try otherRef.setData(from: Contents(
            nickName: userData.nickName,
            profile: userData.userProfile,
            content: content)
        )
    }
    
    // MARK: 공유된 목표정보 가져오기
    static func getShareInfo() async throws -> [Contents] {
        let docRef = Firestore.firestore().collection(CollectionName.UserInfo.rawValue).document(ShareVar.userUid)
        let ref = try await docRef.collection(CollectionName.HabitShare.rawValue).getDocuments()
        return ref.documents.compactMap { document in
            try? document.data(as: Contents.self)
        }
    }
    
    // MARK: 나와 연결된 사람
//    static func fieldReCommendCode() async throws -> [UserInfo] {
//        let docRef = Firestore.firestore().collection(CollectionName.UserInfo.rawValue)
//        let userRef = try await docRef.document(ShareVar.userUid).getDocument()
//        let userData = try userRef.data(as: UserInfo.self)
//        let query = try await docRef.whereField("reCommendCode", isEqualTo: userData.myCode).getDocuments()
//        return query.documents.compactMap { item in
//            try? item.data(as: UserInfo.self)
//        }
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
