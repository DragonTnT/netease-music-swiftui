//
//  Music.swift
//  netease-music-swiftui
//
//  Created by Allen long on 2022/12/23.
//

import Foundation
/// 获取歌曲详情  /song/detail?ids=347230，注意非登录状态下，或需要会员时，只能获取到试听部分
/// 音乐
struct Music {
    
    let name: String
    let id: Int
    let ar: Author
    let al: Album    
    
    /// 作者
    struct Author {
        let name: String
    }
    
    /// 专辑
    struct Album {
        let id: Int
        let name: String
        let picUrl: String
    }
}

/// 通过音乐id获取网络播放地址
/// /song/url?id=347230
/// 音乐地址，
struct MusicAddress {
    let url: String
}

/// 通过音乐id获取音乐的下载地址（目前url获取为空，不知是否因为未登录）
/// song/download/url?id=347230
struct MusicDownload {
    let url: String
}
