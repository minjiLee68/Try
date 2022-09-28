//
//  ContentView.swift
//  JointGoal_SwiftUI
//
//  Created by 이민지 on 2022/09/21.
//

import SwiftUI

struct HomeView: View {
    //MARK: View Properties
    @State var currentTab: Tab = .home
    @Namespace var animation
    
    //MARK: Carousel Properties
    @State var currentIndex: Int = 0
    
    var body: some View {
        VStack(spacing: 15) {
            HeaderView()
            
            SearchBar()
            
            // MARK: Custom Carousel
            CustomCarousel(index: $currentIndex, items: goalContents, cardPadding: 150, id: \.id) { contents, cardSize in
                // MARK: YOUR CUSTOM CELL VIEW
                RoundedRectangle(cornerRadius: 15, style: .continuous)
                    .fill(.black.opacity(0.5))
                    .frame(width: cardSize.width, height: cardSize.height)
                    .overlay(
                        Text(contents.content)
                            .foregroundColor(.white)
                            .fontWeight(.bold)
                    )
            }
            .padding(.horizontal, -15)
            .padding(.vertical)
            
            TabBar()
        }
        .padding([.horizontal, .top], 15)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .background {
            GeometryReader { proxy in
                //MARK: Image Will  Come Once We Implement Custom Carousel
                LinearGradient(colors: [
                    .clear,
                    Color.black.opacity(0.1),
                    Color.black.opacity(0.6)
                ], startPoint: .top, endPoint: .bottom)
            }
            .ignoresSafeArea()
        }
    }
}

extension HomeView {
    // MARK: Custom Tab Bar
    @ViewBuilder
    func TabBar() -> some View {
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
                    withAnimation(.easeInOut) {
                        currentTab = tab
                    }
                }
            }
        }
        .padding(.horizontal)
        .padding(.bottom, 10)
    }
    
    
    // MARK: Search Bar
    @ViewBuilder
    func SearchBar() -> some View {
        HStack(spacing: 15) {
            Image("Search")
                .renderingMode(.template)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 28, height: 28)
                .foregroundColor(.gray)
            
            TextField("Search", text: .constant(""))
                .padding(.vertical, 10)
        }
        .padding(.horizontal)
        .padding(.vertical, 6)
        .background {
            RoundedRectangle(cornerRadius: 15, style: .continuous)
                .fill(Color.white.opacity(0.12))
        }
        .padding(.top, 20)
    }
    
    // MARK: Header View
    @ViewBuilder
    func HeaderView() -> some View {
        HStack {
            VStack(alignment: .leading, spacing: 6) {
                (Text("Hello")
                    .fontWeight(.semibold) +
                 Text(" Minji")
                )
                .font(.title2)
                
                Text("Book your favorite content")
                    .font(.callout)
                    .foregroundColor(.gray)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            Button {
                
            } label: {
                Image("image1")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 50, height: 50)
                    .clipShape(Circle())
            }
        }
    }
}

//struct HomeView_Previews: PreviewProvider {
//    static var previews: some View {
//        HomeView()
//    }
//}
