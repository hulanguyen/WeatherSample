//
//  Protocol.swift
//  WeatherInfo
//
//  Created by Lam Nguyen Huu (VN) on 18/10/2021.
//

import Foundation

protocol ErrorMessage {
    func getErrorMessage(error: Error) -> String
}

extension ErrorMessage {
    func getErrorMessage(error: Error) -> String {
        guard let resError = error as? ResponseError else {
            return ""
        }
        var message = ""
        switch resError {
        case .netWorkNotFound:
            message = ConstantKeys.kErrorMessageNetWorkNotFound
        case .clientError(let error):
            message = error.message
        case .serverError(let error):
            message = error.localizedDescription
        case .parsingError:
            message = ConstantKeys.kErrorMessageParsingFailed
        case .unknowError:
            message = ConstantKeys.kErrorMessageUnknowIssue
        }
        return message
    }
}
