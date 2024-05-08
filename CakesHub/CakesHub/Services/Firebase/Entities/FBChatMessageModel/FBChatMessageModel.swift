//
//  FBChatMessageModel.swift
//  CakesHub
//
//  Created by Dmitriy Permyakov on 07.05.2024.
//  Copyright 2024 © VK Team CakesHub. All rights reserved.
//

import Foundation

struct FBChatMessageModel: FBModelable {
    let id           : String
    let message      : String
    let receiverID   : String
    let userID       : String
    let dispatchDate : String

    static let clear = FBChatMessageModel(
        id: .clear,
        message: .clear,
        receiverID: .clear,
        userID: .clear,
        dispatchDate: .clear
    )
}

// MARK: - DictionaryConvertible

extension FBChatMessageModel {

    init?(dictionary: [String: Any]) {
        guard
            let id = dictionary["id"] as? String,
            let message = dictionary["message"] as? String,
            let receiverID = dictionary["receiverID"] as? String,
            let userID = dictionary["userID"] as? String,
            let dispatchDate = dictionary["dispatchDate"] as? String
        else {
            return nil
        }

        self.init(
            id: id,
            message: message,
            receiverID: receiverID,
            userID: userID,
            dispatchDate: dispatchDate
        )
    }
}
