//
//  Services.swift
//  WeatherInfo
//
//  Created by Lam Nguyen Huu (VN) on 12/10/2021.
//

import Foundation
import RxSwift

public enum HTTPMethod: String {
    case options = "OPTIONS"
    case get     = "GET"
    case head    = "HEAD"
    case post    = "POST"
    case put     = "PUT"
    case patch   = "PATCH"
    case delete  = "DELETE"
    case trace   = "TRACE"
    case connect = "CONNECT"
}

protocol NetworkServices {
    func request<T: Codable>(
        url: URL,
        method: HTTPMethod,
        contentType: String,
        headers: [String: String],
        parameters: [String: Any]?,
        cachePolicy: URLRequest.CachePolicy) -> Observable<T>
}

protocol CacheServices {
    func createCacheStore(memoryCapacity: Int, diskCapacity: Int)
    func getCacheResponse(for request: URLRequest) -> CachedURLResponse?
    func clearAllCache()
    func clearCacheAfterDuration(_ day: Int) 
}

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
    
    func clearCacheAfterDuration(_ day: Int) {
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
