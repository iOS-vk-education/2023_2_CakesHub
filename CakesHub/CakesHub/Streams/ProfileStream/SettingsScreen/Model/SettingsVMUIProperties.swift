//
//  SettingsVMUIProperties.swift
//  CakesHub
//
//  Created by Dmitriy Permyakov on 14.05.2024.
//  Copyright 2024 © VKxBMSTU Team CakesHub. All rights reserved.
//

import Foundation

extension SettingsViewModel {

    struct UIProperties: ClearConfigurationProtocol {
        enum Screen {
            case updatePassword
            case updateEmail
        }

        var showAlert: Bool = false
        var selectedScreen: Screen?
        var openSheet: Bool = false

        static let clear = UIProperties()
    }
}
