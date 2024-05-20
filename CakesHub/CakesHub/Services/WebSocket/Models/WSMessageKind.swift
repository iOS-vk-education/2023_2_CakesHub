//
//  WSMessageKind.swift
//  CakesHub
//
//  Created by Dmitriy Permyakov on 03.05.2024.
//  Copyright 2024 © VK Team CakesHub. All rights reserved.
//

import Foundation

enum WSMessageKind: String, Codable {
    case connection
    case message
    case close
    case notification
}
