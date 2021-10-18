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
    func clearCacheAfterDay(_ day: Int) 
}
