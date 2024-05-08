//
//  SDChatMessageModel.swift
//  CakesHub
//
//  Created by Dmitriy Permyakov on 07.05.2024.
//  Copyright 2024 © VK Team CakesHub. All rights reserved.
//

import SwiftData

@Model
final class SDChatMessageModel {
    let _id           : String
    let _message      : String
    let _receiverID   : String
    let _userID       : String
    let _dispatchDate : String

    init(
        id: String,
        message: String,
        receiverID: String,
        userID: String,
        dispatchDate: String
    ) {
        self._id = id
        self._message = message
        self._receiverID = receiverID
        self._userID = userID
        self._dispatchDate = dispatchDate
    }
}

extension SDChatMessageModel: SDModelable {
    typealias FBModelType = FBChatMessageModel

    convenience init(fbModel: FBChatMessageModel) {
        self.init(
            id: fbModel.id,
            message: fbModel.message,
            receiverID: fbModel.receiverID,
            userID: fbModel.userID,
            dispatchDate: fbModel.dispatchDate
        )
    }
}

// MARK: - Mapper

extension SDChatMessageModel {

    var mapper: FBChatMessageModel {
        FBChatMessageModel(
            id: _id,
            message: _message,
            receiverID: _receiverID,
            userID: _userID,
            dispatchDate: _dispatchDate
        )
    }
}
