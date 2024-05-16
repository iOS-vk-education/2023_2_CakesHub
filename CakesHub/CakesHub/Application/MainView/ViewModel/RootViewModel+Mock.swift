//
//  RootViewModel+Mock.swift
//  CakesHub
//
//  Created by Dmitriy Permyakov on 16.04.2024.
//  Copyright 2024 © VK Team CakesHub. All rights reserved.
//

import Foundation

#if DEBUG
extension RootViewModel: Mockable {

    static let mockData = RootViewModel(
        productsData: ProductsData(
            sections: [
                .sales(.mockSalesData),
                .news(.mockNewsData),
                .all(.mockAllData),
            ],
            currentUserProducts: .mockData
        ),
        currentUser: .poly
    )
}
#endif
