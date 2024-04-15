//
//  NotificationViewModel.swift
//  CakesHub
//
//  Created by Dmitriy Permyakov on 26/11/2023.
//  Copyright 2023 © VK Team CakesHub. All rights reserved.
//

import SwiftUI

// MARK: - NotificationViewModelProtocol

protocol NotificationViewModelProtocol: AnyObject {
    
    func setupWebSocket()
    func deleteNotification(id notificationID: Int)
}

// MARK: - NotificationViewModel

final class NotificationViewModel: ObservableObject, ViewModelProtocol {
    
    @Published private(set) var notifications: [NotificationModel]
    @Published private(set) var screenIsShimmering: Bool

    init(notifications: [NotificationModel] = [], screenIsShimmering: Bool = true) {
        self.notifications = notifications
        self.screenIsShimmering = screenIsShimmering
    }
}

// MARK: - Actions

extension NotificationViewModel: NotificationViewModelProtocol {

    func setupWebSocket() {
        screenIsShimmering = false
    }

    func deleteNotification(id notificationID: Int) {
        guard let deletedNotificationIndex = notifications.firstIndex(where: { $0.id == notificationID }) else { return }
        notifications.remove(at: deletedNotificationIndex)
    }
}
