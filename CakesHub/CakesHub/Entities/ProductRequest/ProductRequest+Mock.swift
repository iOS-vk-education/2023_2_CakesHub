//
//  ProductRequest+Mock.swift
//  CakesHub
//
//  Created by Dmitriy Permyakov on 02.03.2024.
//  Copyright 2024 © VK Team CakesHub. All rights reserved.
//

import UIKit

#if DEBUG

extension ProductRequest: Mockable {

    static let mockData = ProductRequest(
        images: .images([
            .cakeImageMock,
            .cake2ImageMock,
            .cake3ImageMock,
        ]),
        badgeText: "NEW",
        pickers: [],
        productName: "Клубничное облако",
        price: "1250 " + .rub,
        oldPrice: "1400 " + .rub,
        seller: .mockData,
        description: .description,
        similarProducts: [], 
        reviewInfo: .clear
    )
}

private extension String {

    static let description = "Нежнейший клубничный мусс со сливками, покрыт шоколадным велюром."
}

#endif
