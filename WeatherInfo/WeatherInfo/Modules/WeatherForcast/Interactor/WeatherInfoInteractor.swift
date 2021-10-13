//
//  WeatherInfoInteractor.swift
//  WeatherInfo
//
//  Created by Lam Nguyen Huu (VN) on 11/10/2021.
//

import Foundation
import RxSwift
import RxRelay

class WeatherInfoInteractor {
    var service: WebServices
    var disposedBag = DisposeBag()
    var error = PublishSubject<Error>()
    
    var searchname: String = ""
    init(service: NetworksAPI) {
        self.service = service
    }
    
    let weatherDatas = PublishSubject<[WeatherData]>()
    
    func getWeatherForcast(name: String) {
        let query = "?q=\(name)&ctn=\(7)&appid=\(ConstantKeys.kApplicationID)&unit=\(TemperatureUnit.celsius.rawValue)"
        
        let api = WeatherInfoAPI(service: service)
        api.startRequest(query: query)
            .subscribe { weatherRes in
                self.weatherDatas.onNext(weatherRes.list)
        } onError: { error in
            self.error.onNext(error)
        }
        .disposed(by: disposedBag)
    }
}
