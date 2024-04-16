//
//  VMRootProduct.swift
//  CakesHub
//
//  Created by Dmitriy Permyakov on 16.04.2024.
//

import Foundation

extension RootViewModel {

    struct ProductsData: ClearConfigurationProtocol {
        var products: [ProductModel] = []
        var sections: [Section] = []
        var currentUserProducts: [ProductModel] = []

        static let clear = ProductsData()
    }
}
