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
                    let data = try doc.data(as: UserInfo.self)
                    let ref = docRef.document(ShareVar.userUid).collection(CollectionName.FriendRequest.rawValue).document()
                    try ref.setData(from: Friends(
                        uid: id,
                        nickName: nickName,
                        profile: data.userProfile,
                        state: state)
                    )
                    
                    let otherRef = docRef.document(id).collection(CollectionName.FriendRequest.rawValue).document()
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
    
    // MARK: 친구목록
    static func friendsList() async throws -> [Friends] {
        let docRef = Firestore.firestore().collection(CollectionName.UserInfo.rawValue).document(ShareVar.userUid)
        let ref = try await docRef.collection(CollectionName.FriendRequest.rawValue).getDocuments()
        return ref.documents.compactMap { document in
            try? document.data(as: Friends.self)
        }
    }
}
