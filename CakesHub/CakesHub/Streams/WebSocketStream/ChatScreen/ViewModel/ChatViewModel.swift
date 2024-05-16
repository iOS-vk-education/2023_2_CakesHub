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
    // MARK: Network
    func sendMessage(message: FBChatMessageModel) async throws
    // MARK: Actions
    func sendMessage(message: String)
    // MARK: Web Socket Layer
    func receivedMessage(output: NotificationCenter.Publisher.Output)
}

// MARK: - ChatViewModel

@Observable
final class ChatViewModel: ViewModelProtocol, ChatViewModelProtocol {

    private(set) var data: ScreenData
    private var services: Services

    init(
        data: ScreenData = .clear,
        services: Services = .clear
    ) {
        
        self.data = data
        self.services = services
    }
}

// MARK: - Network

extension ChatViewModel {

    func sendMessage(message: FBChatMessageModel) async throws {
        try await services.chatService.send(message: message)
    }
}

// MARK: - Actions

extension ChatViewModel {

    /// Нажали кнопку `отправить` сообщение
    func sendMessage(message: String) {
        // Формируем дату сообщения
        let messageID = UUID().uuidString
        let userID = data.user.id
        let interlocuterID = data.interlocutor.id
        let messageDate = Date()

        // Отправляем сообщение по веб сокет протоколу
        let msg = WSMessage(
            id: messageID,
            kind: .message,
            userName: data.user.name,
            userID: userID,
            receiverID: interlocuterID,
            dispatchDate: Date(),
            message: message,
            state: .progress
        )
        data.lastMessageID = msg.id
        let chatMsg = msg.mapper(name: data.user.name, userImage: data.user.userImage)
        data.messages.append(chatMsg)
        services.wsManager.send(message: msg, completion: {})

        // Отправляем сообщение в firebase хранилище
        Task {
            let fbMessage = FBChatMessageModel(
                id: messageID,
                message: message,
                receiverID: interlocuterID,
                userID: userID,
                dispatchDate: messageDate.description
            )
            try? await sendMessage(message: fbMessage)
        }
    }
}

// MARK: - Web Socket Layer

extension ChatViewModel {
    
    /// Получение сообщения из Web Socket слоя
    func receivedMessage(output: NotificationCenter.Publisher.Output) {
        guard let wsMessage = output.object as? WSMessage, wsMessage.kind == .message else {
            return
        }

        let image: ImageKind = wsMessage.userID == data.user.id ? data.user.userImage : data.interlocutor.image
        let chatMessage = ChatMessage(
            id: wsMessage.id,
            isYou: wsMessage.userID == data.user.id,
            message: wsMessage.message,
            user: .init(name: wsMessage.userName, image: image),
            time: wsMessage.dispatchDate.formattedString(format: "HH:mm"),
            state: wsMessage.state
        )

        // Если сообщение не найденно, значит добавляем его
        guard let index = data.messages.firstIndex(where: { $0.id == chatMessage.id }) else {
            data.messages.append(chatMessage)
            data.lastMessageID = chatMessage.id
            return
        }
        data.messages[index] = chatMessage
    }
}
