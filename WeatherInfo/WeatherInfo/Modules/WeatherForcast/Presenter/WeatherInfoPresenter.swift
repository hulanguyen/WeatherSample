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
    
    var headerTitle :String =  ""
    let listWeatherForcast = BehaviorRelay<[WeatherData]>(value: [])
    let errorMessage = PublishSubject<String>()
    var searchName: String = ""
    
    init(interactor: WeatherInfoInteractor) {
        self.interactor = interactor
        bindInteractor()
    }
    
    func loadWeatherInfo(name: String) {
        interactor.getWeatherForcast(name: name)
    }

    private func bindInteractor() {
        interactor
            .weatherDatas
            .subscribe(onNext: { [weak self] weatherData in
                self?.listWeatherForcast.accept(weatherData)
            })
            .disposed(by: disposeBag)
        

        interactor
            .error
            .subscribe(onNext: { [weak self] error in
                guard let self = self else {return}
                self.errorMessage.onNext(error)
            })
            .disposed(by: disposeBag)
        
        interactor
            .cityInfo
            .subscribe(onNext: { [weak self] cityInfo in
                let headerTitle = "\(cityInfo.name), \(cityInfo.country)"
                self?.headerTitle = headerTitle
            })
            .disposed(by: disposeBag)
        
    }
}
