//
//  ProductModel.swift
//  CakesHub
//
//  Created by Dmitriy Permyakov on 04.02.2024.
//  Copyright 2024 © VK Team CakesHub. All rights reserved.
//

import SwiftUI
import UIKit

struct ProductModel: Identifiable, Hashable {
    let id = UUID()
    /// ID с бэка
    var productID: Int
    /// Картинки товара
    var images: [ProductImage] = []
    /// Бейдж с информацией
    var badgeText: String = .clear
    /// Флаг если товар нравится
    var isFavorite: Bool = false
    /// Флаг если товар новый
    var isNew: Bool = false
    /// Фильтры торта
    var pickers: [String] = []
    /// Информация об продавце
    var seller: SellerInfo = .clear
    /// Название торта
    var productName: String = .clear
    /// Цена торта
    var price: String = .clear
    /// Старая цена торта
    var oldPrice: String?
    /// Описание товара
    var description: String = .clear
    /// Оценки товара
    var reviewInfo: ProductReviewsModel = .clear
    /// Дата создания товара
    var establishmentDate: String = .clear
    /// Схожие товары
    var similarProducts: [ProductModel] = []
}

extension ProductModel {

    struct ProductImage: Identifiable {
        let id = UUID()
        var kind: ImageKind
    }

    struct SellerInfo: Hashable {
        var id: String = .clear
        var name: String = .clear
        var surname: String = .clear
        var mail: String = .clear
        var userImage: ImageKind = .clear
        var userHeaderImage: ImageKind = .clear

        static let clear = SellerInfo()
    }

    var starsCount: Int {
        Int(reviewInfo.averageRating.rounded())
    }
}

// MARK: - Mapper

extension ProductModel {

    func mapperToProductCardConfiguration(
        height: CGFloat,
        badgeConfiguration: CHMBadgeView.Configuration
    ) -> CHMNewProductCard.Configuration {
        .basic(
            imageKind: images.first?.kind ?? .clear,
            imageHeight: height,
            productText: .init(
                seller: seller.name,
                productName: productName,
                productPrice: price,
                productOldPrice: oldPrice
            ),
            badgeViewConfiguration: badgeConfiguration,
            productButtonConfiguration: .basic(
                kind: .favorite(isSelected: isFavorite)
            ),
            starsViewConfiguration: .basic(
                kind: .init(rawValue: starsCount) ?? .zero,
                feedbackCount: reviewInfo.feedbackCounter
            )
        )
    }

    func mapperToProductCardConfiguration(
        height: CGFloat
    ) -> CHMNewProductCard.Configuration {
        .basic(
            imageKind: images.first?.kind ?? .clear,
            imageHeight: height,
            productText: .init(
                seller: seller.name,
                productName: productName,
                productPrice: price,
                productOldPrice: oldPrice
            ),
            badgeViewConfiguration: calculatedBadgeConfiguration,
            productButtonConfiguration: .basic(
                kind: .favorite(isSelected: isFavorite)
            ),
            starsViewConfiguration: .basic(
                kind: .init(rawValue: starsCount) ?? .zero,
                feedbackCount: reviewInfo.feedbackCounter
            )
        )
    }

    private var calculatedBadgeConfiguration: CHMBadgeView.Configuration {
        if !oldPrice.isNil {
            return .basic(text: badgeText, kind: .red)
        } else if isNew {
            return .basic(text: badgeText, kind: .dark)
        }
        return .clear
    }
}

extension ProductModel.SellerInfo {

    func mapper(products: [ProductModel]) -> UserModel {
        .init(
            id: id,
            name: name,
            surname: surname,
            mail: mail,
            orders: products.count,
            userImage: userImage,
            userHeaderImage: userHeaderImage,
            products: products
        )
    }
}

// MARK: - Hasher

extension ProductModel {

    static func == (lhs: ProductModel, rhs: ProductModel) -> Bool {
        lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
