//
//  VMNotificationScreenServices.swift
//  CakesHub
//
//  Created by Dmitriy Permyakov on 03.05.2024.
//  Copyright 2024 © VK Team CakesHub. All rights reserved.
//

import Foundation

extension NotificationViewModel {

    struct Services {
        let wsManager: WebSockerManagerProtocol
        let fbManager: NotificationServiceProtocol

        init(
            wsManager: WebSockerManagerProtocol = WebSockerManager.shared,
            fbManager: NotificationServiceProtocol = NotificationService.shared
        ) {
            self.wsManager = wsManager
            self.fbManager = fbManager
        }
    }
}
