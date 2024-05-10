//
//
//  ChatVMData.swift
//  CakesHub
//
//  Created by Dmitriy Permyakov on 10.05.2024.
//  Copyright 2024 © VK Team CakesHub. All rights reserved.
//

import Foundation

extension ChatViewModel {

    struct ScreenData: ClearConfigurationProtocol {
        var messages: [ChatMessage]
        var lastMessageID: String?
        var interlocutor: Interlocutor
        var user: ProductModel.SellerInfo

        init(
            messages: [ChatMessage] = [],
            lastMessageID: String? = nil,
            interlocutor: Interlocutor = .clear,
            user: ProductModel.SellerInfo = .clear
        ) {
            self.messages = messages
            self.lastMessageID = lastMessageID
            self.interlocutor = interlocutor
            self.user = user
        }

        static let clear = ScreenData()
    }
}
