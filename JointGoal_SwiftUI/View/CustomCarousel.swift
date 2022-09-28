//
//  CustomCarousel.swift
//  JointGoal_SwiftUI
//
//  Created by 이민지 on 2022/09/28.
//

import SwiftUI

//MARK: Custom View
struct CustomCarousel<Content: View,Item,ID>: View where Item: RandomAccessCollection,ID: Hashable,ID: Equatable {
    var content: (Item.Element, CGSize) -> Content
    var id: KeyPath<Item.Element,ID>
    
    //MARK: View Properties
    var spacing: CGFloat
    var cardPadding: CGFloat
    var items: Item
    @Binding var index: Int
    
    init(
        index: Binding<Int>,
        items: Item,
        spacing: CGFloat = 30,
        cardPadding: CGFloat = 80,
        id: KeyPath<Item.Element, ID>,
        @ViewBuilder content: @escaping (Item.Element, CGSize) -> Content) {
            self.content = content
            self.id = id
            self._index = index
            self.spacing = spacing
            self.cardPadding = cardPadding
            self.items = items
        }
    
    //MARK: Gesture Properties
    @GestureState var translation: CGFloat = 0
    @State var offset: CGFloat = 0
    @State var lastStoredOffset: CGFloat = 0
    
    @State var currentIndex: Int = 0
    
    var body: some View {
        GeometryReader { proxy in
            let size = proxy.size
            
            //MARK: Reduced After Applying Card Spacing & Padding
            let cardWidth = size.width - (cardPadding - spacing)
            
            // Memory Efficient
            LazyHStack(spacing: spacing) {
                ForEach(items, id: id) { contents in
                    content(contents, CGSize(width: cardWidth, height: size.height))
                        .frame(width: cardWidth, height: size.height)
                        .contentShape(Rectangle())
                }
            }
            .padding(.horizontal, spacing)
            .offset(x: offset)
            .contentShape(Rectangle())
            .gesture(
                DragGesture(minimumDistance: 5)
                    .onChanged { onChange(value: $0, cardWidth: cardWidth) }
                    .onEnded { onEnd(value: $0, cardWidth: cardWidth) }
            )
        }
        .padding(.top, 60)
    }
    
    func onChange(value: DragGesture.Value, cardWidth: CGFloat) {
        let translationX = value.translation.width
        offset = translationX + lastStoredOffset
    }
    
    func onEnd(value: DragGesture.Value, cardWidth: CGFloat) {
        // MARK: Finding Current Index
        var _index = (offset / cardWidth).rounded()
        _index = max(-CGFloat(items.count -  1), _index)
        _index = min(_index, 0)
        
        currentIndex = Int(_index)
        
        lastStoredOffset = offset
    }
}

//struct CustomCarousel_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView()
//    }
//}
