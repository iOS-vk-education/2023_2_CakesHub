//
//
//  ChatInterlocutor.swift
//  CakesHub
//
//  Created by Dmitriy Permyakov on 09.05.2024.
//  Copyright 2024 © VK Team CakesHub. All rights reserved.
//

import Foundation

extension ChatViewModel {

    struct Interlocutor: Hashable, ClearConfigurationProtocol {
        var id: String
        var image: ImageKind
        var nickname: String

        static let clear = Interlocutor(id: .clear, image: .clear, nickname: .clear)
    }
}
