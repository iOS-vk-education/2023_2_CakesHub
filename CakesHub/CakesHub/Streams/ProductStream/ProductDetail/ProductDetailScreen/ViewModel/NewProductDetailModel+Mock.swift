//
//  NewProductDetailModel+Mock.swift
//  CakesHub
//
//  Created by Dmitriy Permyakov on 04.02.2024.
//  Copyright 2024 © VK Team CakesHub. All rights reserved.
//

import Foundation

#if DEBUG

extension ProductDetailScreen.ViewModel: Mockable {

    static let mockData = ProductDetailScreen.ViewModel(data: .mockData)
}

extension ProductModel: Mockable {

    static let mockData = ProductModel(
        productID: 0,
        images: [
            .init(kind: .url(.mockProductCard)),
            .init(kind: .url(.mockCake2)),
            .init(kind: .url(.mockCake3)),
            .init(kind: .url(.mockCake4)),
        ],
        isFavorite: true,
        pickers: Constants.pickers,
        productName: Constants.productName,
        price: Constants.price,
        sellerName: Constants.sellerName,
        description: Constants.previewDescription,
        reviewInfo: .mockData,
        similarProducts: .similarProducts
    )

    static func emptyCards(id: Int) -> Self {
        ProductModel(productID: id)
    }
}

// MARK: - CHMNewProductCard Configuration

private extension CHMNewProductCard.Configuration {

    static let previewSimilarCard = CHMNewProductCard.Configuration.basic(
        imageKind: .url(.mockProductCard),
        imageHeight: 184,
        productText: .init(
            seller: "Mango Boy",
            productName: "T-Shirt Sailing",
            productPrice: "10$"
        ),
        productButtonConfiguration: .basic(kind: .favorite()),
        starsViewConfiguration: .basic(kind: .four, feedbackCount: 8)
    )
}

// MARK: - Constants

private extension ProductModel {

    enum Constants {
        static let productName = "H&M"
        static let price = "$19.99"
        static let sellerName = "Short black dress"
        static let previewDescription = """
        Short dress in soft cotton jersey with decorative buttons down the front and a wide, frill-trimmed square neckline with concealed elastication. Elasticated seam under the bust and short puff sleeves with a small frill trim.
        """
        static let pickers = ["Size", "Color"]
    }
}

#endif
