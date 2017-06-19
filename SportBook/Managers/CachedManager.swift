//
//  CacheManager.swift
//  SportBook
//
//  Created by DucBM on 6/7/17.
//  Copyright © 2017 dinosys. All rights reserved.
//

import Foundation

public enum CachedFile : String {
    case tournament = "tournaments.plist"
}

class CachedManager {
    
    static func getCachedFileURL(_ fileName: String) -> URL {
        return FileManager.default
            .urls(for: .cachesDirectory, in: .allDomainsMask)
            .first!
            .appendingPathComponent(fileName)
    }
    
    static func getCachedFile(_ fileName: String) -> [[String: Any]] {
        let cachedFileURL = getCachedFileURL(fileName)
        let cachedArray = (NSArray(contentsOf: cachedFileURL)
            as? [[String: Any]]) ?? []
        
        return cachedArray
    }
    
    static func writeCachedFile(_ fileName: String, data: NSArray) {
        let cachedFileURL = getCachedFileURL(fileName)
        data.write(to: cachedFileURL, atomically: true)
    }
}
