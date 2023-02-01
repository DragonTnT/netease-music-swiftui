//
//  Music.swift
//  netease-music-swiftui
//
//  Created by Allen long on 2022/12/23.
//

import Foundation
import WCDBSwift

/// 获取歌曲详情  /song/detail?ids=347230，注意非登录状态下，或需要会员时，只能获取到试听部分
/// 音乐
//struct Music {
//
//    let name: String
//    let id: Int
//    let ar: Author
//    let al: Album
//
//}



/// 专辑
//struct Album {
//    let id: Int
//    let name: String
//    let picUrl: String
//}

/// 通过音乐id获取网络播放地址
/// /song/url?id=347230
/// 音乐播放信息
//struct MusicPlayInfo {
//    /// 播放地址
//    let url: String
//    /// 码率
////    let br: Int
//    /// 大小，单位Byte
////    let size: Int
//    /// 时长，单位毫秒
//    let time: Int
//}

/// 通过音乐id获取音乐的下载地址（目前url获取为空，不知是否因为未登录）
/// song/download/url?id=347230
//struct MusicDownload {
//    let url: String
//}




/// 本地音乐
//struct LocalMusic: TableCodable {
//    /// 音乐id，与服务端id一致
//    let id: Int
//    /// 音乐数据
//    let data: Data
//    let is
//    /// 作者
////    let author: Author
//    /// 专辑
////    let album: Album
//
//    enum CodingKeys: String, CodingTableKey {
//            typealias Root = LocalMusic
//            static let objectRelationalMapping = TableBinding(CodingKeys.self)
//            case id
//            case data
//    }
//}

// TODO_Allen: https://github.com/Tencent/wcdb/wiki/Swift-%e8%87%aa%e5%ae%9a%e4%b9%89%e5%ad%97%e6%ae%b5%e6%98%a0%e5%b0%84%e7%b1%bb%e5%9e%8b

/// 作者
//struct Author: ColumnCodable {
//
//    let name: String
//
//    static var columnType: WCDBSwift.ColumnType {
//        return .BLOB
//    }
//
//    init(name:  String) {
//        self.name = name
//    }
//
//    init?(with value: WCDBSwift.FundamentalValue) {
//        let data = value.dataValue
//        guard data.count > 0 else { return nil }
//        guard let dictionary = try? JSONDecoder().decode([String: String].self, from: data) else {
//                    return nil
//        }
//        name = dictionary["name"] as? String ?? ""
//    }
//
//    func archivedValue() -> WCDBSwift.FundamentalValue {
//        if let data = try? JSONEncoder().encode(["name": name]) {
//            return FundamentalValue(data)
//        } else {
//            return FundamentalValue(nil)
//        }
//
//
//    }
//
//
//
//
//}


/// 音乐播放完成后的操作类型
enum MusicCompletedType {
    /// 循环播放
    case cycle
    /// 播放下一首
    case next
    /// 暂停
    case pause
}

class Music: TableCodable {
    
    /// 歌曲名称
    var name = ""
    /// 歌曲id
    var id = 0
    /// 作者姓名
    var authorName = ""
    /// 封面图地址
    var albumPicUrl = ""
    /// 播放地址
    var playUrl = ""
    /// 下载之后的数据
    var data: Data?
    /// 是否已被收藏
    var isCollected = false
    /// 是否已下载
    var isDownloaded: Bool {
        return data != nil
    }
    
    
    init(name: String, id: Int, authorName: String, albumPicUrl: String, playUrl: String) {
        self.name = name
        self.id = id
        self.authorName = authorName
        self.albumPicUrl = albumPicUrl
        self.playUrl = playUrl
    }
    
    init() {}
    
//    enum CodingKeys: String, CodingTableKey {
//        typealias Root = NewMusic
//        static let objectRelationalMapping = TableBinding(CodingKeys.self)
//    }
    
    enum CodingKeys: String, CodingTableKey {
        typealias Root = Music
        static let objectRelationalMapping = TableBinding(CodingKeys.self)
        case name
        case id
        case authorName
        case albumPicUrl
        case playUrl
        case data
        case isCollected
        
        static var columnConstraintBindings: [Music.CodingKeys : ColumnConstraintBinding]? {
            return [
                id: ColumnConstraintBinding(isPrimary: true, onConflict: Conflict.replace)
            ]
        }
    }
}

