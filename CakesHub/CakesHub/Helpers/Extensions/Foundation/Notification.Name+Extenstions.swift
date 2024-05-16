//
//
//  Notification.Name+Extenstions.swift
//  CakesHub
//
//  Created by Dmitriy Permyakov on 09.05.2024.
//  Copyright 2024 © VK Team CakesHub. All rights reserved.
//

import Foundation

extension Notification.Name {

    enum WebSocketNames {
        static let message = Notification.Name("com.vk.notification.name.message")
        static let notification = Notification.Name("com.vk.notification.name.notification")
    }
}
