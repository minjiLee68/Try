//
//  EnvironmentViewModel.swift
//  Try
//
//  Created by 이민지 on 2023/01/06.
//

import SwiftUI
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseStorage

class EnvironmentViewModel: ObservableObject {
    @Published var isSideBtn = false
    @Published var drawerSelected = false
    let sideBarWidth = device.screenWidth - 60
}
