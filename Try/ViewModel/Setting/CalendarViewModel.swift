//
//  CalendarViewModel.swift
//  Try
//
//  Created by 이민지 on 2023/03/30.
//

import SwiftUI

class CalendarViewModel {
    static let shared = CalendarViewModel()
    var thisDay = 0
    var contents: Contents?
    
    func getThisDay() {
        Task {
            contents = try await ShareInfoService.getContents()
        }
    }
}
