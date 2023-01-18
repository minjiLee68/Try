//
//  NavigationCustomBar.swift
//  Try
//
//  Created by 이민지 on 2022/12/28.
//

import SwiftUI

struct NavigationCustomBar: View {
    @Environment(\.dismiss) private var dismiss
    @State var naviType: NaviType
    @Binding var isButton: Bool
    
    var body: some View {
        HStack(alignment: .center, spacing: 0) {
            switch naviType {
            case .profileSetting:
                naviContents(title: "프로필 설정")
            case .detail:
                naviContents(leadingBtn: "취소")
            case .mypage:
                naviContents(leadingBtn: "취소")
            case .profileEditor:
                naviContents(leadingBtn: "취소", title: "프로필 변경")
            }
        }
        .padding(.vertical, 20)
        .frame(width: device.screenWidth)
        .background(Color.clear)
        .navigationBarHidden(true)
    }
    
    @ViewBuilder
    func naviContents(leadingBtn: String = "", title: String = "", trailingBtn: String = "") -> some View {
        HStack(spacing: 0) {
            Button {
                if naviType == .detail {
                    withAnimation(.easeOut(duration: 0.35)) {
                        isButton = false
                    }
                } else {
                    dismiss()
                }
            } label: {
                Text(leadingBtn)
            }
            
            Spacer()
            
            Text(title)
                .foregroundColor(.white)
                .fontWeight(.bold)
            
            Spacer()
            
            Button {
                
            } label: {
                Text(trailingBtn)
            }
        }
        .padding(.horizontal, 20)
    }
    
    @ViewBuilder
    func naviImageBar(image: String) -> some View {
        HStack(spacing: 0) {
            Image(image)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}
