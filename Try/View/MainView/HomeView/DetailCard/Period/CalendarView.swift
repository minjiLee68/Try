//
//  PeriodSettingView.swift
//  Try
//
//  Created by 이민지 on 2023/03/29.
//

import SwiftUI

struct CalendarView: View {
    var body: some View {
        VStack{
            CalendarModuleView()
        }
    }
}

struct CalendarModuleView: View {
    var body: some View {
        CalendarModuleViewController()
    }
}
