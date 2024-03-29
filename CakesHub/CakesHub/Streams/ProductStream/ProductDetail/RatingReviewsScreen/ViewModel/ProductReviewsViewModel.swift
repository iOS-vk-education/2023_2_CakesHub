//
//  ProductReviewsViewModel.swift
//  CakesHub
//
//  Created by Dmitriy Permyakov on 04.02.2024.
//  Copyright 2024 © VK Team CakesHub. All rights reserved.
//

import Foundation

protocol ProductReviewsViewModelProtocol: ViewModelProtocol {}

final class ProductReviewsViewModel: ViewModelProtocol {
    var data: ProductReviewsModel

    init(data: ProductReviewsModel) {
        self.data = data
    }
}

extension ProductReviewsViewModel: ProductReviewsViewModelProtocol {}
