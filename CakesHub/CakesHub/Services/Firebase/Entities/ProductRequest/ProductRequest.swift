//
//  ProductRequest.swift
//  CakesHub
//
//  Created by Dmitriy Permyakov on 02.03.2024.
//  Copyright 2024 © VK Team CakesHub. All rights reserved.
//

import SwiftUI

struct ProductRequest: DictionaryConvertible, ClearConfigurationProtocol {
    /// ID firebase документа
    var documentID: String = .clear
    /// Картинки товара
    var images: ImageKindRequest = .clear
    /// Фильтры торта
    var pickers: [String] = []
    /// Название торта
    var productName: String = .clear
    /// Цена торта
    var price: String = .clear
    /// Цена торта со скидкой
    var discountedPrice: String?
    /// Вес торта
    var weight: String?
    /// Имя продовца
    var seller: UserRequest = .clear
    /// Описание товара
    var description: String = .clear
    /// Схожие товары
    var similarProducts: [String] = []
    /// Дата создания товара
    var establishmentDate: String = .clear
    /// Оценки товара
    var reviewInfo: ProductReviewsRequest = .clear

    static let clear = ProductRequest()
}

// MARK: - DictionaryConvertible

extension ProductRequest {

    init(dictionary: [String: Any]) {
        var images: ProductRequest.ImageKindRequest?
        if let imagesDictionary = dictionary["images"] as? [String: Any] {
            images = ProductRequest.ImageKindRequest(dictionary: imagesDictionary)
        }
        let pickers = dictionary["pickers"] as? [String] ?? []
        let productName = dictionary["productName"] as? String ?? .clear
        let price = dictionary["price"] as? String ?? .clear
        let discountedPrice = dictionary["discountedPrice"] as? String
        let weight = dictionary["weight"] as? String
        var user: UserRequest?
        if let sellerDict = dictionary["seller"] as? [String: Any] {
            user = UserRequest(dictionary: sellerDict)
        }
        let description = dictionary["description"] as? String ?? .clear
        let similarProducts = dictionary["similarProducts"] as? [String] ?? []
        let establishmentDate = dictionary["establishmentDate"] as? String ?? .clear
        var reviewInfo: ProductReviewsRequest?
        if let reviewInfoDict = dictionary["reviewInfo"] as? [String: Any] {
            reviewInfo = ProductReviewsRequest(dictionary: reviewInfoDict)
        }

        self.init(
            images: images ?? .clear,
            pickers: pickers,
            productName: productName,
            price: price,
            discountedPrice: discountedPrice,
            weight: weight,
            seller: user ?? .clear,
            description: description,
            similarProducts: similarProducts,
            establishmentDate: establishmentDate,
            reviewInfo: reviewInfo ?? .clear
        )
    }
}

// MARK: - Mapper

extension ProductRequest {

    var mapperToProductModel: ProductModel {
        var productImages: [ProductModel.ProductImage] {
            switch images {
            case let .url(urls):
                return urls.map { .init(kind: .url($0)) }
            case let .images(images):
                return images.map { .init(kind: .uiImage($0)) }
            case let .strings(strings):
                return strings.map { .init(kind: .url(URL(string: $0))) }
            case .clear:
                return []
            }
        }
        
        // Ставим флажок, если объявлению меньше 8 дней
        let isNew = {
            // Получаем разницу нынешней даты и даты создания объявления
            guard let dif = Calendar.current.dateComponents(
                [.day],
                from: establishmentDate.toDate,
                to: Date.now
            ).day else { return false }

            // Если разница ниже 8, объявление считается новым
            return dif < 8
        }()

        // Проставляем `badgeText` в зависимости от данных по продукту
        let badgeText: String
        if let salePrice = Int(discountedPrice ?? .clear), let oldPrice = Int(price) {
            let floatOldePrice = CGFloat(oldPrice)
            let floatSalePrice = CGFloat(salePrice)
            let sale = (floatOldePrice - floatSalePrice) / floatOldePrice * 100
            badgeText = "-\(Int(sale.rounded(toPlaces: 0)))%"
        } else if isNew {
            badgeText = "NEW"
        } else {
            badgeText = .clear
        }

        return ProductModel(
            id: documentID,
            images: productImages,
            badgeText: badgeText,
            isFavorite: false,
            isNew: isNew,
            pickers: pickers,
            seller: seller.mapper,
            productName: productName,
            price: price,
            discountedPrice: discountedPrice,
            description: description,
            reviewInfo: reviewInfo.mapper,
            establishmentDate: establishmentDate,
            similarProducts: []
        )
    }
}

extension [ProductRequest] {

    var mapperToProductModel: [ProductModel] {
        map { $0.mapperToProductModel }
    }
}
