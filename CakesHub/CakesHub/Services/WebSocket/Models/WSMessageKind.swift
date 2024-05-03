//
//  WSMessageKind.swift
//  CakesHub
//
//  Created by Dmitriy Permyakov on 03.05.2024.
//

import Foundation

enum WSMessageKind: String, Codable {
    case connection
    case message
    case close
    case notification
}
