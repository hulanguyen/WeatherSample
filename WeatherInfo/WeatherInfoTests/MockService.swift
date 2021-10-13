//
//  MockService.swift
//  WeatherInfoTests
//
//  Created by Lam Nguyen Huu (VN) on 13/10/2021.
//

import Foundation
import RxSwift
@testable import WeatherInfo

class MockService: WebServices {
    
    var data: Data? = nil
    var error : Error? = nil
    var errorData: Data? = nil
    
    func request<T>(url: URL, method: HTTPMethod, contentType: String, headers: [String : String], parameters: [String : Any]?, cachePolicy: URLRequest.CachePolicy) -> Observable<T> where T : Decodable, T : Encodable {
        let result = Observable<T>.create { (observer) -> Disposable in
            self.handlingDataForRequest(observer: observer)
            return Disposables.create()
        }
        return result
    }
    
    private func handlingDataForRequest<T: Codable>(observer: AnyObserver<T>) {
        if let data = self.data {
            let parsedObject = try? JSONDecoder().decode(T.self, from: data)
            if let parsedObject = parsedObject {
                observer.onNext(parsedObject)
            }
        } else if let error = self.error as? ResponseError {
            observer.onError(error)
            
        }
    }
    
}
