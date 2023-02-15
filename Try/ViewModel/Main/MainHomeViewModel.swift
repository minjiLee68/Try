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
    @Published var connectionUsers = [Connection]()
    @Published var goalContents = [Contents]()
    @Published var contents = [String]()
    
    let db = Firestore.firestore()
    let docRef = Firestore.firestore().collection(CollectionName.UserInfo.rawValue)
    
    // MARK: 내 정보 가져오기
    func userInfoFetchData() {
        Task {
            ShareInfoService.getMyUserInfo { info in
                self.userInfoData = info
            }
            self.getShareGoal()
        }
//        self.docRef.document(ShareVar.userUid).addSnapshotListener { (docSnapshot, error) in
//            self.getShareGoal()
//            guard let document = docSnapshot else { return }
//            do {
//                self.userInfoData = try document.data(as: UserInfo.self)
//            } catch {
//                print("userInfoFetchData error -> \(error.localizedDescription)")
//            }
//        }
    }
    
    // MARK: 목표내용 저장하기
    func addShareContent(nickName: String, profile: String, content: [String]) {
        Task {
            try await ShareInfoService.addShareContent(
                nickName: nickName,
                profile: profile,
                content: content
            )
        }
    }
    
    // MARK: 공유된 목표정보 가져오기
    func getShareGoal() {
        Task {
            ShareInfoService.getShareInfo { info in
                self.goalContents.append(info)
            }
        }
    }
    
    // MARK: 나와 연결된 사람 찾기
    func getShareUser() {
        Task {
            self.connectionUsers = self.connectionToItem(try await ShareInfoService.friendRequests())
        }
    }
    
    func addContent(contents: Contents) {
//        let addRef = self.docRef.document(ShareVar.userUid).collection(CollectionName.HabitShare.rawValue)
//        do {
//            let _ = try addRef.addDocument(from: contents)
//        } catch {
//            print("error")
//        }
    }
    
    func connectionToItem(_ list: [UserInfo]) -> [Connection] {
        return list.map { item in
            return Connection(
                nickName: item.nickName,
                profile: item.userProfile
            )
        }
    }
}
