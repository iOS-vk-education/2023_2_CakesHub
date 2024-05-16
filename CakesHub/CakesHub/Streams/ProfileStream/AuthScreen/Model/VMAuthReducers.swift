//
//
//  VMAuthReducers.swift
//  CakesHub
//
//  Created by Dmitriy Permyakov on 14.05.2024.
//  Copyright 2024 © VK Team CakesHub. All rights reserved.
//

import SwiftData

extension AuthViewModel {

    struct Reducers: ClearConfigurationProtocol {
        var context: ModelContext!
        var rootViewModel: RootViewModel!

        static let clear = Reducers()
    }
}
