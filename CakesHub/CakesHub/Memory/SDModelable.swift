//
//  SDModelable.swift
//  CakesHub
//
//  Created by Dmitriy Permyakov on 19.04.2024.
//

import Foundation
import SwiftData

/// Протокол для `SwiftData` моделей
protocol SDModelable: PersistentModel {
    associatedtype FBModelType: FBModelable
}

extension SDModelable {
    init?(fbModel: FBModelType) { nil }
}
