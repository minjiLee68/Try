//
//  OtherPageViewModel.swift
//  Try
//
//  Created by 이민지 on 2023/02/07.
//

import SwiftUI
import FirebaseFirestoreSwift
import FirebaseFirestore
import NaverThirdPartyLogin
import KakaoSDKAuth
import KakaoSDKUser

class OtherPageViewModel: ObservableObject {
    @Published var userInfoData: UserInfo?
    @Published var contact: Contact?
    @Published var contacts = [Contact]()
    @Published var listMode: searchMode = .allList
    
    let db = Firestore.firestore()
    
    @AppStorage("recommendCode") var recommendCode = ""
    @AppStorage("myCode") var myCode = ""
    @AppStorage("isMember") var isMember = UserDefaults.standard.bool(forKey: "isMember")
    
    // MARK: 내 정보 가져오기
    func userInfoFetchData(userUid: String) {
        let docRef = db.collection(CollectionName.UserInfo.rawValue).document(userUid)
        docRef.addSnapshotListener { (docSnapshot, error) in
            guard let document = docSnapshot else { return }
            do {
                self.userInfoData = try document.data(as: UserInfo.self)
                print("success Data \(String(describing: self.userInfoData))")
            } catch {
                print("userInfoFetchData error -> \(error.localizedDescription)")
            }
        }
    }
    
    // MARK: 나와 연결된 사람 찾기
    func getShareUser(code: String) {
        Task {
//            try await ShareInfoService.otherUserConnect(code: code)
        }
    }
    
    //MARK: 친구 리스트 가져오기
    func setContactData(contact: Contact) {
        let ref = db.collection(CollectionName.Contact.rawValue)
        do {
            let _ = try ref.addDocument(from: Contact(id: ShareVar.userUid, name: contact.name, phoneNumber: contact.phoneNumber, code: contact.code))
        } catch {
            print("error")
        }
    }
 }

