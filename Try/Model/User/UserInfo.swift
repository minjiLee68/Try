//
//  UserInfo.swift
//  JointGoal_SwiftUI
//
//  Created by 이민지 on 2022/12/27.
//

import SwiftUI
import FirebaseFirestoreSwift

struct UserInfo: Codable {
    @DocumentID var uid: String?
    var nickName: String
    var userProfile: String
    var introduce: String
}
