//
//  VMInputProductModel.swift
//  CakesHub
//
//  Created by Dmitriy Permyakov on 15.04.2024.
//

import UIKit

extension CreateProductViewModel {

    struct VMInputProductModel: ClearConfigurationProtocol {
        var productName            : String = .clear
        var productDescription     : String = .clear
        var productPrice           : String = .clear
        var productDiscountedPrice : String? = nil
        var productImages          : Set<UIImage> = []

        static let clear = VMInputProductModel()
    }
}
