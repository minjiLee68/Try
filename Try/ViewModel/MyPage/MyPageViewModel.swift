//
//  MyPageViewModel.swift
//  Try
//
//  Created by 이민지 on 2023/01/04.
//

import SwiftUI
import Contacts

class MyPageViewModel: ObservableObject {
    @Published var contacts = [Contact]()
    @Published var listMode: searchMode = .allList
    let store = CNContactStore()

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
//                try self.store.enumerateContacts(with: request, usingBlock: { (contact, stop) in
//                    guard let phoneNumber = contact.phoneNumbers.first?.value.stringValue else { return }
//                    let id = contact.identifier
//                    let givenName = contact.givenName
//                    let familyName = contact.familyName
//
//                    let contactToAdd = Contact(id: id, givenName: givenName, familyName: familyName, phoneNumber: phoneNumber)
//                    self.contacts.append(contactToAdd)
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
                phoneNumber: item.phoneNumbers.first?.value.stringValue ?? ""
            )
        }
    }
 }
