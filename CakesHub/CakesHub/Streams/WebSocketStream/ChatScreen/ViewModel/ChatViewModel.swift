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
    func didTapSignIn(userName: String, completion: @escaping CHMGenericBlock<APIError?>)
}

// MARK: - ChatViewModel

final class ChatViewModel: ObservableObject, ViewModelProtocol {
    @Published private(set) var messages: [ChatMessage]
    @Published private(set) var lastMessageID: UUID?
    @Published private(set) var userName: String

    init(messages: [ChatMessage] = [], lastMessageID: UUID? = nil, userName: String = .clear) {
        self.messages = messages
        self.lastMessageID = lastMessageID
        self.userName = userName
    }
}

// MARK: - ChatViewModelProtocol

extension ChatViewModel: ChatViewModelProtocol {

    /// Create web socket connection with the server
    func connectWebSocket(completion: CHMGenericBlock<APIError?>? = nil) {
    }

    /// Sending message to the server
    /// - Parameter message: message data
    func sendMessage(message: String) {
        let msg = Message(
            id: UUID(),
            kind: .message,
            userName: userName,
            dispatchDate: Date(),
            message: message,
            state: .progress
        )
        lastMessageID = msg.id
        messages.append(msg.mapper(name: userName))
//        WebSockerManager.shared.send(message: msg)
    }

    /// Quit chat view
    func quitChat() {
        messages = []
        lastMessageID = nil
        userName = .clear
//        WebSockerManager.shared.close()
    }

    /// Did tap sign in button
    /// - Parameter userName: the entered name
    func didTapSignIn(userName: String, completion: @escaping CHMGenericBlock<APIError?>) {
        self.userName = userName
        connectWebSocket(completion: completion)
    }
}

// MARK: - Reducers

#if DEBUG
extension ChatViewModel {

    func setPreviewData(name: String, messages: [ChatMessage] = .mockData, lastMessage: UUID? = nil) {
        self.userName = name
        self.messages = messages
        self.lastMessageID = lastMessage
    }
}
#endif

// MARK: - Private Methods

private extension ChatViewModel {

    /// Getting new message
    func receiveWebSocketData() {}
}
