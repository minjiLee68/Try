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
}
