//
//  CategoriesViewModel+Mock.swift
//  CakesHub
//
//  Created by Dmitriy Permyakov on 03.03.2024.
//

import Foundation

#if DEBUG

extension CategoriesViewModel: Mockable {

    static let mockData = CategoriesViewModel(
        sections: [
            .kids(.mockData1),
            .men(.mockData2),
            .women(.mockData3)
        ]
    )
}

// MARK: - FBCateoryModel

extension [CategoryCardModel] {

    static let mockData1: [CategoryCardModel] = [
        .mockData1,
        .mockData2,
        .mockData3,
    ]

    static let mockData2: [CategoryCardModel] = [
        .mockData3,
        .mockData2,
        .mockData1,
    ]

    static let mockData3: [CategoryCardModel] = [
        .mockData2,
        .mockData3,
        .mockData1,
    ]
}

private extension CategoryCardModel {

    static let mockData1 = CategoryCardModel(title: "NEW", image: .uiImage(.category1))
    static let mockData2 = CategoryCardModel(title: "Sales", image: .uiImage(.category2))
    static let mockData3 = CategoryCardModel(title: "Rich", image: .uiImage(.category3))
}

#endif
