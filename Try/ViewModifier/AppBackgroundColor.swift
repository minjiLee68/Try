//
//  AppBackgroundColor.swift
//  Try
//
//  Created by 이민지 on 2022/12/28.
//

import SwiftUI

struct AppBackgroundColor: ViewModifier {
    @StateObject var viewModel = MainHomeViewModel()
    @Binding var currentIndex: Int
    
    func body(content: Content) -> some View {
        content
            .background {
                GeometryReader { proxy in
                    let size = proxy.size
                    
                    TabView(selection: $currentIndex) {
                        ForEach(viewModel.goalContents.indices, id: \.self) { index in
                            Image(viewModel.goalContents[currentIndex].profile)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: size.width, height: size.height)
                                .clipped()
                        }
                    }
                    .tabViewStyle(.page(indexDisplayMode: .never))
                    .animation(.easeInOut, value: currentIndex)
                    
                    Rectangle()
                        .fill(.ultraThinMaterial)
                    
                    LinearGradient(colors: [
                        .clear,
                        Color.black.opacity(0.7),
                        Color.black.opacity(0.9)
                    ], startPoint: .top, endPoint: .bottom)
                }
                .ignoresSafeArea()
            }
    }
}
