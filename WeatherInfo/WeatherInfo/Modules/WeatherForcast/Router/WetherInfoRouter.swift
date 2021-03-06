//
//  WetherInfoRouter.swift
//  WeatherInfo
//
//  Created by Lam Nguyen Huu (VN) on 13/10/2021.
//

import Foundation

class WeatherInfoRouter {
    
    func initialViewController() -> WeatherInfoViewController {
        let interactor = WeatherInfoInteractor(service: WebServices())
        let presenter = WeatherInfoPresenter(interactor: interactor)
        let weatherInfoController = WeatherInfoViewController(presenter: presenter)
        return weatherInfoController
    }
    
}
