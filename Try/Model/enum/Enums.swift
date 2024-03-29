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
    case cardEditor
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
    case defaults = 0 // 기본 값
    case accept = 1 // 친구매칭 성공
    case refusal = 2 // 친구매칭 실패
    case wait = 3 // 친구요청
}

// MARK: detail page Type
enum DetailType {
    case Editable
    case Details
}

// MARK: Login Type
enum LoginType: String {
    case kakao = "kakao"
    case naver = "naver"
    case apple = "apple"
    case defaults = "default"
}
