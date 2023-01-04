//
//  Contents.swift
//  JointGoal_SwiftUI
//
//  Created by 이민지 on 2022/09/26.
//

import SwiftUI

// MARK: Contents - 각 사람들과 나에 목표에 대한 컨텐츠

struct Contents: Hashable, Codable {
    var id = UUID().uuidString
    var nickName: String
    var profile: String
    var content: [String]
    var isIndex: Bool = false
}
