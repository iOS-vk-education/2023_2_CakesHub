//
//  APIError.swift
//  CakesHub
//
//  Created by Dmitriy Permyakov on 02.03.2024.
//  Copyright 2024 © VK Team CakesHub. All rights reserved.
//

import Foundation

enum APIError: LocalizedError {
    case badParameters
    case dataIsNil
    case badStatusCode(Int)
    case error(Error)
    case responseIsNil
    case incorrectlyURL
    case uidNotFound
    case userIsNil

    var errorDescription: String {
        switch self {
        case .badParameters: return "query parameters are incorrectly"
        case .dataIsNil: return "data is nil"
        case .responseIsNil: return "response is nil"
        case .badStatusCode(let code): return "Bad statuc code: \(code)"
        case .error(let error): return error.localizedDescription
        case .incorrectlyURL: return "url is incorrectly"
        case .uidNotFound: return "user uid not found"
        case .userIsNil: return "current user not found"
        }
    }
}
