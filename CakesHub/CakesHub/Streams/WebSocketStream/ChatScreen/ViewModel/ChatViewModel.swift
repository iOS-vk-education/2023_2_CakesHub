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
    func connectWebSocket(completion: CHMGenericBlock<APIError?>? = nil) {}

    /// Sending message to the server
    /// - Parameter message: message data
    func sendMessage(message: String) {
        let msg = Message(
            id: UUID(),
            kind: .message,
            user: .init(userName: user.name, userImage: user.userImage.toData),
            dispatchDate: Date(),
            message: message,
            state: .progress
        )
        lastMessageID = msg.id
        messages.append(msg.mapper(name: user.name))
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

// MARK: - Helper

private extension ImageKind {

    var toData: Data? {
        switch self {
        case .url(let url):
            guard let url = url else { return nil }
            do {
                return try Data(contentsOf: url)
            } catch {
                Logger.log(kind: .error, message: error)
                return nil
            }

        case .uiImage(let uiImage):
            guard let uiImage else { return nil }
            if let pngData = uiImage.pngData() {
                return pngData
            }
            if let jpegData = uiImage.jpegData(compressionQuality: 1.0) {
                return jpegData
            }
            return nil

        case .clear:
            return nil
        }
    }
}
