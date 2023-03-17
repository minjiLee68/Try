//
//  CustomCarousel_new.swift
//  JointGoal_SwiftUI
//
//  Created by 이민지 on 2022/10/20.
//

import SwiftUI

struct CustomCarousel_new<Content: View,Item>: View where Item: RandomAccessCollection, Item.Element: Hashable {
    
    var content: (Item.Element, CGSize) -> Content
    
    // MARK: View Properties
    var spacing: CGFloat
    var cardPadding: CGFloat
    var items: Item
    
    @Binding var index: Int
    
    init(
        index: Binding<Int>,
        items: Item,
        spacing: CGFloat = 30,
        cardPadding: CGFloat = 80,
        @ViewBuilder content: @escaping (Item.Element, CGSize) -> Content
    ) {
        self.content = content
        self._index = index
        self.spacing = spacing
        self.cardPadding = cardPadding
        self.items = items
    }
    
    @GestureState var translation: CGFloat = 0
    @State var offset: CGFloat = 0
    @State var lastStoredOffset: CGFloat = 0
    
    @State var currentIndex: Int = 0
    // MARK: Rotation
    @State var rotation: Double = 0
    
    var body: some View {
        GeometryReader { proxy in
            let size = proxy.size
            // MARK: card 간격 및 padding 적용 후 감소
            let cardWidth = size.width - (cardPadding - spacing)
            
            // 메모리 효율성
            LazyHStack(spacing: spacing) {
                ForEach(items, id: \.self) { contents in
                    let index = indexOf(item: contents)
                    content(contents, CGSize(width: size.width - cardPadding, height: size.height))
                    // MARK: 각 뷰의 인덱스와 5도 곱하기 회전
                    // 그리고 스크롤할 때 0으로 설정하면 좋은 원형 각성 효과를 줄 수 있음.
                        .rotationEffect(.init(degrees: Double(index) * 5), anchor: .bottom)
                        .rotationEffect(.init(degrees: rotation), anchor: .bottom)
                    // MARK: 회전 후 매끄러운 효과
                        .offset(y: offsetY(index: index, cardWidth: cardWidth))
                        .frame(width: size.width - cardPadding, height: size.height)
                        .contentShape(Rectangle())
                    
                    let _ = print("customCard \(index), \(rotation), \(offsetY(index: index, cardWidth: cardWidth))")
                }
            }
            .padding(.horizontal, spacing)
            .offset(x: limitScroll())
            .contentShape(Rectangle())
            .gesture(
                DragGesture(minimumDistance: 5)
                    .updating($translation, body: { value, out, _ in
                        out = value.translation.width
                    })
                    .onChanged( {onChange(value: $0, cardWidth: cardWidth)} )
                    .onEnded( {onEnd(value: $0, cardWidth: cardWidth)} )
            )
        }
        .padding(.top, 50)
        .onAppear {
            let extraSpace = (cardPadding / 3) - spacing
            offset = extraSpace
            lastStoredOffset = extraSpace
            rotation = 0.0
        }
        .animation(.easeInOut, value: translation == 0)
    }
    
    // MARK: Current Item Up
    func offsetY(index: Int, cardWidth: CGFloat) -> CGFloat {
        // MARK: 전체 오프셋이 아닌 현재를 변환.
        // 현재 데이터를 보유하기 위해 @GestureState를 사용
        let progress = ((translation < 0 ? translation : -translation) / cardWidth) * 60
        let yOffset = -progress < 60 ? progress : -(progress + 120)
        
        let previous = (index - 1) == self.index ? (translation < 0 ? yOffset : -yOffset) : 0
        let next = (index + 1) == self.index ? (translation < 0 ? -yOffset : yOffset) : 0
        let In_Between = (index - 1) == self.index ? previous : next
        
        return index == self.index ? -60 - yOffset : In_Between
    }
    
    // MARK: 첫번쨰, 마지막 항목의 스크롤 제한
    func limitScroll() -> CGFloat {
        let extraSpace = (cardPadding / 2) - spacing
        if index == 0 && offset > 0 {
            return extraSpace + (offset / 4)
        } else if index == items.count - 1 && translation < 0 {
            return offset - (translation / 2)
        } else {
            return offset
        }
    }
    
    // MARK: Item Index
    func indexOf(item: Item.Element) -> Int {
        let array = Array(items)
        if let index = array.firstIndex(of: item) {
            return index
        }
        return 0
    }
    
    func onChange(value: DragGesture.Value, cardWidth: CGFloat) {
        let translationX = value.translation.width
        offset = translationX + lastStoredOffset
        
        // MARK: 회전 계산
        let progress = offset / cardWidth
        rotation = progress * 5
    }
    
    func onEnd(value: DragGesture.Value, cardWidth: CGFloat) {
        // MARK: 현재 인덱스 찾기
        var _index = (offset / cardWidth).rounded()
        _index = max(-CGFloat(items.count - 1), _index)
        _index = min(_index, 0)
        
        currentIndex = Int(_index)
        // MARK: Updating Index
        // 우측으로 이동 - > 모든 데이터가 음수가 된다.
        index = -currentIndex
        withAnimation(.easeInOut(duration: 0.25)) {
            // 왜 /2 -> 양쪽이 모두 보여야 하기 때문
            let extraSpace = (cardPadding / 2) - spacing
            offset = (cardWidth * _index) + extraSpace
            
            let progress = offset / cardWidth
            rotation = (progress * 5).rounded() - 1
        }
        
        lastStoredOffset = offset
    }
}
