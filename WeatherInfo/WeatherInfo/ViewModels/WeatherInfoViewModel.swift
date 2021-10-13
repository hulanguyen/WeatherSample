//
//  WeatherInfoViewModel.swift
//  WeatherInfo
//
//  Created by Lam Nguyen Huu (VN) on 11/10/2021.
//

import Foundation
import RxSwift
import RxRelay

class WeatherInfoViewModel {
    var service: WebServices
    var disposedBag = DisposeBag()
    var error = PublishSubject<Error>()
    
    var searchname: String = ""
    init(service: NetworksAPI) {
        self.service = service
    }
    
    var weatherInfo = [
        WeatherInfo(date: "20 OCT 2012", temperature: "30 C", pressure: 1234, humility: "ASDF", description: "HEHE", icon: "10d"),
        WeatherInfo(date: "20 OCT 2012", temperature: "30 C", pressure: 1234, humility: "ASDF", description: "HEHE", icon: "10d"),
        WeatherInfo(date: "20 OCT 2012", temperature: "30 C", pressure: 1234, humility: "ASDF", description: "HEHE", icon: "10d")
    ]
    let weatherDatas = BehaviorRelay<[WeatherData]>(value: [])
    
    func getWeatherForcast(name: String) {
        let query = "?q=\(name)&ctn=\(7)&appid=\(ConstantKeys.kApplicationID)&unit=\(TemperatureUnit.celsius.rawValue)"
        
        let api = WeatherInfoAPI(service: service)
        api.startRequest(query: query)
            .subscribe { weatherRes in
                self.weatherDatas.accept(weatherRes.list)
        } onError: { error in
            self.error.onNext(error)
        }
        .disposed(by: disposedBag)

    }
}
