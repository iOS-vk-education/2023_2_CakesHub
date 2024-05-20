//
//  ProductReviewsViewModel.swift
//  CakesHub
//
//  Created by Dmitriy Permyakov on 04.02.2024.
//  Copyright 2024 © VK Team CakesHub. All rights reserved.
//

import Foundation
import Observation

@Observable
final class ProductReviewsViewModel: ViewModelProtocol {
    var data: ProductReviewsModel
    var productID: String = .clear

    init(data: ProductReviewsModel, productID: String) {
        self.data = data
        self.productID = productID
    }

    func updateProductInfo(with info: ProductReviewsModel) {
        data = info
    }
}
