//
//  ChatMessage.swift
//  CakesHub
//
//  Created by Dmitriy Permyakov on 26.03.2024.
//  Copyright 2024 © VK Team CakesHub. All rights reserved.
//

import UIKit

struct ChatMessage: Identifiable, Hashable {
    var id = UUID()
    let isYou: Bool
    let message: String
    let user: UserInfo
    let time: String
    let state: Message.State

    struct UserInfo: Hashable {
        let name: String
        let image: ImageKind
    }
}

// MARK: - Mock Data

#if DEBUG

extension [ChatMessage] {

    static let mockData: [ChatMessage] = [
        .init(isYou: true, message: message, user: yourUser, time: "10:11", state: .error),
        .init(isYou: false, message: "Привет! Как твои дела?", user: anotherUser, time: "10:12", state: .progress),
        .init(isYou: true, message: "Урааа, я очень жду", user: anotherUser, time: "10:14", state: .received),
        .init(isYou: true, message: message + message, user: anotherUser, time: "10:15", state: .error),
        .init(isYou: false, message: "Воу, ну это рил неплохо", user: anotherUser, time: "10:16", state: .received),
        .init(isYou: false, message: message, user: anotherUser, time: "10:15", state: .received),
        .init(isYou: true, message: message, user: anotherUser, time: "10:15", state: .received),
        .init(isYou: false, message: message, user: anotherUser, time: "10:15", state: .received)

    ]

    private static let message = "Hi! 🤗 You can switch patterns and gradients in the settings."
    private static let yourUser = ChatMessage.UserInfo(name: "mightK1ngRichard", image: .uiImage(.bestGirl))
    private static let anotherUser = ChatMessage.UserInfo(name: "Poly", image: .uiImage(.bestGirl))
}

#endif
