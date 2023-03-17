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
    var time: String
    var uid: String
    var nickName: String
    var profile: String
    var otherUid: String
    var otherNickName: String
    var otherProfile: String
    var content: [String]
    var achieve: Bool = false
}

struct DetailContent: Codable, Hashable {
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
