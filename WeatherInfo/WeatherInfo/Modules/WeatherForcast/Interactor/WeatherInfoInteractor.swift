//
//  WeatherInfoInteractor.swift
//  WeatherInfo
//
//  Created by Lam Nguyen Huu (VN) on 11/10/2021.
//

import Foundation
import RxSwift
import RxRelay

class WeatherInfoInteractor: ErrorMessage {
    private var service: NetworkServices
    private var disposedBag = DisposeBag()
    let error = PublishSubject<String>()
    let weatherDatas = PublishSubject<[WeatherData]>()
    let cityInfo = PublishSubject<CityInfo>()
    
    init(service: NetworkServices) {
        self.service = service
    }
    
    func getWeatherForcast(name: String) {
        let query = "?q=\(name)&cnt=\(7)&appid=\(ConstantKeys.kApplicationID)&units=\(TemperatureUnit.celsius.rawValue)"
        
        let api = WeatherInfoAPI(service: service)
        api.startRequest(query: query)
            .subscribe { weatherRes in
                self.weatherDatas.onNext(weatherRes.list)
                self.cityInfo.onNext(weatherRes.city)
        } onError: { error in
            self.error.onNext(self.getErrorMessage(error: error))
        }
        .disposed(by: disposedBag)
    }
}
