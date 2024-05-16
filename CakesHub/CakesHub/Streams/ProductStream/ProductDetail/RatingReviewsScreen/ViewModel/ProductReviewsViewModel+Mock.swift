//
//
//  ProductReviewsViewModel+Mock.swift
//  CakesHub
//
//  Created by Dmitriy Permyakov on 12.05.2024.
//  Copyright 2024 © VK Team CakesHub. All rights reserved.
//

import Foundation

#if DEBUG
extension ProductReviewsViewModel: Mockable {

    static let mockData = ProductReviewsViewModel(data: .mockData, productID: "1")
}
#endif
