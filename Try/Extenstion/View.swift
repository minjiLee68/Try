//
//  View.swift
//  Try
//
//  Created by 이민지 on 2023/01/04.
//

import SwiftUI

extension View {
    func defaultFont(size: Int) -> some View {
        self.modifier(Font(size: size))
    }
    
    func hideKeyboard() {
        let resign = #selector(UIResponder.resignFirstResponder)
        UIApplication.shared.sendAction(resign, to: nil, from: nil, for: nil)
    }
    
    func requestButton(text: String) -> some View {
        RoundedRectangle(cornerRadius: 5)
            .stroke(Color.blue)
            .frame(width: device.widthScale(60), height: device.heightScale(30))
            .overlay {
                Text(text)
                    .defaultFont(size: 12)
            }
    }
}
