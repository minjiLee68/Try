//
//  MainView.swift
//  Try
//
//  Created by 이민지 on 2023/01/04.
//

import SwiftUI

struct MainView: View {
    @State var currentTab: Tab = .home
    @State var currentIndex: Int = 0
    
    @Namespace var animation
    
    var body: some View {
        ZStack {
            TabView(selection: $currentTab) {
                HomeView()
                    .tag(Tab.home)
                
                MyPageView()
                    .tag(Tab.profile)
            }
            
            VStack(spacing: 0) {
                Spacer()
                tabBar()
            }
        }
    }
}

extension MainView {
    @ViewBuilder
    func tabBar() -> some View {
        HStack(spacing: 0) {
            ForEach(Tab.allCases, id: \.rawValue) { tab in
                VStack(spacing: -2) {
                    Image(tab.rawValue)
                        .renderingMode(.template)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 28, height: 28)
                        .foregroundColor(currentTab == tab ? .white : .gray.opacity(0.6))
                    
                    if currentTab == tab {
                        Circle()
                            .fill(.white)
                            .frame(width: 5, height: 5)
                            .offset(y: 10)
                            .matchedGeometryEffect(id: "TAB", in: animation)
                    }
                }
                .frame(maxWidth: .infinity)
                .contentShape(Rectangle())
                .onTapGesture {
                    withAnimation {
                        currentTab = tab
                    }
                }
            }
        }
        .padding(.horizontal)
        .padding(.bottom, 10)
    }
}
