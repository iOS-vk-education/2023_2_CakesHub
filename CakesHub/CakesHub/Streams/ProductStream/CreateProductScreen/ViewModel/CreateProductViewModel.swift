//
//  CreateProductViewModel.swift
//  CakesHub
//
//  Created by Dmitriy Permyakov on 05.04.2024.
//  Copyright 2024 © VKxBMSTU Team CakesHub. All rights reserved.
//

import UIKit
import Observation

// MARK: - CreateProductViewModelProtocol

protocol CreateProductViewModelProtocol: AnyObject {
    func saveSelectedImages(imagesData: [Data])
    func didTapCreateProductButton()
    func didTapDeleteProductButton()
}

// MARK: - CreateProductViewModel

final class CreateProductViewModel: ObservableObject, ViewModelProtocol {

    private(set) var rootViewModel: RootViewModel
    private(set) var profileViewModel: ProfileViewModel
    @Published var inputProductData: InputProductModel
    let totalCount = 3

    init(rootViewModel: RootViewModel = RootViewModel(), profileViewModel: ProfileViewModel = ProfileViewModel()) {
        self.rootViewModel = rootViewModel
        self.profileViewModel = profileViewModel

        let productName = UserDefaults.standard.value(forKey: Keys.productName) as? String ?? .clear
        let productDescription = UserDefaults.standard.value(forKey: Keys.productDescription) as? String ?? .clear
        let productPrice = UserDefaults.standard.value(forKey: Keys.productPrice) as? String ?? .clear
        let productDiscountedPrice = UserDefaults.standard.value(forKey: Keys.productDiscountedPrice) as? String ?? .clear
        let productImages = UserDefaults.standard.array(forKey: Keys.productImages) as? [Data] ?? []

        self.inputProductData = InputProductModel(
            productName: productName,
            productDescription: productDescription,
            productPrice: productPrice,
            productDiscountedPrice: productDiscountedPrice,
            productImages: productImages
        )
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
        static let productImages = "com.vk.CreateProductViewModel.cakeImages"
    }
}

// MARK: - Actions

extension CreateProductViewModel: CreateProductViewModelProtocol {

    func saveSelectedImages(imagesData: [Data]) {
        inputProductData.productImages = imagesData
        UserDefaults.standard.set(imagesData, forKey: Keys.productImages)
    }
    
    /// Нажали кнопку `создать`
    func didTapCreateProductButton() {
        // Создаём локальную карточку продукта
        let newProduct = configurationProductModel()
        rootViewModel.addNewProduct(product: newProduct)
        profileViewModel.updateUserProducts(products: rootViewModel.productData.currentUserProducts)

        // Отправляем запрос в сеть
        // TODO: Добавить запрос ...


        // Сброс введённых данных
        resetUserDefaults()
        resetValues()
    }

    /// Нажали кнопку `удалить`
    func didTapDeleteProductButton() {
        resetUserDefaults()
        resetValues()
    }
}

// MARK: - Inner Methods

private extension CreateProductViewModel {

    func configurationProductModel() -> ProductModel {
        let images: [ProductModel.ProductImage] = inputProductData.productImages.map { .init(kind: .uiImage(UIImage(data: $0))) }
        let badgeText: String
        if let salePrice = Int(inputProductData.productDiscountedPrice), let oldPrice = Int(inputProductData.productPrice) {
            let floatOldePrice = CGFloat(oldPrice)
            let floatSalePrice = CGFloat(salePrice)
            let sale = (floatOldePrice - floatSalePrice) / floatOldePrice * 100
            badgeText = "-\(Int(sale.rounded(toPlaces: 0)))%"
        } else {
            badgeText = "NEW"
        }

        let newProduct = ProductModel(
            id: UUID().uuidString,
            images: images,
            badgeText: badgeText,
            isFavorite: false,
            isNew: true,
            pickers: [], // TODO: iOS-13: Добавить экран с выбором пикеров
            seller: rootViewModel.currentUser,
            productName: inputProductData.productName,
            price: "$\(inputProductData.productPrice)",
            discountedPrice: inputProductData.productDiscountedPrice.isEmpty ? nil : "$\(inputProductData.productDiscountedPrice)",
            description: inputProductData.productDescription,
            establishmentDate: Date.now.formattedString(format: "yyyy-MM-dd HH:mm:ss"),
            similarProducts: []
        )

        return newProduct
    }

    func resetUserDefaults() {
        UserDefaults.standard.removeObject(forKey: Keys.currentPage)
        UserDefaults.standard.removeObject(forKey: Keys.productName)
        UserDefaults.standard.removeObject(forKey: Keys.productDescription)
        UserDefaults.standard.removeObject(forKey: Keys.productPrice)
        UserDefaults.standard.removeObject(forKey: Keys.productDiscountedPrice)
        UserDefaults.standard.removeObject(forKey: Keys.productImages)
    }

    func resetValues() {
        inputProductData = .clear
    }
}
