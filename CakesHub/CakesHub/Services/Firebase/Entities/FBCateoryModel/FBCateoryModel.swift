//
//  FBCateoryModel.swift
//  CakesHub
//
//  Created by Dmitriy Permyakov on 06.05.2024.
//

import Foundation

struct FBCateoryModel: FBModelable {
    let id       : String
    let title    : String
    let imageURL : String
    let tags     : [Tag]

    static let clear = FBCateoryModel(
        id: .clear,
        title: .clear,
        imageURL: .clear,
        tags: []
    )
}

// MARK: - DictionaryConvertible

extension FBCateoryModel {

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
