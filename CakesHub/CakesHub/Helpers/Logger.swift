//
//  Logger.swift
//  CakesHub
//
//  Created by Dmitriy Permyakov on 02.03.2024.
//  Copyright 2024 © VK Team CakesHub. All rights reserved.
//

import Foundation
import SwiftPrettyPrint

final class Logger {
    private init() {}

    static func log(kind: Kind = .info, message: Any, fileName: String = #file, function: String = #function, line: Int = #line) {
        #if DEBUG
        let swiftFileName = fileName.split(separator: "/").last ?? "file not found"
        Swift.print("[ \(kind.rawValue.uppercased()) ]: [ \(Date()) ]: [ \(swiftFileName) ] [ \(function) ]: [ #\(line) ]")
        Pretty.prettyPrint(message)
        Swift.print()
        #endif
    }

    static func `print`(_ message: Any, line: Int = #line) {
        #if DEBUG
        Swift.print("[DEBUG]: #\(line):", message)
        #endif
    }

    enum Kind: String, Hashable {
        case info  = "ℹ️ info"
        case error = "⛔️ error"
        case dbError = "📀 db error"
        case dbInfo = "📀 db info"
        case debug = "⚙️ debug"
        case warning = "⚠️ warning"
        case imageError = "image error"
        case webSocket = "web socket"
    }
}
