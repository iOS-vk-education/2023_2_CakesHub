//
//  SDCategoryModel.swift
//  CakesHub
//
//  Created by Dmitriy Permyakov on 07.05.2024.
//  Copyright 2024 © VK Team CakesHub. All rights reserved.
//

import SwiftData

@Model
final class SDCategoryModel {
    @Attribute(.unique)
    let _id       : String
    let _title    : String
    let _imageURL : String
    let _tags     : [String]

    init(
        id: String,
        title: String,
        imageURL: String,
        tags: [String]
    ) {
        self._id = id
        self._title = title
        self._imageURL = imageURL
        self._tags = tags
    }
}

// MARK: - SDModelable

extension SDCategoryModel: SDModelable {
    typealias FBModelType = FBCategoryModel

    convenience init(fbModel: FBModelType) {
        self.init(
            id: fbModel.id,
            title: fbModel.title,
            imageURL: fbModel.imageURL,
            tags: fbModel.tags.map { $0.rawValue }
        )
    }
}

// MARK: - Mapper

extension SDCategoryModel {

    var mapper: FBCategoryModel {
        FBCategoryModel(
            id: _id,
            title: _title,
            imageURL: _imageURL,
            tags: _tags.compactMap { .init(rawValue: $0) }
        )
    }
}
