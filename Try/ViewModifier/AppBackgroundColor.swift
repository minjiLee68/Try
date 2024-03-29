//
//  AppBackgroundColor.swift
//  Try
//
//  Created by 이민지 on 2022/12/28.
//

import SwiftUI

struct AppBackgroundColor: ViewModifier {
    @StateObject var viewModel: MainHomeViewModel
    @Binding var currentIndex: Int
    
    func body(content: Content) -> some View {
        content
            .background {
                GeometryReader { proxy in
                    let size = proxy.size
                    TabView(selection: $currentIndex) {
                        ForEach(0..<viewModel.goalContents.count, id: \.self) { _ in
                            ZStack {
                                if ShareVar.isMainCheck {
                                    profileImage(profile: viewModel.goalContents[currentIndex].subProfile, size: size)
                                } else {
                                    profileImage(profile: viewModel.goalContents[currentIndex].profile, size: size)
                                }
                            }
                        }
                    }
                    .tabViewStyle(.page(indexDisplayMode: .never))
                    .animation(.easeInOut, value: currentIndex)
                    
                    Rectangle()
                        .fill(.ultraThinMaterial)
                    
                    LinearGradient(colors: [
                        .clear,
                        Color.black.opacity(0.6),
                        Color.black.opacity(0.7)
                    ], startPoint: .top, endPoint: .bottom)
                }
                .ignoresSafeArea()
            }
    }
    
    @ViewBuilder
    func profileImage(profile: String, size: CGSize) -> some View {
        if profile == "" {
            Image("profile")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: size.width, height: size.height)
                .clipped()
        } else {
            WebImageView(url: profile, width: size.width, height: size.height)
                .clipped()
                .scaledToFill()
                .id(viewModel.goalContents[currentIndex].id)
        }
    }
}
