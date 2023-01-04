//
//  CardContentView.swift
//  Try
//
//  Created by 이민지 on 2023/01/04.
//

import SwiftUI

struct CardContentView: View {
    @StateObject var mainViewModel = MainHomeViewModel()
    
    var body: some View {
        VStack(spacing: 0) {
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
    }
}
