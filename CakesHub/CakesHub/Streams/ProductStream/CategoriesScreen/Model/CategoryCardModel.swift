//
//  CategoryCardModel.swift
//  CakesHub
//
//  Created by Dmitriy Permyakov on 03.03.2024.
//  Copyright 2024 © VK Team CakesHub. All rights reserved.
//

import Foundation

struct CategoryCardModel: Identifiable {
    var id: String = UUID().uuidString
    var title: String = .clear
    var image: ImageKind = .clear
}

// MARK: - Mapper

extension [FBCateoryModel] {

    var mapper: [CategoryCardModel] {
        self.map { $0.mapper }
    }
}

extension FBCateoryModel {

    var mapper: CategoryCardModel {
        CategoryCardModel(
            title: title,
            image: .url(URL(string: imageURL))
        )
    }
}
