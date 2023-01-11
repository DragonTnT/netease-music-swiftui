//
//  demoUI.swift
//  netease-music-swiftui
//
//  Created by Allen long on 2023/1/10.
//

import SwiftUI
import ExytePopupView

struct demoUI: View {
    @State var isStartDownloading = false
    
    var body: some View {
        ZStack() {
            Color.blue
                .frame(width: kScreenW, height: kScreenH)
            VStack {
                Text("adasd")
                    .onTapGesture {
                        isStartDownloading = true
                    }
//                Spacer()
            }
        }
        
        
        .popup(isPresented: $isStartDownloading) {
            FloatView(text: "已加入下载列表。")
        } customize: {
            $0
                .type(.floater())
                .position(.top)
                .animation(.spring())
                .autohideIn(2)
        }
        
        .ignoresSafeArea()
        
        

    }
}

struct demoUI_Previews: PreviewProvider {
    static var previews: some View {
        demoUI()
    }
}
