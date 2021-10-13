//
//  ConstantKey.swift
//  WeatherInfo
//
//  Created by Lam Nguyen Huu (VN) on 11/10/2021.
//

import Foundation

class ConstantKeys {
    static let kWeatherSearchScreenNavigationTitle = "Weather Forecase"
    static let kNilValueDisplay = "N/A"
    static let kWeatherInfoCellReuseIdentifier = "WeatherInfoCellReuseIdentifier"
    static let kweatherInfoCellNibName = "WeatherInfoTableViewCell"
    static let kContentTypeValue = "application/json"
    static let kApplicationID = "60c6fbeb4b93ac653c492ba806fc346d"
    static let kDateFormateLocaleDefault  = "en_US_POSIX"

}

enum Endpoint: String {
    case forcastDaily       = "/data/2.5/forecast/daily"
    case baseURL = "https://api.openweathermap.org"
}

enum TemperatureUnit: String {
    case kelvin = "default"
    case celsius = "metric"
    case fahrenheit = "imperial"
}
