//
//  PlayViewModel.swift
//  netease-music-swiftui
//
//  Created by Allen long on 2022/12/23.
//

import Foundation
import Combine
import AVFoundation

class PlayViewModel: NSObject, ObservableObject {
    
    /// 是否正在播放
    @Published var isPlaying = false
    
    /// 播放进度
    @Published var playProgress: Double = 0
    
    /// 缓冲进度
    @Published var loadingProgress: Double = 0
    
    /// 当前播放时间的文本
    @Published var currentTimeString: String = "00:00"
    
    /// 总共播放时间的文本
    @Published var totalTimeString: String = "00:00"
    
    @Published var music = Music(name: "海阔天空", id: 347230, ar: Music.Author(name: "Beyond"), al: Music.Album(id: 11127, name: "海阔天空", picUrl: "https://gimg2.baidu.com/image_search/src=http%3A%2F%2Fhbimg.b0.upaiyun.com%2F7c09bbf54f9b8510b6ce6cd3e607c227773453fe6c084-vAnHp7_fw658&refer=http%3A%2F%2Fhbimg.b0.upaiyun.com&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=auto?sec=1674704017&t=8a49d50a33e6fd8e52e3c0dbe6d95484"))
    
    /// 播放器进度条是否被按住
    var progressIsPressing = false
    
    let playInfo = MusicPlayInfo(url: "https://m704.music.126.net/20221227182855/411e6fb15cc4cab56b6cbbefa5eb1ed8/jdymusic/obj/wo3DlMOGwrbDjj7DisKw/16160625029/3114/1623/5555/5d2a62fa9bf57d85d7279c63c6aa614d.mp3?_=000001855309e33e08310aaba050e6ee", time: 0)
    
    let playInfo1 = MusicPlayInfo(url: "https://m804.music.126.net/20221227182927/43f4c5c18220be0be37669d192a5f2b5/jdymusic/obj/wo3DlMOGwrbDjj7DisKw/11482710326/881e/f899/dce3/ec698e5372319da2a97bc388f5165642.mp3?_=00000185530a6187125a0aa46364259b", time: 0)
    
    /// 是否已准备好播放
    private var isPreparedToPlay = false
    
    private var player: AVPlayer!
    
    private var timeObserverToken: Any?
    
    private var playerItem: AVPlayerItem!
    /// 音乐播放完成后的操作类型
    private var completedType: MusicCompletedType = .next
    /// 音乐总时长
    private var musicDuration: Float64 = 0 {
        didSet {
            totalTimeString = Int(musicDuration).secondToMusicTimeString()
        }
    }
    
    // Key-value observing context
    private var playerItemContext = 0
    
    // 播放相关默认参数
    private let timeScale = CMTimeScale(NSEC_PER_SEC)
    
    private let timeInterval: CMTime = CMTime.init(value: 1, timescale: CMTimeScale(NSEC_PER_SEC))
    
    override init() {
        super.init()
        // TODO_Allen: 未加载好之前，有一个统一的UI
        prepareToPlay(playInfo: playInfo)
    }
    
    func didTapPlay() {
        if isPreparedToPlay {
            if isPlaying {
                player.pause()
            } else {
                player.play()
            }
            isPlaying.toggle()
        } else {
            // TODO_Allen:
            print("播放器未加载好")
        }
    }
    
    private func prepareToPlay(playInfo: MusicPlayInfo) {
        guard let url = URL(string: playInfo.url) else { return }
        playerItem = AVPlayerItem(url: url)
        
        playerItem.addObserver(self,
                               forKeyPath: loaddeTimeRangeKeyPath,
                               options: [.new],
                               context: &playerItemContext)
        playerItem.addObserver(self,
                               forKeyPath: #keyPath(AVPlayerItem.status),
                               options: [.new],
                               context: &playerItemContext)
        
        player = AVPlayer(playerItem: playerItem)
        timeObserverToken = player.addPeriodicTimeObserver(forInterval: timeInterval, queue: nil, using: { time in
            if self.progressIsPressing || !self.isPlaying { return }
            var progress: Double
            if self.musicDuration == 0 {
                progress = 0
            } else {
                progress = time.seconds / self.musicDuration
            }
            self.updatePlayProgress(progress)
        })
    }
    
