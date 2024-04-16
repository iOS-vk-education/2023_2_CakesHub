//
//  RootViewModel+Mock.swift
//  CakesHub
//
//  Created by Dmitriy Permyakov on 16.04.2024.
//

import Foundation

#if DEBUG
extension RootViewModel: Mockable {

    static let mockData = RootViewModel(
        productsData: ProductsData(products: .mockProducts),
        currentUser: .king
    )
}
#endif
