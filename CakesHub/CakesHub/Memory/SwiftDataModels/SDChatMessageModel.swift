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
    @Attribute(.unique)
    let _id             : String
    let _message        : String
    let _interlocutorID : String
    let _userID         : String
    let _dispatchDate   : String

    init(
        id: String,
        message: String,
        interlocutorID: String,
        userID: String,
        dispatchDate: String
    ) {
        self._id = id
        self._message = message
        self._interlocutorID = interlocutorID
        self._userID = userID
        self._dispatchDate = dispatchDate
    }
}

// MARK: - SDModelable

extension SDChatMessageModel: SDModelable {
    typealias FBModelType = FBChatMessageModel

    convenience init(fbModel: FBChatMessageModel) {
        self.init(
            id: fbModel.id,
            message: fbModel.message,
            interlocutorID: fbModel.receiverID,
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
            receiverID: _interlocutorID,
            userID: _userID,
            dispatchDate: _dispatchDate
        )
    }
}
