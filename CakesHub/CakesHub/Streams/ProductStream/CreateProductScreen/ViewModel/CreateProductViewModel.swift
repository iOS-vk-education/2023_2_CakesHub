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
    private let cakeService: CakeServiceProtocol
    @Published var inputProductData: InputProductModel
    let totalCount = 3

    init(
        rootViewModel: RootViewModel = RootViewModel(),
        profileViewModel: ProfileViewModel = ProfileViewModel(),
        cakeService: CakeServiceProtocol = CakeService.shared,
        inputProductData: InputProductModel = .clear
    ) {
        self.rootViewModel = rootViewModel
        self.profileViewModel = profileViewModel
        self.cakeService = cakeService

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
        let newProduct = configurationProductModel
        rootViewModel.addNewProduct(product: newProduct)
        profileViewModel.updateUserProducts(products: rootViewModel.productData.currentUserProducts.mapperToProductModel)

        // Отправляем запрос в сеть
        cakeService.createCake(cake: newProduct) { error in
            if let error { Logger.log(kind: .error, message: error) }
        }

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

    var configurationProductModel: FBProductModel {
        FBProductModel(
            documentID: UUID().uuidString,
            images: .images(inputProductData.productImages.compactMap { UIImage(data: $0) }),
            pickers: [], // TODO: iOS-18: Добавить экран с выбором пикеров
            productName: inputProductData.productName,
            price: inputProductData.productPrice,
            discountedPrice: inputProductData.productDiscountedPrice.isEmpty ? nil : "$\(inputProductData.productDiscountedPrice)",
            weight: nil,
            seller: rootViewModel.currentUser,
            description: inputProductData.productDescription,
            similarProducts: [],
            establishmentDate: Date.now.formattedString(format: "yyyy-MM-dd HH:mm:ss"),
            reviewInfo: .clear
        )
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
