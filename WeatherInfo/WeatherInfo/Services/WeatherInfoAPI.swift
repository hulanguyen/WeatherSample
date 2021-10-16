//
//  WeatherInfoAPI.swift
//  WeatherInfo
//
//  Created by Lam Nguyen Huu (VN) on 12/10/2021.
//

import Foundation
import RxSwift

struct WeatherInfoAPI {
    let service: NetworkServices
    
    init(service: NetworkServices) {
        self.service = service
    }
    
    func startRequest(query: String) -> Observable<WeatherModel> {
        var urlString = Endpoint.baseURL.rawValue + Endpoint.forcastDaily.rawValue
        urlString += query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
      
        let url = URL(string: urlString)!
        let result: Observable<WeatherModel> = service.request(url: url,
                                                               method: .get, contentType: ConstantKeys.kContentTypeValue, headers: [:], parameters: nil, cachePolicy: .returnCacheDataElseLoad)
        return result
    }
}
