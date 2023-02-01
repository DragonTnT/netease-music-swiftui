//
//  PlayViewModel.swift
//  netease-music-swiftui
//
//  Created by Allen long on 2022/12/23.
//

import Foundation
import Combine
import AVFoundation
import Alamofire
import WCDBSwift

class PlayViewModel: NSObject, ObservableObject {
    
    /// 是否正在播放
    @Published var isPlaying = false
    
    /// 是否已开始下载
    @Published var isStartDownloading = false
    
    /// 播放进度
    @Published var playProgress: Double = 0
    
    /// 缓冲进度
    @Published var loadingProgress: Double = 0
    
    /// 当前播放时间的文本
    @Published var currentTimeString: String = "00:00"
    
    /// 总共播放时间的文本
    @Published var totalTimeString: String = "00:00"
    
    @Published var music = Music()
    
    /// 播放器进度条是否被按住
    var progressIsPressing = false
    
    
    
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
        let music = Music(name: "海阔天空",
                             id: 347230,
                             authorName: "Beyond",
                                            albumPicUrl: "https://gimg2.baidu.com/image_search/src=http%3A%2F%2Fhbimg.b0.upaiyun.com%2F7c09bbf54f9b8510b6ce6cd3e607c227773453fe6c084-vAnHp7_fw658&refer=http%3A%2F%2Fhbimg.b0.upaiyun.com&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=auto?sec=1674704017&t=8a49d50a33e6fd8e52e3c0dbe6d95484",
                                            playUrl: "https://vkceyugu.cdn.bspapp.com/VKCEYUGU-76e6f208-1db3-413f-88bc-80e5e2ac3283/cded1a8b-79d8-43ac-84f2-3945b62815ae.mp3")
        
        prepareToPlay(music: music)
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
    
    private func prepareToPlay(music: Music) {
        self.music = music
        guard let url = URL(string: music.playUrl) else { return }
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
            self.updateAtProgress(progress)
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
    func updateAtProgress(_ progress: Double) {
        var progress = progress
        if progress < 0 { progress = 0 }
        if progress >= 0.999 {
            if !progressIsPressing {
                playCompleted()
                return
            } else {
                progress = 1
            }
        }
        self.playProgress = progress
        self.currentTimeString = Int(progress * musicDuration).secondToMusicTimeString()
    }
    
    /// 拖动进度条到某一进度播放
    func dragToPlayAtProgress(_ progress: Double) {
        if progress >= 1 {
            playCompleted()
            return
        }
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
            updateAtProgress(0)
            prepareToPlay(music: music2)
        case .pause:
            isPlaying = false
            playerItem.seek(to: .zero, toleranceBefore: .zero, toleranceAfter: .zero) { _ in
                self.player.pause()
            }
        }
    }
    
    func tapDownload() {
        if music.isDownloaded {
            
        } else {
            isStartDownloading = true

            AF.download(music.playUrl).responseData { resp in
                guard let data = resp.value else {
                    debugPrint("下载失败")
                    return
                }
                self.music.data = data
                self.saveMusicToDataBase(music: self.music)
            }
        }
    }
    
    func playPrevious() {
        
    }
    
    func playNext() {
        
    }
    
    func saveMusicToDataBase(music: Music) {
        print(DatabaseHelper.dataBasePath)
        let database = Database(withPath: DatabaseHelper.dataBasePath)
        
        do {
            try database.create(table: DatabaseHelper.musicTableName, of: Music.self)
            try database.insertOrReplace(objects: [music], intoTable: DatabaseHelper.musicTableName)
        } catch let error {
            print(error)
        }
    }
    
    func deleteMusicFromDisk(music: Music) {
        let database = Database(withPath: DatabaseHelper.dataBasePath)
        do {
            try database.delete(fromTable: DatabaseHelper.musicTableName, where: Music.Properties.id == music.id)
        } catch let error {
            print(error)
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

fileprivate let music1 = Music(name: "海阔天空",
                                  id: 347230,
                                  authorName: "Beyond",
                                                 albumPicUrl: "https://gimg2.baidu.com/image_search/src=http%3A%2F%2Fhbimg.b0.upaiyun.com%2F7c09bbf54f9b8510b6ce6cd3e607c227773453fe6c084-vAnHp7_fw658&refer=http%3A%2F%2Fhbimg.b0.upaiyun.com&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=auto?sec=1674704017&t=8a49d50a33e6fd8e52e3c0dbe6d95484",
                                                 playUrl: "https://vkceyugu.cdn.bspapp.com/VKCEYUGU-76e6f208-1db3-413f-88bc-80e5e2ac3283/cded1a8b-79d8-43ac-84f2-3945b62815ae.mp3")

fileprivate let music2 = Music(name: "嘻唰唰",
                                  id: 347230,
                                  authorName: "大张伟",
                                                 albumPicUrl: "https://img0.baidu.com/it/u=441345829,3922263681&fm=253&fmt=auto&app=138&f=JPEG?w=500&h=500",
                                                 playUrl: "https://vkceyugu.cdn.bspapp.com/VKCEYUGU-76e6f208-1db3-413f-88bc-80e5e2ac3283/f7b5e052-9f56-48b0-aebb-19a3d2b58d56.mp3")

