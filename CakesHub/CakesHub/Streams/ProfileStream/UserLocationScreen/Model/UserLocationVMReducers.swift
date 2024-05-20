//
//  UserLocationVMReducers.swift
//  CakesHub
//
//  Created by Dmitriy Permyakov on 13.05.2024.
//  Copyright 2024 © VKxBMSTU Team CakesHub. All rights reserved.
//

import Foundation
import SwiftData

extension UserLocationViewModel {

    struct Reducers: ClearConfigurationProtocol {
        var nav: Navigation!
        var root: RootViewModel!
        var modelContext: ModelContext!

        static let clear = Reducers()
    }
}
