//
//  CategoryCardModel.swift
//  CakesHub
//
//  Created by Dmitriy Permyakov on 03.03.2024.
//

import Foundation

struct CategoryCardModel: Identifiable {
    let id = UUID()
    var title: String = .clear
    var image: ImageKind = .clear
}

// MARK: - Mapper

extension FBCateoryModel {

    var mapper: CategoryCardModel {
        CategoryCardModel(
            title: title,
            image: .url(URL(string: imageURL))
        )
    }
}

// MARK: - Mock Data

#if DEBUG

extension [CategoryCardModel] {

    static let mockData: [CategoryCardModel] = [
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

