//
//
//  ProfileVMServices.swift
//  CakesHub
//
//  Created by Dmitriy Permyakov on 10.05.2024.
//  Copyright 2024 © VK Team CakesHub. All rights reserved.
//

import Foundation

extension ProfileViewModel {
    
    struct Services: ClearConfigurationProtocol {
        var chatService: ChatServiceProtocol
        var userService: UserServiceProtocol

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
