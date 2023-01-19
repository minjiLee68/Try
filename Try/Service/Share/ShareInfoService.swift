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
    
    // MARK: 공유된 목표정보 가져오기
    static func getShareInfo() async throws -> [Contents] {
        let docRef = Firestore.firestore().collection(CollectionName.UserInfo.rawValue).document(ShareVar.userUid)
        let ref = try await docRef.collection(CollectionName.ShareGoal.rawValue).getDocuments()
        return ref.documents.compactMap { document in
            try? document.data(as: Contents.self)
        }
    }
    
    // MARK: 동일한 코드 정보 찾기
    static func fieldReCommendCode(nickName: String, profile: String, code: String, content: [String]) async throws {
        let docRef = Firestore.firestore().collection(CollectionName.UserInfo.rawValue)
        let query = try await docRef.whereField("reCommendCode", isEqualTo: code).getDocuments()
        do {
            for doc in query.documents {
                let ref = docRef.document(doc.documentID).collection(CollectionName.ShareGoal.rawValue).document()
                try ref.setData(from: Contents(nickName: nickName, profile: profile, code: code, content: content))
            }
        } catch {
            print("addShareContentError")
        }
//        query.getDocuments { querySnapshot, error in
//            if let error {
//                print("get code error \(error.localizedDescription)")
//            }
//
//            if let querySnapshot {
//                for doc in querySnapshot.documents {
//                    let ref = self.docRef.document(doc.documentID).collection(CollectionName.ShareGoal.rawValue)
//                    do {
//                        let _ = try ref.addDocument(from: Contents(
//                            nickName: self.userInfoData?.nickName ?? "",
//                            profile: self.userInfoData?.userProfile ?? "",
//                            code: self.myCode,
//                            content: content)
//                        )
//                    } catch {
//                        print("addShareContentError")
//                    }
//                }
//            }
//        }
    }
}
