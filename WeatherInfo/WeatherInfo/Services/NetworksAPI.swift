//
//  NetworksAPI.swift
//  WeatherInfo
//
//  Created by Lam Nguyen Huu (VN) on 12/10/2021.
//

import Foundation
import RxSwift


enum ResponseError: Error {
    case netWorkNotFound
    case clientError(error: ErrorData)
    case serverError(error: Error)
    case parsingError
    case unknowError
}

final class NetworksAPI: WebServices {
   
    func request<T: Codable>(url: URL,
                             method: HTTPMethod,
                             contentType: String,
                             headers: [String: String],
                             parameters: [String : Any]?,
                             cachePolicy: URLRequest.CachePolicy) -> Observable<T> {
        guard Reachability.isInternetAvailable() else {
            return Observable<T>.create({ observer -> Disposable in
                observer.onError(ResponseError.netWorkNotFound)
                return Disposables.create()
            })
        }
        // create the request
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method.rawValue
        urlRequest.timeoutInterval = 60
        urlRequest.setValue(contentType, forHTTPHeaderField: "Content-Type")
        urlRequest.cachePolicy = cachePolicy
        for (headerField, headerValue) in headers {
            urlRequest.setValue(headerValue, forHTTPHeaderField: headerField)
        }
        if let parameters = parameters {
            do {
                let data = try JSONSerialization.data(withJSONObject: parameters, options: JSONSerialization.WritingOptions.prettyPrinted)
                urlRequest.httpBody = data
            } catch {
                fatalError("Make sure the parameters can be endcoded \nReceived parameter: \(parameters)")
            }
        }
        let result = Observable<T>.create { observer -> Disposable in
            
            debugPrint("NetworksAPI:\(urlRequest)")
            
            let task =  URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
                if let httpResponse = response as? HTTPURLResponse{
                    let statusCode = httpResponse.statusCode
                    do {
                        let _data = data ?? Data()
                        if (200...399).contains(statusCode) {
                            let objs = try JSONDecoder().decode(T.self, from:_data)
                            observer.onNext(objs)
                        }
                        else {
                            if let error = error {
                                observer.onError(ResponseError.serverError(error: error))
                            } else {
                                let errorData = try JSONDecoder().decode(ErrorData.self, from:_data)
                                observer.onError(ResponseError.clientError(error: errorData))
                            }
                        }
                    } catch {
                        observer.onError(ResponseError.parsingError)
                    }
                }
                observer.onCompleted()
            }
            task.resume()
            return Disposables.create {
                task.cancel()
            }
        }
        return result
    }
}
