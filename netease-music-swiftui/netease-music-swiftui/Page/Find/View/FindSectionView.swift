//
//  FindSectionView.swift
//  netease-music-swiftui
//
//  Created by longfan on 2022/12/18.
//

import SwiftUI

struct FindSectionView<Content>: View where Content: View {
    
    let title: String
    
    let content: Content
    
    init(title: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.content = content()
    }
    
    var body: some View {
        VStack {
            HSStack(spacing: 0) {
                Text(title)
                    .font(.system(size: 18, weight: .medium))
                    .padding(.leading, findDefaultPadding)
                Spacer()
            }
            .padding(.top, 10)
//            .frame(height: 50)
            
            content
            
            Rectangle()
                .fill(Color(Color_EBF1F3))
                .frame(height: 1)
        }
        
    }
}

//struct FindSectionView_Previews: PreviewProvider {
//    static var previews: some View {
//        FindSectionView(title: "推荐歌单").previewLayout(PreviewLayout.fixed(width: 414, height: 50))
//    }
//}
