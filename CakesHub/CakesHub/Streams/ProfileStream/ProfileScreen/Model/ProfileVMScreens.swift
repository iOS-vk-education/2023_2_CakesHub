//
//
//  ProfileVMScreens.swift
//  CakesHub
//
//  Created by Dmitriy Permyakov on 10.05.2024.
//  Copyright 2024 © VK Team CakesHub. All rights reserved.
//

import Foundation

extension ProfileViewModel {

    enum Screens: Hashable {
        case message([ChatMessage])
        case location
        case settings
        case createProduct
    }
}
