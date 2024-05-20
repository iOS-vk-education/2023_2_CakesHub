//
//
//  ChatCellModel.swift
//  CakesHub
//
//  Created by Dmitriy Permyakov on 08.05.2024.
//  Copyright 2024 © VK Team CakesHub. All rights reserved.
//

import Foundation

struct ChatCellModel: Identifiable, ClearConfigurationProtocol {
    var user: User = .clear
    var lastMessage: String = .clear
    var timeMessage: Date?
    var messages: [Message] = []

    var id: String { user.id }

    struct Message {
        let id: String
        let time: Date?
        let text: String
        let isYou: Bool
    }

    struct User: ClearConfigurationProtocol {
        var id: String = .clear
        var nickname: String = .clear
        var imageKind: ImageKind = .clear

        static let clear = User()
    }

    static let clear = ChatCellModel()
}
