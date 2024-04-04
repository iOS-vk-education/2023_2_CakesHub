//
//  ChatViewModel.swift
//  CakesHub
//
//  Created by Dmitriy Permyakov on 26.03.2024.
//  Copyright 2024 © VKxBMSTU Team CakesHub. All rights reserved.
//

import Foundation

// MARK: - ChatViewModelProtocol

protocol ChatViewModelProtocol: AnyObject {
    func connectWebSocket(completion: CHMGenericBlock<APIError?>?)
    func sendMessage(message: String)
}

// MARK: - ChatViewModel

final class ChatViewModel: ObservableObject, ViewModelProtocol {
    @Published private(set) var messages: [ChatMessage]
    @Published private(set) var lastMessageID: UUID?
    @Published private(set) var user: UserModel

    init(
        messages: [ChatMessage] = [], 
        lastMessageID: UUID? = nil,
        user: UserModel = .clear
    ) {
        self.messages = messages
        self.lastMessageID = lastMessageID
        self.user = user
    }
}

// MARK: - ChatViewModelProtocol

extension ChatViewModel: ChatViewModelProtocol {

    /// Create web socket connection with the server
    func connectWebSocket(completion: CHMGenericBlock<APIError?>? = nil) {
        messages.append(.init(
            isYou: false,
            message: "Привет! Как дела? Тебе понравился какой-то товар?",
            user: .init(name: user.name, image: user.userImage),
            time: Date.now.formattedString(format: "HH:mm"),
            state: .received
        ))
    }

    /// Sending message to the server
    /// - Parameter message: message data
    func sendMessage(message: String) {
        let msg = Message(
            id: UUID(),
            kind: .message,
            userName: user.name,
            dispatchDate: Date(),
            message: message,
            state: .progress
        )
        lastMessageID = msg.id
        messages.append(msg.mapper(name: user.name, userImage: user.userImage))
//        WebSockerManager.shared.send(message: msg)
    }

    /// Quit chat view
    func quitChat() {
        messages = []
        lastMessageID = nil
//        WebSockerManager.shared.close()
    }
}

// MARK: - Private Methods

private extension ChatViewModel {

    /// Getting new message
    func receiveWebSocketData() {}
}
