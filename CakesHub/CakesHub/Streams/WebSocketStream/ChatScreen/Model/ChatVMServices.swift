//
//
//  ChatVMServices.swift
//  CakesHub
//
//  Created by Dmitriy Permyakov on 10.05.2024.
//  Copyright 2024 © VK Team CakesHub. All rights reserved.
//

import Foundation

extension ChatViewModel {

    struct Services: ClearConfigurationProtocol {
        var wsManager: WebSockerManagerProtocol
        var chatService: ChatServiceProtocol

        init(
            wsManager: WebSockerManagerProtocol = WebSockerManager.shared,
            chatService: ChatServiceProtocol = ChatService.shared
        ) {
            self.wsManager = wsManager
            self.chatService = chatService
        }

        static let clear = Services()
    }
}
