//
//  DrawerViewModel.swift
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

@MainActor
class DrawerViewModel: ObservableObject {
    @Published var userInfoData: UserInfo?
    @Published var userList = [UserInfo]()
    @Published var drawers = [Drawers]()
    @Published var friends = [Friends]()
    @Published var listMode: searchMode = .allList
    @Published var requestStatus: RequestStatus = .wait
    
    let db = Firestore.firestore()
    let docRef = Firestore.firestore().collection(CollectionName.UserInfo.rawValue).document(ShareVar.userUid)
    @AppStorage("isMember") var isMember = UserDefaults.standard.bool(forKey: "isMember")
    
    // MARK: 내 정보 가져오기
    func userInfoFetchData() {
        Task {
            ShareInfoService.getMyUserInfo { info in
                self.userInfoData = info
            }
        }
    }
    
    // MARK: 나와 연결된 사람 찾기
    func getShareUser(code: String) {
        Task {
//            try await ShareInfoService.otherUserConnect(code: code)
        }
    }
    
    // MARK: 친구요청
    func friendsRequest(id: String, state: Int) {
        Task {
            RequestService.friendsRequest(id: id, state: state)
        }
    }
    
    // MARK: 친구요청 상태
    func friendStatus() {
        Task {
            try await RequestService.friendsStatus()
        }
    }
    
    // MARK: 친구목록
    func friendList() {
        Task {
            self.friends.append(contentsOf: try await RequestService.friendsList())
        }
    }
    
    //MARK: 사용자 리스트 가져오기
    func getUserList() {
        self.db.collection(CollectionName.UserInfo.rawValue).addSnapshotListener { (docSnapshot, error) in
            guard let document = docSnapshot else { return }
            do {
                for doc in document.documents {
                    let data = try doc.data(as: UserInfo.self)
                    if data.nickName == self.userInfoData?.nickName {
                        print("getUserList \(data)")
                    }
                    self.friendStatus()
                    self.userList.append(data)
                }
            } catch {
                print("userInfoFetchData error -> \(error.localizedDescription)")
            }
        }
    }
    
    //MARK: Drawer list init
    func drawerList() {
        drawers = [
            Drawers(drawerList: "친구찾기", type: .FindingFriends),
            Drawers(drawerList: "나의 관찰 기록", type: .Observation),
            Drawers(drawerList: "아직 비우기", type: .Empty),
            Drawers(drawerList: "로그아웃", type: .Logout)
        ]
    }

 }

extension DrawerViewModel {
    // 로그아웃
    func oauth20ConnectionDidFinishDeleteToken() {
        NaverThirdPartyLoginConnection.getSharedInstance()?.requestDeleteToken()
        print("log out")
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
}

