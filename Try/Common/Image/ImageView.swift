//
//  ImageView.swift
//  Try
//
//  Created by 이민지 on 2022/12/28.
//

import Foundation
import SwiftUI

struct ImageView: View {
    
    @ObservedObject var imageLoader: ImageLoader

    @State var image: UIImage = UIImage()
    @State var widthValue: CGFloat
    @State var heightValue: CGFloat
    @State var radiusValue: CGFloat

    init(withURL url:String, width: CGFloat, height: CGFloat, radius: CGFloat) {
        
        imageLoader = ImageLoader(urlString:url)
        widthValue = width
        heightValue = height
        radiusValue = radius
    }

    var body: some View {
            Image(uiImage: image)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: widthValue, height: heightValue)
                .cornerRadius(radiusValue)
                .onReceive(imageLoader.didChange) { data in
                self.image = UIImage(data: data) ?? UIImage()
        }
    }
}
