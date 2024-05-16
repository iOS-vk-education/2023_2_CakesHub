//
//  ChatViewModel+Mock.swift
//  CakesHub
//
//  Created by Dmitriy Permyakov on 26.03.2024.
//  Copyright 2024 © VKxBMSTU Team CakesHub. All rights reserved.
//

import Foundation

#if DEBUG
extension ChatViewModel: Mockable {

    static let mockData = ChatViewModel(
        data: ScreenData(
            messages: messages,
            interlocutor: .init(
                id: UUID().uuidString,
                image: .uiImage(.bestGirl),
                nickname: "Poly"
            ),
            user: .king
        )
    )

    private static let messages: [ChatMessage] = [
        .init(id: "1", isYou: true, message: message, user: yourUser, time: "10:11", state: .error),
        .init(id: "2", isYou: false, message: "Привет! Как твои дела?", user: anotherUser, time: "10:12", state: .progress),
        .init(id: "3", isYou: true, message: "Урааа, я очень жду", user: anotherUser, time: "10:14", state: .received),
        .init(id: "4", isYou: true, message: message + message, user: anotherUser, time: "10:15", state: .error),
        .init(id: "5", isYou: false, message: "Воу, ну это рил неплохо", user: anotherUser, time: "10:16", state: .received),
        .init(id: "6", isYou: false, message: message, user: anotherUser, time: "10:15", state: .received),
        .init(id: "7", isYou: true, message: message, user: anotherUser, time: "10:15", state: .received),
        .init(id: "8", isYou: false, message: message, user: anotherUser, time: "10:15", state: .received)

    ]

    private static let message = "Hi! 🤗 You can switch patterns and gradients in the settings."
    private static let yourUser = ChatMessage.UserInfo(name: "mightK1ngRichard", image: .uiImage(.bestGirl))
    private static let anotherUser = ChatMessage.UserInfo(name: "Poly", image: .uiImage(.bestGirl))
}

#endif
