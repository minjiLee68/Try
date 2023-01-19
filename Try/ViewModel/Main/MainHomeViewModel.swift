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

@MainActor
class MainHomeViewModel: ObservableObject {
    @Published var userInfoData: UserInfo?
    @Published var connectionUser = [Connection]()
    @Published var goalContents = [Contents]()
    @Published var contents = [String]()
    @AppStorage("myCode") var myCode = ""
    @AppStorage("reCommendCode") var reCommendCode = ""
    
    let db = Firestore.firestore()
    let docRef = Firestore.firestore().collection(CollectionName.UserInfo.rawValue)
    
    // MARK: 내 정보 가져오기
    func userInfoFetchData() {
        self.docRef.document(ShareVar.userUid).addSnapshotListener { (docSnapshot, error) in
            guard let document = docSnapshot else { return }
            do {
                self.userInfoData = try document.data(as: UserInfo.self)
                self.getShareGoal()
                print("success Data \(String(describing: self.userInfoData))")
            } catch {
                print("userInfoFetchData error -> \(error.localizedDescription)")
            }
        }
    }
    
    // MARK: 목표내용 저장하기
    func addShareContent(nickName: String, profile: String, code: String, content: [String]) {
        let ref = docRef.document(ShareVar.userUid).collection(CollectionName.ShareGoal.rawValue)
        do {
            let _ = try ref.addDocument(from: Contents(
                nickName: nickName,
                profile: profile,
                code: code,
                content: content)
            )
            getShareUser(content: content)
            getShareGoal()
        } catch {
            print("addShareContentError")
        }
    }
    
    // MARK: 공유된 목표정보 가져오기
    func getShareGoal() {
        Task {
            self.goalContents = try await ShareInfoService.getShareInfo()
        }
    }
    
    // MARK: 나와 연결된 사람 찾기
    func getShareUser(content: [String]) {
        Task {
            try await ShareInfoService.fieldReCommendCode(
                nickName: self.userInfoData?.nickName ?? "",
                profile: self.userInfoData?.userProfile ?? "",
                code: self.myCode,
                content: content)
        }
    }
    
    // MARK: 동일한 코드 정보 찾기
//    func fieldReCommendCode(content: [String]) {
//        let query = docRef.whereField("reCommendCode", isEqualTo: self.myCode)
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
//    }
    
    func addContent(contents: Contents) {
        let addRef = self.docRef.document(ShareVar.userUid).collection(CollectionName.ShareGoal.rawValue)
        do {
            let _ = try addRef.addDocument(from: contents)
        } catch {
            print("error")
        }
    }
    
    func connectionToItem(_ list: [Contents]) -> [Connection] {
        return list.map { item in
            return Connection(
                nickName: item.nickName,
                profile: item.profile,
                code: ""
            )
        }
    }
}
