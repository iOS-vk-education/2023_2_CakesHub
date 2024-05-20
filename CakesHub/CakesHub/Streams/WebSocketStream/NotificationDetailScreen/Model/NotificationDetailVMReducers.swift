//
//  NotificationDetailVMReducers.swift
//  CakesHub
//
//  Created by Dmitriy Permyakov on 17.05.2024.
//  Copyright 2024 © VKxBMSTU Team CakesHub. All rights reserved.
//

import SwiftData

extension NotificationDetailViewModel {

    struct Reducers: ClearConfigurationProtocol {
        var nav: Navigation!
        var root: RootViewModel!
        var modelContext: ModelContext!

        static let clear = Reducers()
    }
}
