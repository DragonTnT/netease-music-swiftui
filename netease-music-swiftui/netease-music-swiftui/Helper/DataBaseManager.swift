//
//  DataBaseManager.swift
//  netease-music-swiftui
//
//  Created by Allen long on 2023/1/10.
//

import Foundation
import WCDBSwift

struct DatabaseHelper {
    
    static let dataBasePath = NSSearchPathForDirectoriesInDomains(.cachesDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).first! + "/netease.db"
    
    static let musicTableName = "music"
}
