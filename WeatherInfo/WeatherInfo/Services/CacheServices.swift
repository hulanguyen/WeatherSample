//
//  CacheServices.swift
//  WeatherInfo
//
//  Created by Lam Nguyen Huu (VN) on 18/10/2021.
//

import Foundation

class LocalCache: CacheServices {
    func createCacheStore(memoryCapacity: Int, diskCapacity: Int) {
        URLCache.shared = URLCache(
            memoryCapacity: memoryCapacity,
            diskCapacity: diskCapacity,
            diskPath: nil
        )
    }
    
    func getCacheResponse(for request: URLRequest) -> CachedURLResponse? {
        return URLCache.shared.cachedResponse(for: request)
    }
    
    func clearAllCache() {
        URLCache.shared.removeAllCachedResponses()
    }
    
    func clearCacheAfterDay(_ day: Int) {
        guard let saveDate = UserDefaults.standard.value(forKey: "saveDate") as? Date else {
            debugPrint("create date")
            UserDefaults.standard.set(Date(), forKey: "saveDate")
            return
        }
        let currentDate = Date()
        let compareTime: Double = Double(day * 24 * 60 * 60)
        let timeInterval = currentDate.timeIntervalSince(saveDate)
        if timeInterval > compareTime {
            clearAllCache()
            UserDefaults.standard.set(Date(), forKey: "saveDate")
            debugPrint("Clear cache")
        }
    }
}

class CacheManager {
    static let shared = CacheManager()
    let cache: CacheServices = LocalCache()
    private init() {}
}
