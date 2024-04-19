//
//  FBModelable.swift
//  CakesHub
//
//  Created by Dmitriy Permyakov on 19.04.2024.
//

import Foundation

/// Протокол для `FireBase` моделей
protocol FBModelable: DictionaryConvertible, ClearConfigurationProtocol {}
