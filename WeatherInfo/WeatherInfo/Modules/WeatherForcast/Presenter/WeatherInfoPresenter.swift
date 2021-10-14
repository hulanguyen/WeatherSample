//
//  WeatherInfoPresenter.swift
//  WeatherInfo
//
//  Created by Lam Nguyen Huu (VN) on 13/10/2021.
//

import Foundation
import RxSwift
import RxRelay

class WeatherInfoPresenter {
    
    private let disposeBag = DisposeBag()
    
    private let interactor: WeatherInfoInteractor
    
    
    public var listWeatherForcast = BehaviorRelay<[WeatherData]>(value: [])
    public var error = PublishSubject<Error>()
    public var searchName: String = ""
    
    init(interactor: WeatherInfoInteractor) {
        self.interactor = interactor
        bindInteractor()
    }
    
    func loadWeatherInfo(name: String) {
        interactor.getWeatherForcast(name: name)
    }

    func bindInteractor() {
        interactor
            .weatherDatas
            .subscribe { [weak self] weatherData in
                self?.listWeatherForcast.accept(weatherData)
            }
            .disposed(by: disposeBag)
        
        interactor.error.subscribe { [weak self] error in
            self?.error.onNext(error)
        }
        .disposed(by: disposeBag)

    }
}
