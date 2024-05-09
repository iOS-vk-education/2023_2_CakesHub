//
//  NotificationViewModel.swift
//  CakesHub
//
//  Created by Dmitriy Permyakov on 26/11/2023.
//  Copyright 2023 © VK Team CakesHub. All rights reserved.
//

import SwiftUI
import SwiftData
import Observation

// MARK: - NotificationViewModelProtocol

protocol NotificationViewModelProtocol: AnyObject {
    // MARK: Network
    func fetchNotifications(currentUserID: String) async throws -> [FBNotification]
    func deleteNotification(id: String) async throws
    // MARK: Actions
    func onAppear(currentUserID: String)
    func deleteNotification(id notificationID: String)
    // MARK: WebSocketLayer
    func getNotificationsFromWebSocketLayer()
    // MARK: Memory CRUD
    func save(notification: FBNotification)
    func save(notifications: [FBNotification])
    func fetch() -> [FBNotification]
    // MARK: Reducers
    func setModelContext(with modelContext: ModelContext)
}

// MARK: - NotificationViewModel

@Observable
final class NotificationViewModel: ViewModelProtocol, NotificationViewModelProtocol {

    private(set) var notifications: [NotificationModel]
    private(set) var screenIsShimmering: Bool
    @ObservationIgnored
    private let services: Services
    @ObservationIgnored
    private var modelContext: ModelContext?

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

extension NotificationViewModel {
    
    func fetchNotifications(currentUserID: String) async throws -> [FBNotification] {
        try await services.fbManager.getNotifications(customerID: currentUserID)
    }

    func deleteNotification(id: String) async throws {
        try await services.fbManager.deleteNotification(id: id)
    }
}

// MARK: - Actions

extension NotificationViewModel {

    @MainActor
    func onAppear(currentUserID: String) {
        // Добавляем слушатель Web Socket протокола
        getNotificationsFromWebSocketLayer()

        // Достаём данные из сети
        Task {
            screenIsShimmering = true
            do {
                let fbNotifications = try await fetchNotifications(currentUserID: currentUserID)
                notifications = fbNotifications.map { $0.mapper }
                if screenIsShimmering {
                    withAnimation {
                        screenIsShimmering = false
                    }
                }

                // Кэшируем новые уведомления
                save(notifications: fbNotifications)
            } catch {
                if error is APIError {
                    Logger.log(kind: .error, message: error.localizedDescription)
                } else {
                    Logger.log(kind: .error, message: error)
                }
            }
        }

        // Достаём закэшированные уведомления
        let memoryNotifications = fetch()
        notifications = memoryNotifications.map { $0.mapper }
        screenIsShimmering = false
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

        // Удаляем уведомление из кэша
        delete(for: notificationID)

        // Удаляем локально
        guard let deletedNotificationIndex = notifications.firstIndex(where: { $0.id == notificationID }) else { return }
        notifications.remove(at: deletedNotificationIndex)
    }
}

// MARK: - WebSocketLayer

extension NotificationViewModel {

    func getNotificationsFromWebSocketLayer() {
//        services.wsManager.receive { [weak self] (response: WSNotification) in
//            guard let self else { return }
//            let notification: NotificationModel = response.mapper
//            if !notifications.contains(where: { $0.id == notification.id }) {
//                DispatchQueue.main.async {
//                    // Обновляем UI
//                    if self.screenIsShimmering {
//                        withAnimation {
//                            self.screenIsShimmering = false
//                        }
//                    }
//                    self.notifications.append(notification)
//
//                    // Кэшируем уведомление из Web Socket канала
//                    let fbNotification = FBNotification(
//                        id: response.id,
//                        title: response.title,
//                        date: response.date,
//                        message: response.message,
//                        productID: response.productID,
//                        receiverID: response.receiverID,
//                        creatorID: response.userID
//                    )
//                    self.save(notification: fbNotification)
//                }
//            }
//        }
    }
}

// MARK: - Memory CRUD

extension NotificationViewModel {

    func save(notification: FBNotification) {
        guard let modelContext else {
            Logger.log(kind: .error, message: "model context is nil")
            return
        }

        let sdNotification = SDNotificationModel(fbModel: notification)
        modelContext.insert(sdNotification)
        do {
            try modelContext.save()
            Logger.log(kind: .dbInfo, message: "Уведомление закэшированно успешно")
        }
        catch { Logger.log(kind: .dbError, message: error.localizedDescription) }
    }

    func save(notifications: [FBNotification]) {
        guard let modelContext else {
            Logger.log(kind: .error, message: "model context is nil")
            return
        }

        notifications.forEach {
            let sdNotification = SDNotificationModel(fbModel: $0)
            modelContext.insert(sdNotification)
        }
        do {
            try modelContext.save()
            Logger.log(kind: .dbInfo, message: "Уведомления закэшированны успешно")
        }
        catch { Logger.log(kind: .dbError, message: error.localizedDescription) }
    }

    func fetch() -> [FBNotification] {
        let fetchDesctriptor = FetchDescriptor<SDNotificationModel>()
        let sdNotifications = (try? modelContext?.fetch(fetchDesctriptor)) ?? []
        return sdNotifications.map { $0.mapper }
    }

    func delete(for id: String) {
        guard let modelContext else {
            Logger.log(kind: .dbError, message: "model context is nil")
            return
        }

        var fetchDescriptor = FetchDescriptor<SDNotificationModel>(
            predicate: #Predicate { $0._id == id }
        )
        fetchDescriptor.fetchLimit = 1
        guard let sdNotification = try? modelContext.fetch(fetchDescriptor).first else {
            Logger.log(kind: .dbError, message: "Уведомление не найденно в БД. Удаление невозможно")
            return
        }
        modelContext.delete(sdNotification)

        do {
            try modelContext.save()
            Logger.log(kind: .dbInfo, message: "Уведомление удалено из кэша")
        }
        catch { Logger.log(kind: .dbError, message: error.localizedDescription) }
    }
}

// MARK: - Reducers

extension NotificationViewModel {

    func setModelContext(with modelContext: ModelContext) {
        guard self.modelContext.isNil else { return }
        self.modelContext = modelContext
    }
}
