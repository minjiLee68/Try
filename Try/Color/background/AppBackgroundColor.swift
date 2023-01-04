//
//  AppBackgroundColor.swift
//  Try
//
//  Created by 이민지 on 2022/12/28.
//

import SwiftUI

struct AppBackgroundColor: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background {
                GeometryReader { proxy in
                    LinearGradient(colors: [
                        Color.black,
                        Color.white.opacity(0.06),
                        Color.white.opacity(0.08)
                    ], startPoint: .top, endPoint: .bottom)
                }
                .edgesIgnoringSafeArea(.bottom)
//                .ignoresSafeArea(.all)
            }
    }
}
