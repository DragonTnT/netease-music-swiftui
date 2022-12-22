//
//  Const.swift
//  youchelai_swiftui
//
//  Created by Allen long on 2022/11/10.
//

import Foundation
import UIKit

public let kScreenH = UIScreen.main.bounds.size.height
public let kScreenW = UIScreen.main.bounds.size.width
public var statusBarH: CGFloat {
    return UIApplication.shared.windows.filter {$0.isKeyWindow}.first?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
}
public let navigationBarH: CGFloat = 44

/// frame适配器
func adapter(_ value: CGFloat) -> CGFloat {
    if value < 1 {
        return (value * (UIScreen.main.bounds.width/375))
    } else {
        return (value * (UIScreen.main.bounds.width/375)).rounded()
    }
}

/// 消除默认的adapter适配
func noAdapter(_ value: CGFloat) -> CGFloat {
    return value / (UIScreen.main.bounds.width/375)
}

/// 延迟执行
func delay(_ timeInterval: TimeInterval, action: @escaping(()->())) {
    let time = DispatchTime.now() + timeInterval
    DispatchQueue.main.asyncAfter(deadline: time, execute: action)
}
