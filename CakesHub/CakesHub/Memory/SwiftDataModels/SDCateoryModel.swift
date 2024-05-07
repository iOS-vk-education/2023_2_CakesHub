//
//  SDCateoryModel.swift
//  CakesHub
//
//  Created by Dmitriy Permyakov on 07.05.2024.
//

import SwiftData

@Model
final class SDCateoryModel {
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

extension SDCateoryModel: SDModelable {
    typealias FBModelType = FBCateoryModel

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

extension SDCateoryModel {

    var mapper: FBCateoryModel {
        FBCateoryModel(
            id: _id,
            title: _title,
            imageURL: _imageURL,
            tags: _tags.compactMap { .init(rawValue: $0) }
        )
    }
}
