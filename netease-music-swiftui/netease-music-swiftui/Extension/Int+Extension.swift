//
//  Int+Extension.swift
//  netease-music-swiftui
//
//  Created by Allen long on 2022/12/26.
//

import Foundation

extension Int {
    
    /// 秒转化为音乐时长文本
    func secondToMusicTimeString() -> String {
        if self <= 0 { return "00:00"}
        let minute = self / 60
        let secondReminder = self % 60
        
        let minuteStr = formatTimeTwoLocation(time: minute)
        let secondStr: String
        if minute == 0 {
            secondStr = formatTimeTwoLocation(time: self)
        } else {
            secondStr = formatTimeTwoLocation(time: secondReminder)
        }
        
        return "\(minuteStr):\(secondStr)"
        
        // 将时间转为为两位的文本
        func formatTimeTwoLocation(time: Int) -> String {
            if time < 10 {
                return "0\(time)"
            } else {
                return "\(time)"
            }
        }
    }
}
