//
//  DetailCardView.swift
//  Try
//
//  Created by 이민지 on 2022/12/31.
//

import SwiftUI

struct DetailCardView: View {
    @Environment(\.dismiss) var dismiss
    @State var goalContent: Contents
    @State var isShowContent = false
    
    @Binding var isTab: Bool
    
    var animation: Namespace.ID
    
    var body: some View {
        VStack(spacing: 20) {
            Button {
                withAnimation(.easeOut(duration: 0.35)) {
                    isTab = false
                }
            } label: {
                Text("닫기")
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.leading, 20)
            
            detailContents
            
            Spacer()
        }
        .background(.black)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
    }
    
    var detailContents: some View {
        VStack(spacing: 0) {
            topTitle
            
            VStack(spacing: 15) {
                HStack(alignment: .center, spacing: 0) {
                    Text("안녕하세요")
                        .foregroundColor(.white)
                }
                HStack(alignment: .center, spacing: 0) {
                    Text("안녕하세요")
                        .foregroundColor(.white)
                }
                HStack(alignment: .center, spacing: 0) {
                    Text("안녕하세요")
                        .foregroundColor(.white)
                }
            }
            .frame(maxHeight: .infinity, alignment: .center)
        }
        .matchedGeometryEffect(id: goalContent.id, in: animation)
        .transition(.asymmetric(insertion: .identity, removal: .offset(y:0.5)))
    }
    
    var topTitle: some View {
        HStack(spacing: 0) {
            Text("이민지")
                .foregroundColor(.white)
                .font(.title2)
            
            Spacer()
            
            Text("아무개")
                .foregroundColor(.white)
                .font(.title2)
        }
        .padding(.horizontal, 20)
        .padding(.top, 30)
    }
}
