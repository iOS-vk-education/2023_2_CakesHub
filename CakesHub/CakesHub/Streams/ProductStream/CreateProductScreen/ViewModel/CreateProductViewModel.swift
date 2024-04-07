//
//  CreateProductViewModel.swift
//  CakesHub
//
//  Created by Dmitriy Permyakov on 05.04.2024.
//  Copyright 2024 © VKxBMSTU Team CakesHub. All rights reserved.
//

import Foundation

// MARK: - CreateProductViewModelProtocol

protocol CreateProductViewModelProtocol: AnyObject {}

// MARK: - CreateProductViewModel

final class CreateProductViewModel: ObservableObject, ViewModelProtocol {

    @Published var productName: String
    @Published var productDescription: String
    @Published var productPrice: String
    @Published var productDiscountedPrice: String
    @Published var productImages: [Data]

    init() {
        self.productName = UserDefaults.standard.value(forKey: Keys.productName) as? String ?? .clear
        self.productDescription = UserDefaults.standard.value(forKey: Keys.productDescription) as? String ?? .clear
        self.productPrice = UserDefaults.standard.value(forKey: Keys.productPrice) as? String ?? .clear
        self.productDiscountedPrice = UserDefaults.standard.value(forKey: Keys.productDiscountedPrice) as? String ?? .clear
        self.productImages = []
    }
}

// MARK: - UserDefaultsKeys

extension CreateProductViewModel {

    enum Keys {
        static let currentPage = "com.vk.CreateProductViewModel.currentPage"
        static let productName = "com.vk.CreateProductViewModel.cakeName"
        static let productDescription = "com.vk.CreateProductViewModel.cakeDescription"
        static let productPrice = "com.vk.CreateProductViewModel.cakePrice"
        static let productDiscountedPrice = "com.vk.CreateProductViewModel.cakeDiscountedPrice"
    }
}

// MARK: - Actions

extension CreateProductViewModel: CreateProductViewModelProtocol {}
