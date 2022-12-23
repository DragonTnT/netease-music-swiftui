//
//  Image+Extension.swift
//  netease-music-swiftui
//
//  Created by Allen long on 2022/12/23.
//

import Foundation
import SwiftUI

extension Image {
    
    // 图片重新设置等宽的边长
    func resize(length: CGFloat) -> some View {
        return self.resizable()
            .scaledToFill()
            .frame(width: length, height: length)
    }
    
    // 图片重新设置宽高
    func resize(width: CGFloat, height: CGFloat) -> some View {
        return self.resizable()
            .scaledToFill()
            .frame(width: width, height: height)
    }
}
