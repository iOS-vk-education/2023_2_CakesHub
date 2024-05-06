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
    func connectWebSocket(completion: @escaping CHMVoidBlock)
    func sendMessage(message: String)
}

// MARK: - ChatViewModel

final class ChatViewModel: ObservableObject, ViewModelProtocol {
 
    @Published private(set) var messages: [ChatMessage]
    @Published private(set) var lastMessageID: UUID?
    @Published private(set) var seller: UserModel
    private(set) var user: ProductModel.SellerInfo
    private(set) var wsSocket: WebSockerManagerProtocol?

    init(
        messages: [ChatMessage] = [], 
        lastMessageID: UUID? = nil,
        seller: UserModel = .clear,
        user: ProductModel.SellerInfo,
        wsSocket: WebSockerManagerProtocol = WebSockerManager.shared
    ) {
        self.messages = messages
        self.lastMessageID = lastMessageID
        self.seller = seller
        self.user = user
        if self.wsSocket == nil {
            self.wsSocket = wsSocket
        }
    }
}

// MARK: - ChatViewModelProtocol

extension ChatViewModel: ChatViewModelProtocol {

    /// Create web socket connection with the server
    func connectWebSocket(completion: @escaping CHMVoidBlock) {
        messages.append(.init(
            isYou: false,
            message: "Привет! Как дела? Тебе понравился какой-то товар?",
            user: .init(name: seller.name, image: seller.userImage),
            time: Date.now.formattedString(format: "HH:mm"),
            state: .received
        ))
        receiveWebSocketData()
    }

    /// Sending message to the server
    /// - Parameter message: message data
    func sendMessage(message: String) {
        let msg = Message(
            id: UUID(),
            kind: .message,
            userName: user.name,
            userID: user.id,
            receiverID: seller.id,
            dispatchDate: Date(),
            message: message,
            state: .progress
        )
        lastMessageID = msg.id
        let chatMsg = msg.mapper(name: user.name, userImage: user.userImage)
        messages.append(chatMsg)
        wsSocket?.send(message: msg, completion: {})
    }
}

// MARK: - Private Methods

private extension ChatViewModel {

    /// Getting new message
    func receiveWebSocketData() {
        wsSocket?.receive { [weak self] (message: Message) in
            guard let self, message.kind == .message else { return }
            let image: ImageKind = message.userID == user.id ? user.userImage : seller.userImage
            let chatMessage = ChatMessage(
                id: message.id,
                isYou: message.userID == user.id,
                message: message.message,
                user: .init(name: message.userName, image: image),
                time: message.dispatchDate.formattedString(format: "HH:mm"),
                state: message.state
            )
            // Если сообщение не найденно, значит добавляем его
            guard let index = messages.firstIndex(where: { $0.id == chatMessage.id }) else {
                DispatchQueue.main.async {
                    self.messages.append(chatMessage)
                    self.lastMessageID = chatMessage.id
                }
                return
            }
            DispatchQueue.main.async {
                self.messages[index] = chatMessage
            }
        }
    }
}
