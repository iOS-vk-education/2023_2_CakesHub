//
//  FBModelable.swift
//  CakesHub
//
//  Created by Dmitriy Permyakov on 19.04.2024.
//  Copyright 2024 © VK Team CakesHub. All rights reserved.
//

import Foundation

/// Протокол для `FireBase` моделей
protocol FBModelable: DictionaryConvertible, ClearConfigurationProtocol {}
