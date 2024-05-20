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
        var showAlert: Bool = false

        static let clear = UIProperties()
    }
}
