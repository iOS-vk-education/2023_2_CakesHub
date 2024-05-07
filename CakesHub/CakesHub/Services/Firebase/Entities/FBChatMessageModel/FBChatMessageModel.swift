//
//  FBChatMessageModel.swift
//  CakesHub
//
//  Created by Dmitriy Permyakov on 07.05.2024.
//  Copyright 2024 © VK Team CakesHub. All rights reserved.
//

import Foundation

struct FBChatMessageModel: FBModelable {
    let id           : UUID
    let message      : String
    let receiver     : FBUserMessageModel
    let user         : FBUserMessageModel
    let dispatchDate : Date

    static let clear = FBChatMessageModel(
        id: UUID(),
        message: .clear,
        receiver: .clear,
        user: .clear,
        dispatchDate: Date()
    )
}

// MARK: - DictionaryConvertible

extension FBChatMessageModel {

    init?(dictionary: [String: Any]) {
        guard
            let id = dictionary["id"] as? UUID,
            let message = dictionary["message"] as? String,
            let receiverDict = dictionary["receiver"] as? [String: Any],
            let userDict = dictionary["user"] as? [String: Any],
            let dispatchDate = dictionary["dispatchDate"] as? Date
        else {
            return nil
        }
        
        let receiver = FBUserMessageModel(dictionary: receiverDict) ?? .clear
        let user = FBUserMessageModel(dictionary: userDict) ?? .clear

        self.init(
            id: id,
            message: message,
            receiver: receiver,
            user: user,
            dispatchDate: dispatchDate
        )
    }
}
