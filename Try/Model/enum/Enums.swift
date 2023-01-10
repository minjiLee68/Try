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
    case signUp
    case detail
    case mypage
}

// MARK: Search Mode
enum searchMode {
    case filtering
    case allList
}

// MARK: popup
enum PopupMode {
    case isBox
    case isnonBox
}
