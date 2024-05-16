//
//  SettingsVMReducers.swift
//  CakesHub
//
//  Created by Dmitriy Permyakov on 14.05.2024.
//  Copyright 2024 © VKxBMSTU Team CakesHub. All rights reserved.
//

import Foundation
import SwiftData

extension SettingsViewModel {

    struct Reducers: ClearConfigurationProtocol {
        var nav: Navigation!
        var modelContext: ModelContext!
        var root: RootViewModel!

        static let clear = Reducers()
    }
}
