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
        imageKind: .uiImage(UIImage(named: "Big Banner")),
        bannerTitle: "Fashion\nsale",
        buttonTitle: "Check"
    )
}

// MARK: - SellerInfo

extension ProductModel.SellerInfo {

    static let king = ProductModel.SellerInfo(
        id: "D4zfn3CLZjb0d2PWVPIFmGhptHr2",
        name: "mightyK1ngRichard",
        surname: "Permyakov",
        mail: "dimapermyakov55@gmail.com",
        userImage: .url(.mockKingImage),
        userHeaderImage: .url(.mockKingHeaderImage)
    )

    static let poly = ProductModel.SellerInfo(
        id: "6Y1qLJG5NihwnL4qsSJL5397LA93",
        name: "Полиночка",
        surname: "Копылова",
        mail: "kakashek@gmail.com",
        userImage: .uiImage(.bestGirl),
        userHeaderImage: .url(URL(string: "https://pibig.info/uploads/posts/2021-04/1619483895_8-pibig_info-p-anime-personazhi-blondinki-anime-krasivo-10.jpg"))
    )

    static let milana = ProductModel.SellerInfo(
        id: "3",
        name: "Milana",
        surname: "Shakhbieva",
        mail: "milana@gmail.com",
        userImage: .url(URL(string: "https://sun9-48.userapi.com/impg/oni-EvRr6V8PLK_FYzJ7_hlhoj0HhvTTHEWs4g/sVlbTZyHZZ0.jpg?size=1334x1786&quality=95&sign=a17e711df5bcfd6290be44002f9c3e6e&type=album")),
        userHeaderImage: .uiImage(.cake3)
    )
}

// MARK: - ProductModel

extension [ProductModel] {
    private static let saleImg = URL(string: "https://i2.wp.com/shokolad.today/wp-content/uploads/2019/11/ukrashenie-torta-konfetami-10.png")
    private static let newImg = URL(string: "https://grandgames.net/puzzle/f1200/cake_with_berries.jpg")
    private static let allImg = URL(string: "https://mykaleidoscope.ru/uploads/posts/2020-07/1594573707_11-p-trekhyarusnie-torti-vkontakte-14.jpg")
    static let swiftDataProduct: [ProductModel] = [
        .init(
            id: "0",
            images: [.init(kind: .url(saleImg))],
            badgeText: .clear,
            isFavorite: true,
            isNew: true,
            pickers: [],
            seller: .king,
            productName: "Скидочный торт",
            price: "100",
            discountedPrice: "50",
            description: "Описание скидочного торта",
            reviewInfo: .init(countFiveStars: 5),
            establishmentDate: "2024-11-11T01:32:01+0000",
            similarProducts: []
        ),
        .init(
            id: "1",
            images: [.init(kind: .url(newImg))],
            badgeText: "NEW",
            isFavorite: true,
            isNew: true,
            pickers: [],
            seller: .king,
            productName: "Новый торт",
            price: "500",
            discountedPrice: nil,
            description: "Описание нового торта",
            reviewInfo: .init(countFiveStars: 2),
            establishmentDate: "2024-04-17T01:32:01+0000",
            similarProducts: []
        ),
        .init(
            id: "3",
            images: [.init(kind: .url(allImg))],
            badgeText: .clear,
            isFavorite: true,
            isNew: false,
            pickers: [],
            seller: .king,
            productName: "Все торт",
            price: "100",
            discountedPrice: nil,
            description: "Описание все торта",
            reviewInfo: .init(countFiveStars: 3),
            establishmentDate: "2023-11-11T01:32:01+0000",
            similarProducts: []
        ),
    ]

    static let mockProducts = [
        [ProductModel].mockAllData,
        [ProductModel].mockNewsData,
        [ProductModel].mockSalesData,
        [ProductModel].similarProducts,
    ].flatMap { $0 }

    private static let mockNewsData: [ProductModel] = (1...20).map {
        ProductModel(
            id: String($0),
            images: [
                .init(kind: .url(.mockCake1)),
                .init(kind: .url(.mockCake2)),
                .init(kind: .url(.mockCake3)),
                .init(kind: .url(.mockCake4)),
            ].shuffled(),
            badgeText: "NEW",
            isFavorite: $0.isMultiple(of: 2),
            isNew: true,
            pickers: Constants.pickers,
            seller: .king,
            productName: "Boston cream pie",
            price: "$\($0).99",
            description: Constants.previewDescription,
            reviewInfo: .mockData,
            establishmentDate: "2024-03-\($0)T01:32:01+0000",
            similarProducts: .similarProducts
        )
    }

    private static let mockSalesData: [ProductModel] = (21...40).map {
        ProductModel(
            id: String($0),
            images: [
                .init(kind: .url(.mockCake3)),
                .init(kind: .url(.mockCake2)),
                .init(kind: .url(.mockCake1)),
                .init(kind: .url(.mockCake4)),
            ].shuffled(),
            badgeText: "-\($0)%",
            isFavorite: $0.isMultiple(of: 2),
            isNew: false,
            pickers: Constants.pickers,
            seller: .poly,
            productName: Constants.productName,
            price: "$\($0).99",
            discountedPrice: "$\($0 - 10).99",
            description: Constants.previewDescription,
            reviewInfo: .mockData,
            establishmentDate: "2024-03-\($0)T01:32:01+0000",
            similarProducts: .similarProducts
        )
    }

    private static let mockAllData: [ProductModel] = (41...61).map {
        ProductModel(
            id: String($0),
            images: [
                .init(kind: .url(.mockProductCard)),
                .init(kind: .url(.mockCake2)),
                .init(kind: .url(.mockCake3)),
                .init(kind: .url(.mockCake4)),
            ].shuffled(),
            isFavorite: $0.isMultiple(of: 2),
            isNew: false,
            pickers: Constants.pickers,
            seller: .milana,
            productName: "Battenberg cake",
            price: "$\($0).99",
            description: Constants.previewDescription,
            reviewInfo: .mockData,
            establishmentDate: "2024-03-\($0)T01:32:01+0000",
            similarProducts: .similarProducts
        )
    }

    static let similarProducts: [ProductModel] = (62...83).map {
        ProductModel(
            id: String($0),
            images: [
                .init(kind: .uiImage(CHMImage.mockImageCake)),
                .init(kind: .url(.mockCake3)),
                .init(kind: .url(.mockProductCard)),
                .init(kind: .url(.mockCake4)),
            ].shuffled(),
            badgeText: "NEW",
            isFavorite: $0.isMultiple(of: 2),
            isNew: true,
            pickers: Constants.pickers,
            seller: .poly,
            productName: Constants.productName,
            price: "$\($0).99",
            description: Constants.previewDescription,
            reviewInfo: .mockData,
            establishmentDate: "2024-03-\($0)T01:32:01+0000",
            similarProducts: []
        )
    }
}

// MARK: - Constants

private extension [ProductModel] {

    enum Constants {
        static let productName = "Очень вкусный торт"
        static let price = "$19.99"
        static let sellerName = "Short black dress"
        static let previewDescription = """
        Short dress in soft cotton jersey with decorative buttons down the front and a wide, frill-trimmed square neckline with concealed elastication. Elasticated seam under the bust and short puff sleeves with a small frill trim.
        """
        static let pickers = ["Size", "Color"]
    }
}

#endif
