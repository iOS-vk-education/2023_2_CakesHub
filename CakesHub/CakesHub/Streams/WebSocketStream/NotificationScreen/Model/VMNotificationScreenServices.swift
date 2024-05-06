//
//  VMNotificationScreenServices.swift
//  CakesHub
//
//  Created by Dmitriy Permyakov on 03.05.2024.
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
