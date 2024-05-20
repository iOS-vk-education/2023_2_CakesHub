//
//  ChatMessage.swift
//  CakesHub
//
//  Created by Dmitriy Permyakov on 26.03.2024.
//  Copyright 2024 © VK Team CakesHub. All rights reserved.
//

import UIKit

struct ChatMessage: Identifiable, Hashable {
    var id: String = UUID().uuidString
    let isYou: Bool
    let message: String
    let user: UserInfo
    let time: String
    let state: WSMessage.State

    struct UserInfo: Hashable {
        let name: String
        let image: ImageKind
    }
}
