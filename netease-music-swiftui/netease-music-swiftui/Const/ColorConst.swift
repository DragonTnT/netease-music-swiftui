//
//  Color+Extension.swift
//  youchelai_swiftui
//
//  Created by longfan on 2022/11/27.
//

import Foundation
import UIKit
import SwiftUI

func hexColor(_ hex:String, alpha: CGFloat = 1.0) -> UIColor {
    
    var cString:String = hex.trimmingCharacters(in: (NSCharacterSet.whitespacesAndNewlines as NSCharacterSet) as CharacterSet).uppercased()
    
    if (cString.hasPrefix("#")) {
        let index = cString.index(cString.startIndex, offsetBy: 1)
        cString = String(cString[index...])
    }
    
    if (cString.count != 6) {
        return .gray
    }
    
    var rgbValue:UInt32 = 0
    Scanner(string: cString).scanHexInt32(&rgbValue)
    
    return UIColor(red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0, green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0, blue: CGFloat(rgbValue & 0x0000FF) / 255.0, alpha: alpha)
}

let Color_Black_Watch_Theme = hexColor("2e3035")            //看门狗主题黑
let Color_Orange_Default = hexColor("fd6512")
let Color_07C27F = hexColor("07c27f")
let Color_5D8C7B = hexColor("5d8c7b")
let Color_F6F8F7 = hexColor("f6f8f7")
let Color_EEF7FF = hexColor("EEF7FF")
let Color_4A90E2 = hexColor("4A90E2")
let Color_E9FFF7 = hexColor("E9FFF7")
let Color_E4FBF2 = hexColor("E4FBF2")
let Color_9DA5AD = hexColor("9da5ad")               //默认绿
let Color_EFF2F1 = hexColor("eff2f1")
let Color_606369 = hexColor("606369")
let Color_FD6512 = hexColor("fd6512")
let Color_17191F = hexColor("17191f")
let Color_EBF2EF = hexColor("EBF2EF")
let Color_1C413E = hexColor("1C413E")
let Color_F6F8FA = hexColor("F6F8FA")

//`有车来`颜色

let Color_12C194 = hexColor("12C194")   //绿
let Color_FCCE1C = hexColor("FCCE1C")   //黄
let Color_F57221 = hexColor("F57221")   //橙
let Color_EE5845 = hexColor("EE5845")   //红
let Color_629185 = hexColor("629185")   //辅绿
let Color_1F2129 = hexColor("1F2129")   //黑
let Color_9096AB = hexColor("9096AB")   //灰
let Color_C8CCDB = hexColor("C8CCDB")   //浅灰,默认为按钮不可选时的文字颜色
let Color_F2F6F8 = hexColor("F2F6F8")   //灰白，默认为按钮不可选时的背景颜色
let Color_EBF1F3 = hexColor("EBF1F3")   //分割线
let Color_18191F = hexColor("18191F")
let Color_2A2D38 = hexColor("2A2D38")
let Color_E8ECF1 = hexColor("E8ECF1")
let Color_FEF2F1 = hexColor("FEF2F1")
let Color_E6F8F2 = hexColor("E6F8F2")
let Color_B4B8C3 = hexColor("B4B8C3")
let Color_E7F8F4 = hexColor("E7F8F4")
let Color_50525C = hexColor("50525C")
let Color_13B088 = hexColor("13B088")
let Color_14151B = hexColor("14151B")
let Color_E1E1E1 = hexColor("E1E1E1")
let Color_313542 = hexColor("313542")
let Color_353431 = hexColor("353431")       //白银会员文字
let Color_5D4517 = hexColor("5D4517")       //黄金会员文字
let Color_562D30 = hexColor("562D30")       //铂金会员文字
let Color_2A3A35 = hexColor("2A3A35")       //钻石会员文字
let Color_FA911D = hexColor("FA911D")
let Color_FF7B21 = hexColor("FF7B21")
let Color_F5F9FE = hexColor("F5F9FE")
let Color_A38463 = hexColor("A38463")
let Color_F0CCAA = hexColor("F0CCAA")
let Color_F1F4F6 = hexColor("F1F4F6")
let Color_E6ECEE = hexColor("E6ECEE")
let Color_F6DDB7 = hexColor("F6DDB7")
let Color_E53620 = hexColor("E53620")


let grayTextColor = Color.init(red: 124/255.0, green: 130/255.0, blue: 145/255.0)

