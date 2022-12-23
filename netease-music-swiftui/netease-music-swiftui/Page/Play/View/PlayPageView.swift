//
//  PlayPageView.swift
//  netease-music-swiftui
//
//  Created by longfan on 2022/12/22.
//

import SwiftUI
import Combine
import Alamofire
import Kingfisher

struct PlayPageView: View {
    
    @ObservedObject var vm = PlayViewModel()
    
    @State var rotationDegrees: Double = 0
    
    var body: some View {
            ZStack(alignment: .center) {
                // 封面
                // FIXME_Allen:  宽高*1.2后，会造成ZStack大于屏幕，思考如果使图像放大，但不改变frame，考虑使用.transition方法
                KFImage.url(URL(string: vm.music.al.picUrl))
                    .resizing(referenceSize: CGSize(width: kScreenW * 1.2, height: kScreenH * 1.2), mode: .aspectFill)
                    .blur(radius: 50)

                VStack(spacing: 0) {
                    // 导航栏
                    HStack {
                        Image("play_close")
                            .resize(length: 35)
                        Spacer()
                        VStack {
                            Text(vm.music.name)
                                .font(.system(size: 18))
                                .foregroundColor(.white)
                            Text(vm.music.ar.name)
                                .font(.system(size: 15))
                                .foregroundColor(.white)
                                .opacity(0.5)
                        }
                        Spacer()
                        Image("play_share")
                            .resize(length: 35)
                    }
                    .frame(height: 44)
                    .padding(.top, statusBarH)
                    .padding(.horizontal, 20)
                    // 唱片模块
                    ZStack(alignment: .top) {
                        // 唱片
                        ZStack() {
                            Image("play_disc")
                                .resize(length: discWidth)
                            KFImage(URL(string: vm.music.al.picUrl))
                                .resizing(referenceSize: CGSize(width: discWidth - discThickness * 2, height: discWidth - discThickness * 2))
                                .cornerRadius((discWidth - discThickness * 2)/2.0)
                        }
                        .padding(.top, 120)
                        // 唱片杆儿
                        Image("play_needle")
                            .resize(width: 122, height: 180)
                        // (44,37)为唱片杆儿的圆形部分
                            .rotationEffect(Angle(degrees: rotationDegrees), anchor: UnitPoint(x: 44/273.0, y: 37/402.0))
                            .padding(.top, 15)
                            .padding(.leading, adapter(85))
                                            
                    }
                    Spacer()
                    // 控制台
                    VStack {
                        // 点赞、下载、评论
                        HStack {
                            Image("play_like")
                            Spacer()
                            Image("play_download")
                            Spacer()
                            Image("play_comment")
                        }.frame(width: kScreenW - 40)
                        // 进度条
                        HStack {
                            Text("00:00")
                                .opacity(0.7)
                                .font(Font.system(size: 10))
                                .foregroundColor(.white)
                            ZStack(alignment: .leading) {
                                Color.white
                                    .opacity(0.3)
                                    .frame(width: kScreenW - 100,height: 2)
                                    .cornerRadius(1)
                                Color.white
                                    .frame(width: 8, height: 8)
                                    .cornerRadius(4)
                            }
                            Text("00:00")
                                .opacity(0.7)
                                .font(Font.system(size: 10))
                                .foregroundColor(.white)
                        }
                        .padding(.vertical, 30)
                        // 播放控制
                        HStack {
                            Image("play_previous")
                                .resize(length: 40)
                            Image(vm.isPlaying ? "play_pause" : "play_play")
                                .resize(length: 75)
                                .onTapGesture {
                                    vm.isPlaying.toggle()
                                    withAnimation(.linear(duration: 0.3)) {
                                        rotationDegrees = vm.isPlaying ? -30 : 0
                                    }
                                    vm.play()
//                                    loadSong()
                                }                            
                            Image("play_next")
                                .resize(length: 40)
                        }
                    }
                    .padding(.bottom, 30)
                }
                .padding(.horizontal, kScreenW * 0.1)
                .padding(.vertical, kScreenH * 0.1)
                .padding(.top, -8)
            }.ignoresSafeArea()
    }
    
    
    func loadSong() {
        let url = "http://localhost:3000/song/download/url?id=347230"

//        let destination: DownloadRequest.Destination = { _, _ in
//            let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
//            let fileURL = documentsURL.appendingPathComponent("song.mp3")
//
//            return (fileURL, [.removePreviousFile, .createIntermediateDirectories])
//        }
//
//        AF.download(url, to: destination).response { response in
//            debugPrint(response)
//            debugPrint(response.fileURL)
//        }
        AF.request(url).response { response in
            debugPrint(response)
        }
    }
}

struct PlayPageView_Previews: PreviewProvider {
    static var previews: some View {
        PlayPageView()
    }
}

fileprivate let discWidth: CGFloat = kScreenW - 80
fileprivate let discThickness: CGFloat = 40

