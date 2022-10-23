//
//  MainView.swift
//  JointGoal_SwiftUI
//
//  Created by 이민지 on 2022/10/20.
//

import SwiftUI

struct MainView: View {
    
    @State var currentTab: Tab = .home
    @State var currentIndex: Int = 0
    
    @Namespace var animation
    
    var body: some View {
        mainView
    }
    
    var mainView: some View {
        VStack(spacing: 15) {
            HeaderView()
            
            Text("우리의 목표달성을 위한, 우리의 노력에 대한")
            .font(.callout)
            .foregroundColor(.gray)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.vertical, 15)
            
            CustomCarousel_new(index: $currentIndex, items: goalContents, cardPadding: 150, id: \.id) { contents, cardSize in
                RoundedRectangle(cornerRadius: 15, style: .continuous)
                    .fill(.red)
                    .frame(width: cardSize.width, height: cardSize.height)
                    .overlay(
                        VStack {
                            Text(contents.content)
                                .foregroundColor(.white)
                                .fontWeight(.bold)
                        }
                    )
            }
            .padding(.horizontal, -30)
            .padding(.vertical)
            
            tabBar()
        }
        .padding([.horizontal, .top], 15)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .background {
            GeometryReader { proxy in
                LinearGradient(colors: [
                    Color.primary,
                    Color.primary.opacity(0.8),
                    Color.primary
                ], startPoint: .top, endPoint: .bottom)
            }
            .ignoresSafeArea()
        }
    }
    
    // MARK: Header View
    @ViewBuilder
    func HeaderView() -> some View {
        HStack {
            (Text("Hello")
                .fontWeight(.semibold) +
             Text(" Minji")
                .fontWeight(.bold)
                .font(.title2)
            )
            .foregroundColor(.white)
            .frame(maxWidth: .infinity, alignment: .leading)
            
            Button {
                
            } label: {
                Image("profileImage")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 50, height: 50)
                    .clipShape(Circle())
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

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
