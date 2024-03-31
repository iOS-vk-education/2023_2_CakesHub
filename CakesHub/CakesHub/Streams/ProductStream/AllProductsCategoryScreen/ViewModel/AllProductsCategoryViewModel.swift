//
//  AllProductsCategoryViewModel.swift
//  CakesHub
//
//  Created by Dmitriy Permyakov on 31.03.2024.
//  Copyright 2024 © VKxBMSTU Team CakesHub. All rights reserved.
//

import Foundation

// MARK: - AllProductsCategoryViewModelProtocol

protocol AllProductsCategoryViewModelProtocol: AnyObject {}

// MARK: - AllProductsCategoryViewModel

final class AllProductsCategoryViewModel: ObservableObject, ViewModelProtocol {
    @Published private(set) var products: [ProductModel]

    init(products: [ProductModel] = []) {
        self.products = products
    }
}

// MARK: - Actions

extension AllProductsCategoryViewModel: AllProductsCategoryViewModelProtocol {}
