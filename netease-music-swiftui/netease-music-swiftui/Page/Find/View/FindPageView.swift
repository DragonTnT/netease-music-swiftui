//
//  FindPageView.swift
//  netease-music-swiftui
//
//  Created by longfan on 2022/12/18.
//

import SwiftUI

struct Item: Identifiable {
    let id = UUID()
    let image: Image
}

let roles = ["Luffy", "Nami","Luffy", "Nami",]
let navigationResource: [(title: String, logo: String)] = [
    (title: "每日推荐", logo: "home_recommend"),
    (title: "私人FM", logo: "home_fm"),
    (title: "歌单", logo: "home_playlist"),
    (title: "排行榜", logo: "home_board"),
    (title: "一歌一遇", logo: "home_meet"),
    (title: "数字专辑", logo: "home_recommend"),
    (title: "有声书", logo: "home_fm"),
]

let findDefaultPadding: CGFloat = 15


struct FindPageView: View {
    
    let items: [Item] = roles.map { Item(image: Image($0)) }
    
    var body: some View {
        VStack(spacing: findDefaultPadding) {
            FindNavView()
            
            ACarousel(items, spacing: 10, headspace: -10, sidesScaling: 1, isWrap: true, autoScroll: .active(3)) { item in
                        item.image
                            .resizable()
                            .scaledToFill()
                            .frame(height: 170)
                            .cornerRadius(10)
                    }
                    .frame(height: 160)
                    .padding(.horizontal, findDefaultPadding)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(alignment: .top, spacing: 35) {
                    ForEach(navigationResource,  id: \.self.title) { source in
                        VStack {
                            Image(source.logo)
                                .resizable()
                                .frame(width: 35, height: 35)
                            Text(source.title)
                                .font(.system(size: 12))
                                .foregroundColor(grayTextColor)
                        }
                        .frame(width: (kScreenW - 2 * findDefaultPadding - 35 * 4)/5.0)
                        
                    }
                }
                .padding(.horizontal, findDefaultPadding)
            }
            
            FindSectionView(title: "推荐歌单") {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 10) {
                        ForEach(roles,  id: \.self) { source in
                            VStack(spacing: 5) {
                                Image(source)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 160, height: 160)
                                    .cornerRadius(6)
                                Text("1000首华语乐坛神仙打架8090后经典曲目")
                                    .font(.system(size: 13))
                                    .frame(width: 160, height: 40)
                            }
                            
                        }
                    }
                    .padding(.horizontal, findDefaultPadding)
                }
            }
            
            
            

            
            Spacer()
        }
    }
}

struct FindPageView_Previews: PreviewProvider {
    static var previews: some View {
        FindPageView()
    }
}
