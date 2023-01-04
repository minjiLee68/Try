//
//  NavigationCustomBar.swift
//  Try
//
//  Created by 이민지 on 2022/12/28.
//

import SwiftUI

struct NavigationCustomBar: View {
    @State var naviType: NaviType
    
    var body: some View {
        HStack(alignment: .center, spacing: 0) {
            switch naviType {
            case .signUp:
                naviContents(title: "회원가입")
            }
        }
        .padding([.horizontal, .vertical], 20)
        .frame(width: device.screenWidth)
        .background(Color.white.opacity(0.1))
    }
    
    @ViewBuilder
    func naviContents(title: String) -> some View {
        HStack(spacing: 0) {
            Text(title)
                .foregroundColor(.white)
                .fontWeight(.bold)
        }
    }
}
