//
//  PlayViewModel.swift
//  netease-music-swiftui
//
//  Created by Allen long on 2022/12/23.
//

import Foundation
import Combine
import AVFoundation

class PlayViewModel: ObservableObject {
    
    @Published var isPlaying = false
    
    @Published var music = Music(name: "海阔天空", id: 347230, ar: Music.Author(name: "Beyond"), al: Music.Album(id: 11127, name: "海阔天空", picUrl: "https://p2.music.126.net/8y8KJC1eCSO_vUKf2MyZwA==/109951165796899183.jpg"))
    
    let musicUrl = "https://m702.music.126.net/20221223160851/71ba1c4c5b4f1490d28a90cc497c9b93/jd-musicrep-ts/4600/a5fa/c85f/555d31856cd048d0635a8903e3fdce2c.mp3"
    
    var player: AVPlayer?
    
    func play() {
        player = AVPlayer(url: URL(string: musicUrl)!)
        player!.play()
    }
    
    // 加载本地的歌曲
//    func loadLocalSong() {
//        let songPath = Bundle.main.path(forResource: "song", ofType: "mp3")!
//        print(songPath)
//        let url = URL(fileURLWithPath: songPath)
//    }
}


// TODO_Allen: AVPlayer播放远端音乐；AVAudioPlayer播放本地音乐
