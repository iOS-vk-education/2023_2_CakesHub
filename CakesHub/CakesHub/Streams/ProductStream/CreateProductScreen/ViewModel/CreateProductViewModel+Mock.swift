//
//  CreateProductViewModel+Mock.swift
//  CakesHub
//
//  Created by Dmitriy Permyakov on 05.04.2024.
//  Copyright 2024 © VKxBMSTU Team CakesHub. All rights reserved.
//

import Foundation

#if DEBUG

extension CreateProductViewModel: Mockable {

    static let mockData = CreateProductViewModel(rootViewModel: .mockData, inputProductData: Constants.mockInputData)
}

// MARK: - Constants

private extension CreateProductViewModel {

    enum Constants {
        static let mockInputData = InputProductModel(
            productName: "Торт медовик",
            productDescription: "Просто описание торта медовика для превью",
            productPrice: "1000",
            productDiscountedPrice: "200",
            productImages: [
                CHMImage.mockImageCake?.pngData(),
                CHMImage.mockImageCake2?.pngData(),
                CHMImage.mockImageCake3?.pngData(),
            ].compactMap { $0 }
        )
    }
}

#endif
