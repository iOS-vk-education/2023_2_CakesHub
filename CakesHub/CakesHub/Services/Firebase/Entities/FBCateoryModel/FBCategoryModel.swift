//
//  FBCategoryModel.swift
//  CakesHub
//
//  Created by Dmitriy Permyakov on 06.05.2024.
//  Copyright 2024 © VK Team CakesHub. All rights reserved.
//

import Foundation

struct FBCategoryModel: FBModelable {
    let id       : String
    let title    : String
    let imageURL : String
    let tags     : [Tag]

    static let clear = FBCategoryModel(
        id: .clear,
        title: .clear,
        imageURL: .clear,
        tags: []
    )
}

// MARK: - DictionaryConvertible

extension FBCategoryModel {

    init?(dictionary: [String: Any]) {
        guard
            let id       = dictionary["id"] as? String,
            let title    = dictionary["title"] as? String,
            let imageURL = dictionary["imageURL"] as? String,
            let tagStrings = dictionary["tags"] as? [String]
        else {
            return nil
        }

        let tags = tagStrings.compactMap { Tag(rawValue: $0) }
        self.init(
            id: id,
            title: title,
            imageURL: imageURL,
            tags: tags
        )
    }
}

// MARK: - Hashable

extension FBCategoryModel: Hashable {

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    static func == (lhs: FBCategoryModel, rhs: FBCategoryModel) -> Bool {
        lhs.id == rhs.id
    }
}
