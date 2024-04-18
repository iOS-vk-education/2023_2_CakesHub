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
    private let services: VMServices
    @Published var inputProductData: VMInputProductModel
    let totalCount = 3

    init(
        rootViewModel: RootViewModel = RootViewModel(),
        profileViewModel: ProfileViewModel = ProfileViewModel(),
        services: VMServices = VMServices(),
        inputProductData: VMInputProductModel = .clear
    ) {
        self.rootViewModel = rootViewModel
        self.profileViewModel = profileViewModel
        self.services = services

        let productName = UserDefaults.standard.value(forKey: Keys.productName) as? String ?? .clear
        let productDescription = UserDefaults.standard.value(forKey: Keys.productDescription) as? String ?? .clear
        let productPrice = UserDefaults.standard.value(forKey: Keys.productPrice) as? String ?? .clear
        let productDiscountedPrice = UserDefaults.standard.value(forKey: Keys.productDiscountedPrice) as? String
        let productImagesPaths = UserDefaults.standard.array(forKey: Keys.productImages) as? [String] ?? []
        let productImages: Set<UIImage> = Set(productImagesPaths.compactMap {
            services.fileManager.getImage(key: $0)
        })

        self.inputProductData = VMInputProductModel(
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
        var images: Set<UIImage> = []
        let imagePaths: [String] = imagesData.enumerated().compactMap { index, data in
            guard let uiImage = UIImage(data: data) else { return nil }
            images.insert(uiImage)
            let imagePathName: String = "created-image-\(index)"
            self.services.fileManager.saveImage(uiImage: uiImage, for: imagePathName)
            return imagePathName
        }
        self.inputProductData.productImages = images
        UserDefaults.standard.set(imagePaths, forKey: Keys.productImages)
    }
    
    /// Нажали кнопку `создать`
    func didTapCreateProductButton() {
        // Создаём локальную карточку продукта
        let newProduct = configurationProductModel
        rootViewModel.addNewProduct(product: newProduct)
        profileViewModel.updateUserProducts(products: rootViewModel.productData.currentUserProducts.mapperToProductModel)

        // Отправляем запрос в сеть
        services.cakeService.createCake(cake: newProduct) { error in
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
            images: .images(inputProductData.productImages.map { $0 }),
            pickers: [], // TODO: iOS-18: Добавить экран с выбором пикеров
            productName: inputProductData.productName,
            price: inputProductData.productPrice,
            discountedPrice: inputProductData.productDiscountedPrice,
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
        let productImagesPaths = UserDefaults.standard.array(forKey: Keys.productImages) as? [String] ?? []
        productImagesPaths.forEach { services.fileManager.deleteImage(by: $0) }
        UserDefaults.standard.removeObject(forKey: Keys.productImages)
    }

    func resetValues() {
        inputProductData = .clear
    }
}
