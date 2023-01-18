//
//  MyPageViewModel.swift
//  Try
//
//  Created by 이민지 on 2023/01/04.
//

import SwiftUI
import FirebaseFirestoreSwift
import FirebaseFirestore
import Contacts
import KakaoSDKAuth
import KakaoSDKUser

class MyPageViewModel: ObservableObject {
    @Published var userInfoData: UserInfo?
    @Published var contact: Contact?
    @Published var contacts = [Contact]()
    @Published var listMode: searchMode = .allList
    
    let store = CNContactStore()
    
    let db = Firestore.firestore()
    let docRef = Firestore.firestore().collection(CollectionName.UserInfo.rawValue).document(ShareVar.userUid)
    
    @AppStorage("recommendCode") var recommendCode = ""
    @AppStorage("isMember") var isMember = UserDefaults.standard.bool(forKey: "isMember")
    
    // MARK: 내 정보 가져오기
    func userInfoFetchData() {
        self.docRef.addSnapshotListener { (docSnapshot, error) in
            guard let document = docSnapshot else { return }
            do {
                self.userInfoData = try document.data(as: UserInfo.self)
                print("success Data \(String(describing: self.userInfoData))")
            } catch {
                print("error -> \(error.localizedDescription)")
            }
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
    
    func contactUpdate(phoneNumber: String, send: Int) {
        docRef.collection(CollectionName.Contact.rawValue).getDocuments { (querySnapshot, error) in
            if let error {
                print("contact error -> \(error.localizedDescription)")
                return
            }
            if let querySnapshot {
                for doc in querySnapshot.documents {
                    do {
                        let data = try doc.data(as: Contact.self)
                        if data.phoneNumber == phoneNumber {
                            let id = doc.documentID
                            print("documentID \(id)")
                            let ref = self.docRef.collection(CollectionName.Contact.rawValue).document(id)
                            ref.updateData(["myFriends" : send])
                        }
                    } catch {
                        print("error")
                    }
                }
            }
        }
    }
    
    func messageFilter(id: String, completion: @escaping(Int) -> ()) {
        for i in 0..<self.contacts.count {
            if self.contacts[i].id == id {
                completion(i)
            }
        }
    }
    
    // 로그아웃
    func handleKakaoLogout() async -> Bool {
        await withCheckedContinuation({ continuation in
            UserApi.shared.logout { error in
                if let error = error {
                    print(error)
                    continuation.resume(returning: false)
                } else {
                    continuation.resume(returning: true)
                }
            }
        })
    }
    
    func kakaoLogout() {
        Task {
            if await handleKakaoLogout() {
                DispatchQueue.main.async {
                    self.isMember = false
                }
            }
        }
    }

    func getContacts() {
        let keys = [CNContactGivenNameKey, CNContactFamilyNameKey, CNContactPhoneNumbersKey] as [CNKeyDescriptor]
        let request = CNContactFetchRequest(keysToFetch: keys)
        request.sortOrder = CNContactSortOrder.userDefault
        // 권한 체크
        store.requestAccess(for: .contacts) { (granted, error) in
            guard granted else { return }
            do {
                // 연락처 데이터 획득
                let containerId = self.store.defaultContainerIdentifier()
                let predicate = CNContact.predicateForContactsInContainer(withIdentifier: containerId)
                let contact = try self.store.unifiedContacts(matching: predicate, keysToFetch: keys)
                self.contacts = self.contactMapping(cnContact: contact)
                contact.forEach { data in
                    print("Fetched contacts: \(String(describing: data.phoneNumbers.first?.value.stringValue))")
                }
//                })
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func contactMapping(cnContact: [CNContact]) -> [Contact] {
        return cnContact.map { item in
            return Contact(
                id: item.identifier,
                name: (item.familyName) + (item.givenName),
                phoneNumber: item.phoneNumbers.first?.value.stringValue ?? "",
                code: ""
            )
        }
    }
 }
