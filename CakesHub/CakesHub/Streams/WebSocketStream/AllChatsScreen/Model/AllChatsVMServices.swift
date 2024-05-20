//
//
//  AllChatsVMServices.swift
//  CakesHub
//
//  Created by Dmitriy Permyakov on 08.05.2024.
//  Copyright 2024 © VK Team CakesHub. All rights reserved.
//

import Foundation

extension AllChatsViewModel {

    struct Services: ClearConfigurationProtocol {
        let chatService: ChatServiceProtocol
        let userService: UserServiceProtocol

        init(
            chatService: ChatServiceProtocol = ChatService.shared,
            userService: UserServiceProtocol = UserService.shared
        ) {
            self.chatService = chatService
            self.userService = userService
        }

        static let clear = Services()
    }
}
