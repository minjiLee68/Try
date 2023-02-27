//
//  UserInfo.swift
//  JointGoal_SwiftUI
//
//  Created by 이민지 on 2022/12/27.
//

import SwiftUI
import FirebaseFirestoreSwift

// MARK: 사용자 정보
struct UserInfo: Codable {
    @DocumentID var uid: String?
    var nickName: String
    var userProfile: String
    var introduce: String
    var status: Int
}

// MARK: 친구요청
struct Friends: Codable, Hashable {
    var uid: String
    var nickName: String
    var profile: String
    var state: Int
}
