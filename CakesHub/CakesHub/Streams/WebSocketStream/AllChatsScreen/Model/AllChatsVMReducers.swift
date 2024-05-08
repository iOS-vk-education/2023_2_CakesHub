//
//
//  AllChatsVMReducers.swift
//  CakesHub
//
//  Created by Dmitriy Permyakov on 08.05.2024.
//  Copyright 2024 © VK Team CakesHub. All rights reserved.
//

import SwiftData

extension AllChatsViewModel {

    struct Reducers: ClearConfigurationProtocol {
        var modelContext: ModelContext!
        var root: RootViewModel!

        static let clear = Reducers()
    }
}
