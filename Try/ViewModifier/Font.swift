//
//  Font.swift
//  Try
//
//  Created by 이민지 on 2023/01/04.
//

import SwiftUI

struct Font: ViewModifier {
    var size = 14

    init(size: Int) {
        self.size = size
    }

    func body(content: Content) -> some View {
        content
            .font(.custom("SpoqaHanSansNeo-", size: CGFloat(size)))
    }
}
