//
//  WebImageView.swift
//  Try
//
//  Created by 이민지 on 2022/12/28.
//

import Foundation
import SwiftUI
import CachedAsyncImage

struct WebImageView: View {
    
    @State var url: String
    @State var radius: CGFloat = 0
    @State var contentMode: ContentMode = .fill
    @State var alignment: Alignment = .center
    @State var width: CGFloat = -1
    @State var height: CGFloat = -1
    
    var body: some View {
                
        if #available(iOS 15.0, *) {
            CachedAsyncImage(url: URL(string: url), urlCache: .imageCache, transaction: Transaction(animation: .easeInOut)) { phase in
                switch phase {
                case .empty:
                    ProgressView()
                case .success(let image):
                    image
                       .resizable()
                       .aspectRatio(contentMode: contentMode)
                      
                case .failure:
                    ProgressView()
                @unknown default:
                    EmptyView()
                }
            }
            .frame(width: width == -1 ? .infinity : width, height: height == -1 ? .infinity : height, alignment: alignment)
            .cornerRadius(radius)
        }  else {
            ImageView(withURL: url, width: width, height: height, radius: radius)
        }
    }
}

extension URLCache {
    static let imageCache = URLCache(memoryCapacity: 512*1000*1000, diskCapacity: 10*1000*1000*1000)
}
