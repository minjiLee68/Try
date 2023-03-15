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
    @Published var detailContent: DetailContent = DetailContent(nickName: "", introduce: "")
    @Published var connectionUsers = [Friends]()
    @Published var goalContents = [Contents]()
    @Published var friendRequest = [Friends]()
//    @Published var detailContents = [String]()
    @Published var contents = [String]()
    
    let db = Firestore.firestore()
    let docRef = Firestore.firestore().collection(CollectionName.UserInfo.rawValue)
    
    // MARK: 내 정보 가져오기
    func userInfoFetchData() {
        Task {
            newFriendRequest()
            getFriendList()
        }
        ShareInfoService.getMyUserInfo { info in
            self.userInfoData = info
        }
        self.getShareGoal()
        self.getShareUser()
    }
    
    //MARK: 친구 리스트 가져오기
    func getFriendList() {
        Task {
            let friends = try await RequestService.friendsList()
            let uniqueFriends = Array(Set(connectionUsers + friends))
            DispatchQueue.main.async {
                self.connectionUsers = uniqueFriends
            }
        }
    }
    
    // MARK: 나에게 온 친구요청 확인
    func newFriendRequest() {
        docRef.document(ShareVar.userUid).collection(CollectionName.FriendRequest.rawValue).getDocuments { snapshot, error in
            if let error {
                print("newFriendRequest Fail \(error)")
            }
            /* 3. 'snapshot.documents'를 for문으로 순회하며 데이터를 가져오고 있습니다. 이 때, 가져온 데이터가 'Friends'타입이 아닐 경우 에러가 발생할 수 있습니다.
            따라서, 데이터를 가져올 때에는 타입 캐스팅을 안전하게 처리하는 것이 좋습니다.
                4. 'if data.state != RequestStatus.wait.rawValue'구문에서, 해당 요청에 상태가 'wait'이 아닌 경우에는 추천하지 않고 바로 리턴하도록 처리되어 있습니다.
                이러한 처리는 함수에서 어떤 역할을 하는지에 따라 다르므로, 그 역할이 명확하지 않다면 이 부분을 수정하도록 합니다.
             */
            if let snapshot {
                for doc in snapshot.documents {
                    guard let data = try? doc.data(as: Friends.self), data.state == RequestStatus.wait.rawValue else {
                        continue
                    }
                    self.friendRequest.append(data)
                }
            }
        }
    }
    
    // MARK: 요청에 대한 답변
    func friendsResponse(id: String, state: Int) {
        Task {
            RequestService.friendsRequest(id: id, state: state)
        }
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
                if !self.goalContents.contains(where: { $0.id == info.id }) {
                    self.goalContents.append(info)
                }
            }
        }
    }
    
    // MARK: 한줄소감
    func getImpression(title: String) {
        Task {
            self.detailContent = try await ShareInfoService.getImpression(title: title)
        }
    }
    
    // MARK: 나와 연결된 사람 찾기
    func getShareUser() {
        Task {
            self.connectionUsers = try await RequestService.friendsList()
        }
    }
    
    // MARK: content update
    func setImpression(title: String, detailContent: DetailContent) {
        Task {
            try await ShareInfoService.updateShareContent(title: title, detailContent: detailContent)
        }
//        let addRef = self.docRef.document(ShareVar.userUid).collection(CollectionName.HabitShare.rawValue)
//        do {
//            let _ = try addRef.addDocument(from: contents)
//        } catch {
//            print("error")
//        }
    }
}
