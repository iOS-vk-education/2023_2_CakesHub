//
//
//  AllChatsUIProperties.swift
//  CakesHub
//
//  Created by Dmitriy Permyakov on 08.05.2024.
//  Copyright 2024 © VK Team CakesHub. All rights reserved.
//

import Foundation

extension AllChatsViewModel {

    struct UIProperties: ClearConfigurationProtocol {
        var searchText: String = .clear

        static let clear = UIProperties()
    }
}
