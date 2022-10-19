//
//  Contents.swift
//  JointGoal_SwiftUI
//
//  Created by 이민지 on 2022/09/26.
//

import SwiftUI

// MARK: Contents - 각 사람들과 나에 목표에 대한 컨텐츠
//
struct Contents: Identifiable, Equatable {
    var id = UUID().uuidString
    var content: String // 목표 내용
    // Ensure Your Model Conforms Equatable.
}

var goalContents: [Contents] = [
    Contents(content: "나는 할 수 있어"),
    Contents(content: "넌 참 멋져"),
    Contents(content: "포기 하지마"),
    Contents(content: "포기 하지마"),
    Contents(content: "포기 하지마"),
    Contents(content: "포기 하지마"),
    Contents(content: "포기 하지마"),
]
