//
//  MyPageView.swift
//  Try
//
//  Created by 이민지 on 2023/01/04.
//

import SwiftUI
import Contacts
import MessageUI

struct MyPageView: View {
    @StateObject var myPageViewModel = MyPageViewModel()
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
        TextField("검색", text: $searchText)
            .padding()
            .onChange(of: searchText) { newValue in
                if searchText == "" {
                    myPageViewModel.listMode = .allList
                } else {
                    myPageViewModel.listMode = .filtering
                }
            }
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

extension MyPageView {
    private class MessageComposeDelegate: NSObject,MFMessageComposeViewControllerDelegate {
        func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
            controller.dismiss(animated: true)
        }
    }
    
    private func presentMessageCompose(id: String) {
        guard MFMessageComposeViewController.canSendText() else { return }
        let vc = UIApplication.shared.windows.filter({$0.isKeyWindow}).first?.rootViewController
        let compostVC = MFMessageComposeViewController()
        for i in 0..<myPageViewModel.contacts.count {
            if myPageViewModel.contacts[i].id == id {
                compostVC.recipients = [myPageViewModel.contacts[i].phoneNumber]
            }
        }
        compostVC.body = """
        추천인 코드 :
        """
        compostVC.messageComposeDelegate = messageComposeDelegate
        
        vc?.present(compostVC, animated: true)
    }
}
