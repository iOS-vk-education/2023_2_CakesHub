//
//  NotificationViewModel.swift
//  CakesHub
//
//  Created by Dmitriy Permyakov on 26/11/2023.
//  Copyright 2023 © VK Team CakesHub. All rights reserved.
//

import SwiftUI
import Observation

// MARK: - NotificationViewModelProtocol

protocol NotificationViewModelProtocol: AnyObject {
    // MARK: Network
    func fetchNotifications(currentUserID: String) async throws -> [NotificationModel]
    func deleteNotification(id: String) async throws
    // MARK: Actions
    func onAppear(currentUserID: String)
    func deleteNotification(id notificationID: String)
    // MARK: WebSocketLayer
    func getNotificationsFromWebSocketLayer()
}

// MARK: - NotificationViewModel

@Observable
final class NotificationViewModel: ViewModelProtocol {

    private(set) var notifications: [NotificationModel]
    private(set) var screenIsShimmering: Bool
    private let services: Services

    init(
        notifications: [NotificationModel] = [],
        screenIsShimmering: Bool = true,
        services: Services = Services()
    ) {
        self.notifications = notifications
        self.screenIsShimmering = screenIsShimmering
        self.services = services
    }
}


// MARK: - Network

extension NotificationViewModel: NotificationViewModelProtocol {
    
    func fetchNotifications(currentUserID: String) async throws -> [NotificationModel] {
        let fbNotifications = try await services.fbManager.getNotifications(customerID: currentUserID)
        let notifications = fbNotifications.map { $0.mapper }
        return notifications
    }

    func deleteNotification(id: String) async throws {
        try await services.fbManager.deleteNotification(id: id)
    }
}

// MARK: - Actions

extension NotificationViewModel {

    @MainActor
    func onAppear(currentUserID: String) {
        getNotificationsFromWebSocketLayer()
        // TODO: Добавить фетч из бд
        Task {
            screenIsShimmering = true
            do {
                notifications = try await fetchNotifications(currentUserID: currentUserID)
                screenIsShimmering = false
            } catch {
                if error is APIError {
                    Logger.log(kind: .error, message: error.localizedDescription)
                } else {
                    Logger.log(kind: .error, message: error)
                }
            }
        }
    }

    func deleteNotification(id notificationID: String) {
        // Отправляем запрос на удаление уведомления
        Task {
            do {
                try await deleteNotification(id: notificationID)
            } catch {
                Logger.log(kind: .error, message: error.localizedDescription)
            }
        }
        // Удаляем локально
        guard let deletedNotificationIndex = notifications.firstIndex(where: { $0.id == notificationID }) else { return }
        notifications.remove(at: deletedNotificationIndex)
    }
}

// MARK: - WebSocketLayer

extension NotificationViewModel {

    func getNotificationsFromWebSocketLayer() {
        services.wsManager.receive { [weak self] (response: WSNotification) in
            guard let self else { return }
            let notification: NotificationModel = response.mapper
            if !notifications.contains(where: { $0.id == notification.id }) {
                DispatchQueue.main.async {
                    if self.screenIsShimmering {
                        self.screenIsShimmering = false
                    }
                    self.notifications.append(notification)
                    // TODO: Добавить кэширование
                }
            }
        }
    }
}
