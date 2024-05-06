//
//  CakesHubApp.swift
//  CakesHub
//
//  Created by Dmitriy Permyakov on 15.02.2024.
//  Copyright 2024 © VK Team CakesHub. All rights reserved.
//

import SwiftUI
import FirebaseCore
import SwiftData

@main
struct CakesHubApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate

    var body: some Scene {
        WindowGroup {
            RootView()
        }
        .modelContainer(for: [
            SDProductModel.self,
            SDNotificationModel.self
        ])
    }

    init() {
        Logger.print(URL.applicationSupportDirectory.path(percentEncoded: false))
    }
}

// MARK: - App Delegate

final class AppDelegate: NSObject, UIApplicationDelegate {

    var wbManager: WebSockerManagerProtocol { WebSockerManager.shared }

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        FirebaseApp.configure()
        startWebSocketLink()
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
                message: Message.connectionMessage(userID: userID)
            ) {
                Logger.log(kind: .webSocket, message: "Соединение установленно через App Delegate")
            }
        }
    }
}
