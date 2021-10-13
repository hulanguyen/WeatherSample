//
//  WeatherInfoModels.swift
//  WeatherInfo
//
//  Created by Lam Nguyen Huu (VN) on 11/10/2021.
//

import Foundation

struct WeatherInfo {
    let date: String
    let temperature: String
    let pressure: Int
    let humility: String
    let description: String
    let icon: String?
}

extension WeatherInfo {
    init(date: String, temperature: String, pressure: Int? = nil, humility: String? = nil, description: String? = nil, icon: String? = nil) {
        self.date = date
        self.temperature = temperature
        self.pressure = pressure ?? 0
        self.humility = humility ?? ConstantKeys.kNilValueDisplay
        self.description = description ?? ConstantKeys.kNilValueDisplay
        self.icon = icon
    }
}


struct WeatherModel: Codable {
    let list: [WeatherData]
}

struct Temp: Codable {
    let day: Double
}

struct Weather: Codable {
    let id: Int
    let main: String
    let description: String
    let icon: String
}

struct WeatherData: Codable {
    let dt: Double
    let temp: Temp
    let pressure: Int
    let humidity: Int
    let weather: [Weather]
}

extension WeatherData {
//    func mapToWeatherInfo() -> WeatherInfo {
//        let date = self.dt
//        return WeatherInfo(date: <#T##String#>, temperature: <#T##String#>, pressure: <#T##Int?#>, humility: <#T##String?#>, description: <#T##String?#>, icon: <#T##String?#>)
//    }
}

struct ErrorData: Codable {
    let code: String
    let message: String
    
    enum CodingKeys: String, CodingKey {
        case message
        case code = "cod"
    }
}
