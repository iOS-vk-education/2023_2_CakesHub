//
//  Logger.swift
//  CakesHub
//
//  Created by Dmitriy Permyakov on 02.03.2024.
//

import Foundation
import SwiftPrettyPrint

final class Logger {
    private init() {}

    static func log(kind: Kind = .info, message: Any, function: String = #function) {
        #if DEBUG
        print("[ \(kind.rawValue.uppercased()) ]: [ \(Date()) ]: [ \(function) ]")
        Pretty.prettyPrint(message)
        print()
        #endif
    }

    enum Kind: String, Hashable {
        case info
        case error
        case warning
    }
}
