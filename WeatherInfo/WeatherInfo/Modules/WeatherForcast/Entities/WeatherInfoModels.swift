//
//  WeatherInfoModels.swift
//  WeatherInfo
//
//  Created by Lam Nguyen Huu (VN) on 11/10/2021.
//

import Foundation

struct WeatherModel: Codable {
    let list: [WeatherData]
}

struct Temp: Codable {
    let day: Double
    let min: Double
    let max: Double
    var average: Double {
        (min + max) / 2
    }
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

struct ErrorData: Codable {
    let code: String
    let message: String
    
    enum CodingKeys: String, CodingKey {
        case message
        case code = "cod"
    }
}