    override func observeValue(forKeyPath keyPath: String?,
                               of object: Any?,
                               change: [NSKeyValueChangeKey : Any]?,
                               context: UnsafeMutableRawPointer?) {

        // Only handle observations for the playerItemContext
        guard context == &playerItemContext else {
            super.observeValue(forKeyPath: keyPath,
                               of: object,
                               change: change,
                               context: context)
            return
        }

        /// 观察音乐的缓冲进度
        if keyPath == loaddeTimeRangeKeyPath {
            let ranges = playerItem.loadedTimeRanges
            guard let timeRange = ranges.first?.timeRangeValue else { return }
            let durationsSeconds = CMTimeGetSeconds(timeRange.duration)
            if musicDuration > 0 {
                loadingProgress = durationsSeconds/musicDuration
            }
        }
        
        /// 观察音乐加载的的状态
        if keyPath == #keyPath(AVPlayerItem.status) {
            let status: AVPlayerItem.Status
            if let statusNumber = change?[.newKey] as? NSNumber {
                status = AVPlayerItem.Status(rawValue: statusNumber.intValue)!
            } else {
                status = .unknown
            }

            // Switch over status value
            switch status {
            case .readyToPlay:
                print("status readyToPlay")
                // Player item is ready to play.
                isPreparedToPlay = true
                musicDuration = CMTimeGetSeconds(self.playerItem.duration)
                print(self.playerItem.seekableTimeRanges)
                print(self.playerItem.loadedTimeRanges)
            case .failed:
                // Player item failed. See error.
                print("status failed")
            case .unknown:
                print("status unknown")
                // Player item is not yet ready.
            @unknown default:
                print("status unknown default")
            }
        }
    }
    
    /// 进度条和时间更新到某进度
    /// - Parameters:
    ///   - progress: 进度
    func updatePlayProgress(_ progress: Double) {
        var progress = progress
        
        if progress < 0 { progress = 0 }
        if progress >= 0.999 {
            if !progressIsPressing {
                playCompleted()
            } else {
                progress = 1
            }
        }
        // TODO_Allen: progress为1时，播放结束
//        print(progress)
        self.playProgress = progress
        self.currentTimeString = Int(progress * musicDuration).secondToMusicTimeString()
    }
    
    /// 播放到某进度
    func playAtProgress(_ progress: Double) {
        let time = CMTimeMakeWithSeconds(musicDuration * progress, preferredTimescale: timeScale)
        player.seek(to: time, toleranceBefore: .zero, toleranceAfter: .zero) { _ in
            self.progressIsPressing = false
        }
    }
    
    /// 播放完成
    func playCompleted() {
        switch completedType {
        case .cycle:
            playerItem.seek(to: .zero, toleranceBefore: .zero, toleranceAfter: .zero, completionHandler: nil)
        case .next:
            // TODO_Allen: 播放下一首
            isPreparedToPlay = false
            isPlaying = false
            
            // FIXME_Allen:  这里移除监听后，依然得到了上一首歌的一次响应
            if let token = timeObserverToken {
                player.removeTimeObserver(token)
            }
            
            // FIXME_Allen:  进度更新为0后，进度条依然显示在结束位置
            updatePlayProgress(0)
            prepareToPlay(playInfo: playInfo1)
        case .pause:
            isPlaying = false
            playerItem.seek(to: .zero, toleranceBefore: .zero, toleranceAfter: .zero) { _ in
                self.player.pause()
            }
        }
    }
    // 加载本地的歌曲
//    func loadLocalSong() {
//        let songPath = Bundle.main.path(forResource: "song", ofType: "mp3")!
//        print(songPath)
//        let url = URL(fileURLWithPath: songPath)
//    }
    
}

// TODO_Allen: 本页面的各种监听，在切换音乐，或关闭本页面时，是否需要释放

fileprivate let loaddeTimeRangeKeyPath = "loadedTimeRanges"

// TODO_Allen: AVPlayer播放远端音乐；AVAudioPlayer播放本地音乐

