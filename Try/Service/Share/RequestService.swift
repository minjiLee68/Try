//
//  RequestService.swift
//  Try
//
//  Created by 이민지 on 2023/02/07.
//

import SwiftUI
import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

enum RequestService {
    // MARK: 친구요청
    static func friendsRequest(nickName: String, state: Int) {
        let docRef = Firestore.firestore().collection(CollectionName.UserInfo.rawValue)
        ShareInfoService.getMyUserInfo { info in
            Task {
                if info.nickName == nickName {
                    return
                }
                let query = try await docRef.whereField("nickName", isEqualTo: nickName).getDocuments()
                for doc in query.documents {
                    let id = doc.documentID
                    guard let data = try? doc.data(as: UserInfo.self) else { continue }
                    let ref = docRef.document(ShareVar.userUid).collection(CollectionName.FriendRequest.rawValue).document(data.uid!)
                    try ref.setData(from: Friends(
                        uid: id,
                        nickName: nickName,
                        profile: data.userProfile,
                        state: state)
                    )
                    
                    let otherRef = docRef.document(id).collection(CollectionName.FriendRequest.rawValue).document(ShareVar.userUid)
                    try otherRef.setData(from: Friends(
                        uid: ShareVar.userUid,
                        nickName: info.nickName,
                        profile: info.userProfile,
                        state: state)
                    )
                }
            }
        }
    }
    
    // MARK: Friends Status
    static func friendsStatus(nickName: String) async throws  {
        let db = Firestore.firestore()
        // 1. 친구 요청 중 상태가 1인 문서 가져오기
        let friendRequestQuery = db.collection(CollectionName.UserInfo.rawValue).document(ShareVar.userUid)
            .collection(CollectionName.FriendRequest.rawValue)
            .whereField("state", isEqualTo: RequestStatus.accept.rawValue)
        let friendRequestSnapshot = try await friendRequestQuery.getDocuments()
        
        // 2. 친구 요청 중 상태가 1인 문서들의 닉네임을 Set으로 추출하기
//        let friendNames = Set(friendRequestSnapshot.documents.compactMap({ doc -> String? in
//            print("friendName \(String(describing: doc.get("nickName") as? String))")
//            return doc.get("nickName") as? String
//        }))
        
        let friendNames = friendRequestSnapshot.documents.compactMap { doc -> String? in
            print("friendName \(String(describing: doc.get("nickName") as? String))")
            return doc.get("nickName") as? String
        }
        
        if !friendNames.isEmpty {
            // 3. Set에 포함된 닉네임을 가진 UserInfo 문서들을 일괄 업데이트 한다.
            let userInfoQuery = db.collection(CollectionName.UserInfo.rawValue)
                .whereField("nickName", in: friendNames)
            
            // pagination 처리를 위해 마지막 문서를 기억
            var cursor: QueryDocumentSnapshot? = nil
            repeat {
    //            let querySnapshot = try await userInfoQuery.limit(to: 100).getDocuments()
                let querySnapshot = try await userInfoQuery.getDocuments()
                let batch = db.batch()
                for doc in querySnapshot.documents {
                    let docRef = db.collection(CollectionName.UserInfo.rawValue).document(doc.documentID)
                    batch.updateData(["status" : RequestStatus.accept.rawValue], forDocument: docRef)
                }
    //            querySnapshot.documents.forEach { doc in
    //                print("friend doc id\(doc.documentID)")
    //                let docRef = db.collection(CollectionName.UserInfo.rawValue).document(doc.documentID)
    //                batch.updateData(["status" : RequestStatus.accept.rawValue], forDocument: docRef)
    //            }
                try await batch.commit()
                cursor = querySnapshot.documents.last
                if querySnapshot.documents.isEmpty {
                    cursor = nil
                }
            } while cursor != nil
            
        } else {
            print("해당 값이 없습니다람쥐")
        }
        
//        let query = db.collectionGroup(CollectionName.FriendRequest.rawValue).whereField("state", isEqualTo: 1).whereField("nickName", isEqualTo: nickName)
//        let querySnapshot = try await query.getDocuments()
//        let friendData = querySnapshot.documents.compactMap { doc -> Friends? in
//            do {
//                return try doc.data(as: Friends.self)
//            } catch {
//                print("Error getting Friends from document: \(doc.documentID)")
//                return nil
//            }
//        }
//        let friendNames = Set(friendData.map({$0.nickName}))
//        let batch = db.batch()
//
//        let userQuery = db.collection(CollectionName.UserInfo.rawValue).whereField("nickName", in: Array(friendNames))
//        let userData = try await userQuery.getDocuments().documents.compactMap({ doc -> String? in
//            return doc.documentID
//        })
//
//        for id in userData {
//            let docRef = db.collection(CollectionName.UserInfo.rawValue).document(id)
//            batch.updateData(["status" : 1], forDocument: docRef)
//
//        }
    }
    
    //        let userData = querySnapshot.documents.compactMap { doc in
    //            try? doc.data(as: UserInfo.self)
    //        }
    //        let friendData = snapshot.documents.compactMap { doc in
    //            try? doc.data(as: Friends.self)
    //        }
    
    // MARK: 친구목록
    static func friendsList() async throws -> [Friends] {
        let document = Firestore.firestore().collection(CollectionName.UserInfo.rawValue).document(ShareVar.userUid)
        let ref = document.collection(CollectionName.FriendRequest.rawValue)
        let queryDoc = try await ref.whereField("state", isEqualTo: RequestStatus.accept.rawValue).getDocuments()
        return queryDoc.documents.compactMap { doc in
            try? doc.data(as: Friends.self)
        }
    }
}
