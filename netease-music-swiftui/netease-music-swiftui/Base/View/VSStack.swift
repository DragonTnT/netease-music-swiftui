//
//  VSStack.swift
//  youchelai_swiftui
//
//  Created by longfan on 2022/12/11.
//

import SwiftUI

/// 默认spacing为0的VStack
struct VSStack<Content>: View where Content: View {
    private var content: Content
    private var alignment: HorizontalAlignment
    private var spacing: CGFloat
    
    init(_ alignment: HorizontalAlignment = .center, spacing: CGFloat = 0, @ViewBuilder content: () -> Content) {
        self.alignment = alignment
        self.spacing = spacing
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: alignment, spacing: spacing) {
            content
        }
    }
}

/// 默认spacing为0的HStack
struct HSStack<Content>: View where Content: View {
    private var content: Content
    private var alignment: VerticalAlignment
    private var spacing: CGFloat
    
    init(_ alignment: VerticalAlignment = .center, spacing: CGFloat = 0, @ViewBuilder content: () -> Content) {
        self.alignment = alignment
        self.spacing = spacing
        self.content = content()
    }
    
    var body: some View {
        HStack(alignment: alignment, spacing: spacing) {
            content
        }
    }
}
