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
import ExytePopupView

struct PlayPageView: View {
    
    @ObservedObject var vm = PlayViewModel()
    
    /// 播放杆儿的倾斜角度
    @State private var rotationDegrees: Double = -30
    
    /// 进度条的偏移量
    @State private var progressOffsetWidth: CGFloat = 0
    
    /// 圆盘的目标角度
    @State private var desiredAngle: CGFloat = 0.0
      
    /// 圆盘的当前角度
    @State private var currentAngle: CGFloat = 0.0
    
    /// 进度条上的手势
    var progressGesture: some Gesture {
        let longPress = LongPressGesture(minimumDuration: 0.01)
            .onChanged({ isOn in
                vm.progressIsPressing = true
            })
        let drag = DragGesture()
            .onChanged({ dragValue in
                let progress = dragValue.location.x/progressWidth
                vm.updateAtProgress(progress)
            })
            .onEnded({ dragValue in
                let progress = dragValue.location.x/progressWidth
                vm.dragToPlayAtProgress(progress)
            })
        
        let combine = longPress.sequenced(before: drag)
        return combine
    }
    
    /// 圆盘动画
    var discAnimation: Animation {
        Animation.linear(duration: 15)
            .repeatForever(autoreverses: false)
    }
    
    var body: some View {
        ZStack(alignment: .center) {
                // 封面
                KFImage.url(URL(string: vm.music.albumPicUrl))
                .resizing(referenceSize: CGSize(width: kScreenW, height: kScreenH), mode: .aspectFill)
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
                            Text(vm.music.authorName)
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
                        // 圆盘
                        ZStack {
                            Color.white
                                .opacity(0.15)
                                .sideLength(discWidth + 20)
                                .cornerRadius((discWidth + 20)/2)
                            ZStack {
                                Image("play_disc")
                                    .resize(length: discWidth)
                                KFImage(URL(string: vm.music.albumPicUrl))
                                    .resizing(referenceSize: CGSize(width: discWidth - discThickness * 2, height: discWidth - discThickness * 2))
                                    .cornerRadius((discWidth - discThickness * 2)/2.0)
                            }
                            .modifier(PausableRotation(desiredAngle: desiredAngle, currentAngle: $currentAngle))
                        }
                        .padding(.top, 120)
                        // 杆儿
                        Image("play_needle")
                            .resize(width: 122, height: 180)
                        // (44,37)为杆儿的圆形的中心
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
                                .onTapGesture {
                                    vm.tapDownload()
                                }
                            Spacer()
                            Image("play_comment")
                        }.frame(width: kScreenW - 40)
                        // 进度条
                        ZStack {
                            HStack() {
                                Text(vm.currentTimeString)
                                    .opacity(0.7)
                                    .font(Font.system(size: 10))
                                    .foregroundColor(.white)
                                    .frame(width: 50)
                                Spacer()
                                Text(vm.totalTimeString)
                                    .opacity(0.7)
                                    .font(Font.system(size: 10))
                                    .foregroundColor(.white)
                                    .frame(width: 50)
                            }
                            .frame(width: kScreenW)
                            
                            ZStack(alignment: .leading) {
                                ZStack(alignment: .leading) {
                                    Color.white
                                        .opacity(0.3)
                                        .frame(width: progressWidth,height: 2)
                                        .cornerRadius(1)
                                    Color.white
                                        .opacity(0.6)
                                        .frame(width: progressWidth * vm.loadingProgress,height: 2)
                                        .cornerRadius(1)
                                }
                                
                                ZStack(alignment: .center) {
                                    Color.white
                                        .opacity(0.0001)
                                        .frame(width: progressButtonWidth, height: progressButtonWidth)
                                    Color.white.frame(width: 8, height: 8)
                                        .cornerRadius(4)
                                }
                                .padding(.leading, -progressButtonWidth/2)
                                .offset(CGSize(width: progressWidth * vm.playProgress, height: 0))
                                .gesture(progressGesture)
                            }
                        }
                        .padding(.vertical, 30)
                        
                        // 播放控制
                        HStack {
                            Image("play_previous")
                                .resize(length: 40)
                            Image(vm.isPlaying ? "play_play" : "play_pause")
                                .resize(length: 75)
                                .onTapGesture {
                                    vm.didTapPlay()
                                }
                                .onReceive(vm.$isPlaying) { isPlaying in
                                    // 杆儿动画
                                    withAnimation(.linear(duration: 0.3)) {
                                        rotationDegrees = isPlaying ? 0 : -30
                                    }
                                    // 圆盘动画
                                    let startAngle = currentAngle.truncatingRemainder(dividingBy: CGFloat.pi * 2)
                                    let angleDelta = isPlaying ? CGFloat.pi * 2 : 0.0
                                    withAnimation(isPlaying ? discAnimation : .linear(duration: 0)) {
                                        self.desiredAngle = startAngle + angleDelta
                                    }
                                }
                            Image("play_next")
                                .resize(length: 40)
                        }
                    }
                    .padding(.bottom, 30)
                }
            }
            .popup(isPresented: $vm.isStartDownloading) {
                FloatView(text: "已加入下载列表。")
            } customize: {
                $0
                    .type(.floater())
                    .position(.top)
                    .animation(.spring())
                    .dismissSourceCallback {_ in
                        vm.isStartDownloading = false
                    }
                    .autohideIn(2)
            }
            .ignoresSafeArea()


            

    }
    
}

struct PlayPageView_Previews: PreviewProvider {
    static var previews: some View {
        PlayPageView()
    }
}

fileprivate let discWidth: CGFloat = kScreenW - 100
fileprivate let discThickness: CGFloat = 40
fileprivate let progressWidth: CGFloat = kScreenW - 100
fileprivate let progressButtonWidth: CGFloat = 50
