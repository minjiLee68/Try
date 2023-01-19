//
//  ShareInfoViewModel.swift
//  Try
//
//  Created by 이민지 on 2023/01/19.
//

import SwiftUI
import FirebaseFirestore
import FirebaseFirestoreSwift

enum ShareInfoService {
    
    // MARK: 공유된 목표정보 가져오기
    static func getShareInfo() async throws -> [Contents] {
        let docRef = Firestore.firestore().collection(CollectionName.UserInfo.rawValue).document(ShareVar.userUid)
        let ref = try await docRef.collection(CollectionName.ShareGoal.rawValue).getDocuments()
        return ref.documents.compactMap { document in
            try? document.data(as: Contents.self)
        }
    }
}
