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
            .mockImageCake,
            .mockImageCake2,
            .mockImageCake3,
        ]),
        badgeText: "NEW",
        pickers: [],
        productName: "Клубничное облако",
        price: "1250" + .space + .rub,
        oldPrice: "1400" + .space + .rub,
        seller: .mockData,
        description: "Нежнейший клубничный мусс со сливками, покрыт шоколадным велюром.",
        similarProducts: [], 
        reviewInfo: .clear
    )
}
#endif
