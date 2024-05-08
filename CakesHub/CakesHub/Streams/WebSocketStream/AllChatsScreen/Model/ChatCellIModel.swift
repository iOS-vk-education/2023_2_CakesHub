//
//
//  ChatCellIModel.swift
//  CakesHub
//
//  Created by Dmitriy Permyakov on 08.05.2024.
//  Copyright 2024 © VK Team CakesHub. All rights reserved.
//

import Foundation

struct ChatCellIModel: Identifiable, ClearConfigurationProtocol {
    var userID: String = .clear
    var userName: String = .clear
    var imageKind: ImageKind = .clear
    var lastMessage: String = .clear
    var timeMessage: String = .clear
    var messages: [Message] = []

    var id: String { userID }

    struct Message {
        let id: String
        let time: String
        let text: String
    }

    static let clear = ChatCellIModel()
}
