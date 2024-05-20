//
//  Logger.swift
//
//
//  Created by Dmitriy Permyakov on 10.04.2024.
//

import Foundation

final class Logger {
    private init() {}

    static func log(kind: Kind = .info, message: Any, function: String = #function) {
        print("[ \(kind.rawValue.uppercased()) ]: [ \(Date()) ]: [ \(function) ]")
        print(message)
        print()
    }

    enum Kind: String {
        case info
        case error
        case warning
        case message
        case close
        case connection
    }
}
