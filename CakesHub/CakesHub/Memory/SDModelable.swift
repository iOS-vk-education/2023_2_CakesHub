//
//  SDModelable.swift
//  CakesHub
//
//  Created by Dmitriy Permyakov on 19.04.2024.
//  Copyright 2024 © VK Team CakesHub. All rights reserved.
//

import Foundation
import SwiftData

/// Протокол для `SwiftData` моделей
protocol SDModelable: PersistentModel {
    associatedtype FBModelType: FBModelable

    var mapper: FBModelType { get }
}

extension SDModelable {
    init?(fbModel: FBModelType) { nil }
}
