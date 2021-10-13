//
//  Double.swift
//  WeatherInfo
//
//  Created by Lam Nguyen Huu (VN) on 12/10/2021.
//

import Foundation

enum DateFormat: String {
        case DDddMMyyyy = "EE, dd MMM yyyy"
}

extension Double {
    func getDateWithFormat(_ format: DateFormat) -> String {
        let date = Date(timeIntervalSince1970: self)

        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: ConstantKeys.kDateFormateLocaleDefault)
        dateFormatter.dateStyle = .medium
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = format.rawValue
        return dateFormatter.string(from: date)
    }
}
