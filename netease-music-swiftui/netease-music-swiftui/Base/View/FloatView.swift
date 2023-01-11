//
//  FloatView.swift
//  netease-music-swiftui
//
//  Created by Allen long on 2023/1/10.
//

import SwiftUI

struct FloatView: View {
    
    init(text: String, isFullScreen: Bool = true) {
        self.text = text
        self.isFullScreen = isFullScreen
    }
    
    let text: String
    
    let isFullScreen: Bool
    
    var body: some View {
        ZStack {
            Text(text)
                .padding(.all, 20)
                .frame(width: kScreenW - 100)
        }
        .background(Color.white)
        .cornerRadius(20)
        .shadow(color: Color.black.opacity(0.15), radius: 5)
        .padding(.top, isFullScreen ? statusBarH : 0)
    }
}

struct FloatView_Previews: PreviewProvider {
    static var previews: some View {
        FloatView(text: "this is a float!")
    }
}
