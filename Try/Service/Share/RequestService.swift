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
    static func friendsRequest(nickName: String) async throws {
        let docRef = Firestore.firestore().collection(CollectionName.UserInfo.rawValue)
        let userData = try await ShareInfoService.getMyUserInfo()
        let query = try await docRef.whereField("nickName", isEqualTo: nickName).getDocuments()
        for doc in query.documents {
            let id = doc.documentID
            let ref = docRef.document(id).collection(CollectionName.FriendRequest.rawValue).document()
            try ref.setData(from: UserInfo(
                nickName: userData.nickName,
                userProfile: userData.userProfile,
                introduce: userData.introduce)
            )
        }
    }
}
