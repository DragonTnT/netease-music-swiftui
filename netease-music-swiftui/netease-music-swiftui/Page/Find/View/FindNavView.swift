//
//  FindNavView.swift
//  netease-music-swiftui
//
//  Created by longfan on 2022/12/18.
//

import SwiftUI

struct FindNavView: View {
    
    @State private var searchContent = ""
    
    var body: some View {
        HStack(spacing: 10) {
            Button {
                
            } label: {
                Image("home_category")
                    .resizable()
                    .frame(width: 33, height: 33)
            }
            
            HSStack(spacing: 0) {
                Image("common_search")
                TextField("",  text: $searchContent)
                    .frame(height: adapter(33))
                    .font(Font.system(size: 14))
                    .placeholder(when: searchContent.isEmpty, text: "搜索歌曲", font: Font.system(size: 14), color: Color(Color_9096AB))
            }
            .addBorder(Color(Color_EBF1F3), width: 1, cornerRadius: 16.5)
            
            
            Button {
                
            } label: {
                Image("home_vip")
                    .resizable()
                    .frame(width: 33, height: 33)
            }
            
            Button {
                
            } label: {
                Image("home_mic")
                    .resizable()
                    .frame(width: 33, height: 33)
            }
        }
        .padding(.horizontal, 10)
        .frame(height: navigationBarH)
    }
}

struct FindNavView_Previews: PreviewProvider {
    static var previews: some View {
        FindNavView().previewLayout(PreviewLayout.fixed(width: kScreenW, height: 44))
    }
}
