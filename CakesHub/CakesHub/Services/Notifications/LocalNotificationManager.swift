//
//
//  LocalNotificationManager.swift
//  CakesHub
//
//  Created by Dmitriy Permyakov on 12.05.2024.
//  Copyright 2024 © VK Team CakesHub. All rights reserved.
//

import SwiftUI
import Foundation
import UserNotifications

protocol LocalNotificationManagerProtocol: AnyObject {
    func requestAuthorization() async throws -> Bool
    func assemblyNotification(title: String, subtitle: String?, body: String?, timeInterval: Double) async throws
    func getCurrentNotificationState() async -> Bool
    func openSettings()
}

// MARK: - LocalNotificationManager

final class LocalNotificationManager {

    static let shared = LocalNotificationManager()
    private let currentNotification = UNUserNotificationCenter.current()
    private init() {}
}

// MARK: - LocalNotificationManagerProtocol

extension LocalNotificationManager: LocalNotificationManagerProtocol {

    @discardableResult
    /// Авторизация уведомления
    func requestAuthorization() async throws -> Bool {
        let authorizationOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        let result = try await currentNotification.requestAuthorization(options: authorizationOptions)
        return result
    }
    
    /// Создание уведомления
    func assemblyNotification(
        title: String,
        subtitle: String? = nil,
        body: String? = nil,
        timeInterval: Double = 0.5
    ) async throws {
        let content = UNMutableNotificationContent()
        content.title = title
        content.sound = .default
        if let subtitle {
            content.subtitle = subtitle
        }
        if let body {
            content.body = body
        }

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeInterval, repeats: false)
        let request = UNNotificationRequest(
            identifier: UUID().uuidString,
            content: content,
            trigger: trigger
        )

        try await currentNotification.add(request)
    }
    
    /// Флаг, авторизованы ли уведомления пользователя
    func getCurrentNotificationState() async -> Bool {
        let settings = await currentNotification.notificationSettings()
        let isGranted = settings.authorizationStatus == .authorized
        return isGranted
    }

    @MainActor
    /// Открытие экрана настроект с уведомлениями
    func openSettings() {
        guard 
            let url = URL(string: UIApplication.openSettingsURLString),
            UIApplication.shared.canOpenURL(url)
        else {
            return
        }
        Task {
            await UIApplication.shared.open(url)
        }
    }
}
