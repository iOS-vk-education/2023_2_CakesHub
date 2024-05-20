//
//  CakesHubApp.swift
//  CakesHub
//
//  Created by Dmitriy Permyakov on 15.02.2024.
//  Copyright 2024 © VK Team CakesHub. All rights reserved.
//

import SwiftUI
import FirebaseCore
import UIKit
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
            SDNotificationModel.self,
            SDCategoryModel.self,
            SDChatMessageModel.self,
        ])
    }

    init() {
        Logger.print(URL.applicationSupportDirectory.path(percentEncoded: false))
        let fileManagerPath = try? FileManager.default.url(for: .documentDirectory,
                                                           in: .userDomainMask,
                                                           appropriateFor: nil,
                                                           create: true)
        Logger.print(fileManagerPath ?? "FileManager path not found")
    }
}
