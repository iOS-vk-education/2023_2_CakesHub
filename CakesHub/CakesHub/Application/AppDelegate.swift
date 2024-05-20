//
//
//  AppDelegate.swift
//  CakesHub
//
//  Created by Dmitriy Permyakov on 12.05.2024.
//  Copyright 2024 © VK Team CakesHub. All rights reserved.
//

import UIKit
import FirebaseCore

final class AppDelegate: NSObject, UIApplicationDelegate {

    var wbManager: WebSockerManagerProtocol { WebSockerManager.shared }

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        FirebaseApp.configure()
        startWebSocketLink()
        setupLocalNotifications()
        return true
    }

    func applicationWillTerminate(_ application: UIApplication) {
        wbManager.close()
        Logger.log(kind: .webSocket, message: "Web Socket соединение закрыто")
    }
}

private extension AppDelegate {

    func startWebSocketLink() {
        // Если пользователь закеширован, устанавливаем web socket соединение при любом запуске приложения. Иначе после регистрации
        guard let userID = UserDefaults.standard.string(forKey: AuthViewModel.UserDefaultsKeys.currentUser) else {
            return
        }

        wbManager.connection { [weak self] error in
            guard let self else { return }
            if let error {
                if error is APIError {
                    Logger.log(kind: .error, message: error.localizedDescription)
                } else {
                    Logger.log(kind: .error, message: error)
                }
                return
            }

            wbManager.send(
                message: WSMessage.connectionMessage(userID: userID)
            ) { [weak self] in
                guard let self else { return }
                Logger.log(kind: .webSocket, message: "Соединение установленно через App Delegate")

                wbManager.receive { data in
                    do {
                        let message = try JSONDecoder().decode(WSMessage.self, from: data)
                        DispatchQueue.main.async {
                            NotificationCenter.default.post(
                                name: .WebSocketNames.message,
                                object: message
                            )
                        }
                        Task {
                            try? await LocalNotificationManager.shared.assemblyNotification(
                                title: message.userName,
                                body: message.message,
                                timeInterval: 5
                            )
                        }
                        return
                    } catch {
                        do {
                            let notification = try JSONDecoder().decode(WSNotification.self, from: data)
                            DispatchQueue.main.async {
                                NotificationCenter.default.post(
                                    name: .WebSocketNames.notification,
                                    object: notification
                                )
                            }
                            return
                        } catch {
                            Logger.log(kind: .error, message: error.localizedDescription)
                        }
                    }
                }
            }
        }
    }

    func setupLocalNotifications() {
        let manager = LocalNotificationManager.shared
        Task {
            try? await manager.requestAuthorization()
        }
    }
}
