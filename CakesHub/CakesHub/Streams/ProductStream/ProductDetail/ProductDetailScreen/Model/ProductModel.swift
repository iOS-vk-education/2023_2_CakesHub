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
    /// Флаг нравится
    var isFavorite: Bool = false
    /// Фильтры торта
    var pickers: [String] = []
    /// Название торта
    var productName: String = .clear
    /// Цена торта
    var price: String = .clear
    /// Старая цена торта
    var oldPrice: String?
    /// Имя продовца
    var sellerName: String = .clear
    /// Описание товара
    var description: String = .clear
    /// Оценки товара
    var reviewInfo: ProductReviewsModel = .clear
    /// Схожие товары
    var similarProducts: [SimilarCard] = []
}

extension ProductModel {

    struct ProductImage: Identifiable {
        let id = UUID()
        var kind: ImageKind
    }

    struct SimilarCard: Identifiable {
        let id = UUID()
        var configuration: CHMNewProductCard.Configuration = .clear
    }

    var starsCount: Int {
        Int(reviewInfo.averageRating.rounded())
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
