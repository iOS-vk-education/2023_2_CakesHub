//
//  ProductDetailVMServices.swift
//  CakesHub
//
//  Created by Dmitriy Permyakov on 06.05.2024.
//

import Foundation

extension ProductDetailViewModel {
    
    struct VMServices: ClearConfigurationProtocol {
        let wsService: WebSockerManagerProtocol
        let notificationService: NotificationServiceProtocol

        init(
            wsService: WebSockerManagerProtocol = WebSockerManager.shared,
            notificationService: NotificationServiceProtocol = NotificationService.shared
        ) {
            self.wsService = wsService
            self.notificationService = notificationService
        }

        static let clear = VMServices()
    }
}
