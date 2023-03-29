//
//  Contents.swift
//  JointGoal_SwiftUI
//
//  Created by 이민지 on 2022/09/26.
//

import SwiftUI

// MARK: Contents - 각 사람들과 나에 목표에 대한 컨텐츠
struct Contents: Hashable, Codable {
    var id: String = UUID().uuidString
    var today: String
    var startDate: String
    var endDate: String
    var uid: String
    var nickName: String
    var profile: String
    var subUid: String
    var subNickName: String
    var subProfile: String
    var content: [String]
}

struct DetailContent: Codable, Hashable {
    var mainCheck: [String: Int]
    var subCheck: [String: Int]
    var impressions: [Impression]
}

struct Impression: Codable, Hashable {
    var nickName: String
    var introduce: String
    var oneImpression: String
}

// MARK: 추천인 코드를 통해 연결된 친구
struct Connection: Codable {
    var nickName: String
    var profile: String
}

struct Drawers {
    var drawerList = ""
    var type: DrawerType
}
