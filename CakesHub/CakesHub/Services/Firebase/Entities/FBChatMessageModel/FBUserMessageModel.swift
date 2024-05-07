//
//  FBUserMessageModel.swift
//  CakesHub
//
//  Created by Dmitriy Permyakov on 07.05.2024.
//  Copyright 2024 © VK Team CakesHub. All rights reserved.
//

import Foundation

extension FBChatMessageModel {

    struct FBUserMessageModel: FBModelable {
        let id       : UUID
        let name     : String
        let imageURL : String

        static let clear = FBUserMessageModel(
            id: UUID(),
            name: .clear,
            imageURL: .clear
        )
    }
}

// MARK: - DictionaryConvertible

extension FBChatMessageModel.FBUserMessageModel {

    init?(dictionary: [String: Any]) {
        guard
            let id = dictionary["id"] as? UUID,
            let name = dictionary["name"] as? String,
            let imageURL = dictionary["imageURL"] as? String
        else {
            return nil
        }

        self.init(
            id: id,
            name: name,
            imageURL: imageURL
        )
    }
}
