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
            subUid: docId,
            subNickName: nickName,
            subProfile: profile,
            content: content)
        )
    }
    
    // MARK: 내용 편집하기
    static func updateShareContent(title: String, mainCheck: [String:Int], subCheck: [String:Int], detailContent: [Impression]) async throws {
        let docRef = Firestore.firestore().collection(CollectionName.HabitShare.rawValue)
        let query = try await docRef.whereField("id", isEqualTo: ShareVar.documentId).getDocuments()
        let docId = query.documents.first?.documentID ?? ""
        let content = try await docRef.document(docId).getDocument()
        let impressionRef = docRef.document(docId).collection(CollectionName.Impression.rawValue).document(title)
        do {
            try impressionRef.setData(
                from: DetailContent(
                    mainCheck: mainCheck,
                    subCheck: subCheck,
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
        let transformedContents = self.contentMapping(try content.data(as: Contents.self))
        return transformedContents
    }
    
    // MARK: 공유된 목표정보 가져오기
    static func getShareInfo(_ completion: @escaping (Contents) -> ()) {
        let mainDocRef = Firestore.firestore().collection(CollectionName.HabitShare.rawValue)
            .whereField("uid", isEqualTo: ShareVar.userUid)
        
        mainDocRef.getDocuments { querySnapshot, error in
            if let documents = querySnapshot?.documents, !documents.isEmpty {
                ShareVar.isMainCheck = true
                for doc in documents {
                    if let data = try? doc.data(as: Contents.self) {
                        // MARK: Mapping !!
                        let transformedContents = self.contentMapping(data)
                        completion(transformedContents)
                    }
                }
            } else {
                let subDocRef = Firestore.firestore().collection(CollectionName.HabitShare.rawValue)
                    .whereField("subUid", isEqualTo: ShareVar.userUid)
                
                subDocRef.getDocuments { querySnapshot, error in
                    if let documents = querySnapshot?.documents, !documents.isEmpty {
                        ShareVar.isMainCheck = false
                        for doc in documents {
                            if let data = try? doc.data(as: Contents.self) {
                                // MARK: Mapping !!
                                let transformedContents = self.contentMapping(data)
                                completion(transformedContents)
                            }
                        }
                    }
                }
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
    
    // MARK: content item mapping
    static func contentMapping(_ contents: Contents) -> Contents {
        let uid = ShareVar.isMainCheck ? contents.uid : contents.subUid
        let nickName = ShareVar.isMainCheck ? contents.nickName : contents.subNickName
        let profile = ShareVar.isMainCheck ? contents.profile : contents.subProfile
        let subUid = ShareVar.isMainCheck ? contents.subUid : contents.uid
        let subNickName = ShareVar.isMainCheck ? contents.subNickName : contents.nickName
        let subProfile = ShareVar.isMainCheck ? contents.subProfile : contents.profile
        
        let transformedContents = Contents(
            id: contents.id,
            time: contents.time,
            uid: uid,
            nickName: nickName,
            profile: profile,
            subUid: subUid,
            subNickName: subNickName,
            subProfile: subProfile,
            content: contents.content
        )
        return transformedContents
    }
}
