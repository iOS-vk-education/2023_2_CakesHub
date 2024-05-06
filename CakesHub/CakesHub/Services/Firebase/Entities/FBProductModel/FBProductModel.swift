//
//  ProductRequest.swift
//  CakesHub
//
//  Created by Dmitriy Permyakov on 02.03.2024.
//  Copyright 2024 © VK Team CakesHub. All rights reserved.
//

import SwiftUI

struct FBProductModel: FBModelable {
    /// ID firebase документа
    var documentID: String
    /// Картинки товара
    var images: FBImageKind
    /// Категории торта
    var categories: [String]
    /// Название торта
    var productName: String
    /// Цена торта
    var price: String
    /// Цена торта со скидкой
    var discountedPrice: String?
    /// Вес торта
    var weight: String?
    /// Имя продовца
    var seller: FBUserModel
    /// Описание товара
    var description: String
    /// Схожие товары
    var similarProducts: [FBProductModel]
    /// Дата создания товара
    var establishmentDate: String
    /// Оценки товара
    var reviewInfo: FBProductReviewsModel

    static let clear = FBProductModel(
        documentID: .clear,
        images: .clear,
        categories: [],
        productName: .clear,
        price: .clear,
        seller: .clear,
        description: .clear,
        similarProducts: [],
        establishmentDate: .clear,
        reviewInfo: .clear
    )
}

// MARK: - DictionaryConvertible

extension FBProductModel {

    init?(dictionary: [String: Any]) {
        guard let documentID = dictionary["documentID"] as? String else { return nil }
        var images: FBProductModel.FBImageKind?
        if let imagesDictionary = dictionary["images"] as? [String: Any] {
            images = FBProductModel.FBImageKind(dictionary: imagesDictionary)
        }
        let categories = dictionary["categories"] as? [String] ?? []
        let productName = dictionary["productName"] as? String ?? .clear
        let price = dictionary["price"] as? String ?? .clear
        let discountedPrice = dictionary["discountedPrice"] as? String
        let weight = dictionary["weight"] as? String
        var user: FBUserModel?
        if let sellerDict = dictionary["seller"] as? [String: Any] {
            user = FBUserModel(dictionary: sellerDict)
        }
        let description = dictionary["description"] as? String ?? .clear
        let similarProducts = dictionary["similarProducts"] as? [FBProductModel] ?? []
        let establishmentDate = dictionary["establishmentDate"] as? String ?? .clear
        var reviewInfo: FBProductReviewsModel?
        if let reviewInfoDict = dictionary["reviewInfo"] as? [String: Any] {
            reviewInfo = FBProductReviewsModel(dictionary: reviewInfoDict)
        }

        self.init(
            documentID: documentID,
            images: images ?? .clear,
            categories: categories,
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

// MARK: - Computed Values

extension FBProductModel {

    var isNew: Bool {
        // Получаем разницу нынешней даты и даты создания объявления
        guard let dif = Calendar.current.dateComponents(
            [.day],
            from: establishmentDate.toDate,
            to: Date.now
        ).day else { return false }

        // Если разница ниже 8, объявление считается новым
        return dif < 8
    }

    var badgeText: String {
        if let salePrice = Int(discountedPrice ?? .clear), let oldPrice = Int(price) {
            let floatOldePrice = CGFloat(oldPrice)
            let floatSalePrice = CGFloat(salePrice)
            let sale = (floatOldePrice - floatSalePrice) / floatOldePrice * 100
            return "-\(Int(sale.rounded(toPlaces: 0)))%"
        } else if isNew {
            return "NEW"
        } else {
            return .clear
        }
    }
}

// MARK: - Mapper

extension FBProductModel {

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
        var discountedPriceString: String? {
            guard let price = discountedPrice else { return nil }
            return "$\(price)"
        }

        return ProductModel(
            id: documentID,
            images: productImages,
            badgeText: badgeText,
            isFavorite: false,
            isNew: isNew,
            categories: categories,
            seller: seller.mapper,
            productName: productName,
            price: "$\(price)",
            discountedPrice: discountedPriceString,
            description: description,
            reviewInfo: reviewInfo.mapper,
            establishmentDate: establishmentDate,
            similarProducts: similarProducts.mapperToProductModel
        )
    }
}

extension [FBProductModel] {

    var mapperToProductModel: [ProductModel] {
        map { $0.mapperToProductModel }
    }
}

// MARK: - Equatable

extension FBProductModel: Equatable {

    static func == (lhs: FBProductModel, rhs: FBProductModel) -> Bool {
        lhs.documentID        == rhs.documentID &&
        lhs.images            == rhs.images &&
        lhs.categories        == rhs.categories &&
        lhs.productName       == rhs.productName &&
        lhs.price             == rhs.price &&
        lhs.discountedPrice   == rhs.discountedPrice &&
        lhs.weight            == rhs.weight &&
        lhs.seller            == rhs.seller &&
        lhs.description       == rhs.description &&
        lhs.establishmentDate == rhs.establishmentDate &&
        lhs.reviewInfo        == rhs.reviewInfo
    }
}
