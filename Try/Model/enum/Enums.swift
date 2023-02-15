//
//  Tab.swift
//  JointGoal_SwiftUI
//
//  Created by 이민지 on 2022/09/27.
//

import SwiftUI

//MARK: Tab Enum
enum Tab: String, CaseIterable {
    case home = "Home"
    case explore = "Explore"
    case heart = "Heart"
    case profile = "Profile"
}

// MARK: Navi Enum
enum NaviType {
    case profileSetting
    case cardDetail
    case drawerDetail
    case mypage
    case profileEditor
}

// MARK: Drawer Enum
enum DrawerType {
    case FindingFriends
    case Observation
    case Empty
    case Logout
}

// MARK: Search Mode
enum searchMode {
    case filtering
    case allList
}

// MARK: 친구요청 상태
enum RequestStatus: Int {
    case wait = 0
    case accept = 1
    case refusal = 2
}

// MARK: detail page Type
enum DetailType {
    case Editable
    case Additional
}

// MARK: Login Type
enum LoginType: String {
    case kakao = "kakao"
    case naver = "naver"
    case apple = "apple"
    case defaults = "default"
}
