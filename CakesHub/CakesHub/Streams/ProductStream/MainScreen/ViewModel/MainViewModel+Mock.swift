//
//  MainViewModel+Mock.swift
//  CakesHub
//
//  Created by Dmitriy Permyakov on 05.02.2024.
//  Copyright 2024 © VK Team CakesHub. All rights reserved.
//

import SwiftUI
import UIKit

#if DEBUG

extension MainViewModel: Mockable {

    static let mockData = MainViewModel()
}

// MARK: - Mock Data

extension CHMBigBannerView.Configuration: Mockable {

    static let mockData = CHMBigBannerView.Configuration.basic(
        imageKind: .image(Image("Big Banner")),
        bannerTitle: "Fashion\nsale",
        buttonTitle: "Check"
    )
}

extension [ProductModel] {

    static let mockNewsData: [ProductModel] = (0...20).map {
        ProductModel(
            productID: $0,
            images: [
                .init(kind: .image(Image("cake"))),
                .init(kind: .url(.mockCake2)),
                .init(kind: .url(.mockCake3)),
                .init(kind: .url(.mockCake4)),
            ],
            badgeText: "NEW",
            isFavorite: true,
            pickers: .pickers,
            productName: .productName,
            price: "$\($0).99",
            sellerName: .sellerName,
            description: .previewDescription,
            reviewInfo: .mockData,
            similarProducts: .similarProducts
        )
    }

    static let mockSalesData: [ProductModel] = (0...20).map {
        ProductModel(
            productID: $0,
            images: [
                .init(kind: .image(Image("cake"))),
                .init(kind: .url(.mockCake2)),
                .init(kind: .url(.mockCake3)),
                .init(kind: .url(.mockCake4)),
            ],
            badgeText: "-\($0)%",
            isFavorite: true,
            pickers: .pickers,
            productName: .productName,
            price: "$\($0).99",
            oldPrice: "$\($0 + 10).99",
            sellerName: .sellerName,
            description: .previewDescription,
            reviewInfo: .mockData,
            similarProducts: .similarProducts
        )
    }

    static let mockAllData: [ProductModel] = (0...20).map {
        ProductModel(
            productID: $0,
            images: [
                .init(kind: .url(.mockProductCard)),
                .init(kind: .url(.mockCake2)),
                .init(kind: .url(.mockCake3)),
                .init(kind: .url(.mockCake4)),
            ],
            isFavorite: true,
            pickers: .pickers,
            productName: .productName,
            price: "$\($0).99",
            sellerName: .sellerName,
            description: .previewDescription,
            reviewInfo: .mockData,
            similarProducts: .similarProducts
        )
    }

    static let similarProducts: [ProductModel] = (1...20).map {
        ProductModel(
            productID: $0,
            images: [
                .init(kind: .image(.mockImageCake)),
                .init(kind: .url(.mockCake3)),
                .init(kind: .url(.mockProductCard)),
                .init(kind: .url(.mockCake4)),
            ],
            isFavorite: true,
            pickers: .pickers,
            productName: .productName,
            price: .price,
            sellerName: .sellerName,
            description: .previewDescription,
            reviewInfo: .mockData,
            similarProducts: []
        )
    }
}

// MARK: - Constants

private extension String {

    static let productName = "H&M"
    static let price = "$19.99"
    static let sellerName = "Short black dress"
    static let previewDescription = """
    Short dress in soft cotton jersey with decorative buttons down the front and a wide, frill-trimmed square neckline with concealed elastication. Elasticated seam under the bust and short puff sleeves with a small frill trim.
    """
}

private extension [String] {

    static let pickers = ["Size", "Color"]
}

#endif
