//
//  View+Extension.swift
//  netease-music-swiftui
//
//  Created by longfan on 2022/12/18.
//

import Foundation
import SwiftUI

extension View {
    
    // 为Textfield添加占位文本
    func placeholder(when shouldShow: Bool, text: String, font: Font, color: Color = Color(Color_F2F6F8)) -> some View {
        ZStack(alignment: .leading) {
            Text(text)
                .font(font)
                .foregroundColor(color)
                .opacity(shouldShow ? 1 : 0)
            self
        }
    }
    
    // 为View添加边框
    public func addBorder<S>(_ content: S, width: CGFloat = 1, cornerRadius: CGFloat) -> some View where S : ShapeStyle {
             let roundedRect = RoundedRectangle(cornerRadius: cornerRadius)
             return clipShape(roundedRect)
                  .overlay(roundedRect.strokeBorder(content, lineWidth: width))
    }
    
    // 设置宽高相等的边长
    func sideLength(_ length: CGFloat) -> some View {
        return self.frame(width: length, height: length)
    }
    
}
