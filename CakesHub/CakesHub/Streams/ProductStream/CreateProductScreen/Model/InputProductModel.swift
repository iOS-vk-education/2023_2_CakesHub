//
//  InputProductModel.swift
//  CakesHub
//
//  Created by Dmitriy Permyakov on 15.04.2024.
//

import Foundation

struct InputProductModel: ClearConfigurationProtocol {
    var productName            : String = .clear
    var productDescription     : String = .clear
    var productPrice           : String = .clear
    var productDiscountedPrice : String = .clear
    var productImages          : [Data] = []

    static let clear = InputProductModel()
}
