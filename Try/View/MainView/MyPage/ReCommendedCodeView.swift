//
//  ReommendedCodeView.swift
//  Try
//
//  Created by 이민지 on 2023/01/05.
//

import SwiftUI
import Contacts
import MessageUI

struct ReCommendedCodeView: View {
    @StateObject var myPageViewModel = MyPageViewModel()
    @State var resultCode = 0
    @State var tabId = ""
    @State var searchText = ""
    
    private let messageComposeDelegate = MessageComposeDelegate()
    
    var body: some View {
        VStack(spacing: 0) {
            searchView
            
            if !myPageViewModel.contacts.isEmpty {
                searchListMode()
            }
        }
        .onAppear {
            myPageViewModel.getContacts()
        }
        .modifier(AppBackgroundColor())
    }
    
    @ViewBuilder
    func searchListMode() -> some View {
        switch myPageViewModel.listMode {
        case .allList:
            phoneNumberListView()
        case .filtering:
            searchFilter()
        }
    }
    
    // MARK: Search
    var searchView: some View {
        ZStack {
            TextField("검색", text: $searchText)
                .padding(8)
                .background(Color.gray.opacity(0.1))
                .cornerRadius(6)
                .foregroundColor(Color.white)
                .onChange(of: searchText) { newValue in
                    if searchText == "" {
                        myPageViewModel.listMode = .allList
                    } else {
                        myPageViewModel.listMode = .filtering
                    }
                }
        }
        .padding(.horizontal, 20)
        .padding(.top, 30)
    }
    
    // MARK: 검색 필터링
    @ViewBuilder
    func searchFilter() -> some View {
        let filter = myPageViewModel.contacts.filter({$0.name.contains(searchText)})
        List {
            ForEach(0..<filter.count, id: \.self) { i in
                Button {
                    self.presentMessageCompose(id: filter[i].id)
                } label: {
                    Text(filter[i].name)
                        .foregroundColor(.white)
                        .defaultFont(size: 13)
                }
            }
        }
    }
    
    // MARK: all phone number list
    @ViewBuilder
    func phoneNumberListView() -> some View {
        List {
            ForEach(0..<myPageViewModel.contacts.count, id: \.self) { i in
                Button {
                    self.presentMessageCompose(id: myPageViewModel.contacts[i].id)
                } label: {
                    Text(myPageViewModel.contacts[i].name)
                        .foregroundColor(.white)
                        .defaultFont(size: 13)
                }
            }
        }
    }
}

extension ReCommendedCodeView {
    private class MessageComposeDelegate: NSObject,MFMessageComposeViewControllerDelegate {
        func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
            switch result {
            case MessageComposeResult.sent:
                print("전송 완료")
                break
            case MessageComposeResult.cancelled:
                print("취소")
                break
            case MessageComposeResult.failed:
                print("전송 실패")
                break
            @unknown default:
                break
            }
            controller.dismiss(animated: true)
        }
    }
    
    private func presentMessageCompose(id: String) {
        guard MFMessageComposeViewController.canSendText() else { return }
        let vc = UIApplication.shared.windows.filter({$0.isKeyWindow}).first?.rootViewController
        let compostVC = MFMessageComposeViewController()
        myPageViewModel.messageFilter(id: id) { i in
            myPageViewModel.setContactData(contact: Contact(
                id: myPageViewModel.contact?.id ?? "", name: myPageViewModel.contact?.name ?? "", phoneNumber: myPageViewModel.contact?.phoneNumber ?? "", code: myPageViewModel.recommendCode)
            )
            compostVC.recipients = [myPageViewModel.contacts[i].phoneNumber]
        }
        compostVC.body = """
        추천인 코드 : \(myPageViewModel.recommendCode)
        """
        compostVC.messageComposeDelegate = messageComposeDelegate
        vc?.present(compostVC, animated: true)
    }
}
