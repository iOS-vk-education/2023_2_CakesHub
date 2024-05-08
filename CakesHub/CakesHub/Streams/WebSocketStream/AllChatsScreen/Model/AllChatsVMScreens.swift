//
//
//  AllChatsVMScreens.swift
//  CakesHub
//
//  Created by Dmitriy Permyakov on 08.05.2024.
//  Copyright 2024 © VK Team CakesHub. All rights reserved.
//

import Foundation

extension AllChatsViewModel {

    enum Screens: Hashable {
        case chat(messages: [ChatMessage], seller: UserModel)
    }
}
