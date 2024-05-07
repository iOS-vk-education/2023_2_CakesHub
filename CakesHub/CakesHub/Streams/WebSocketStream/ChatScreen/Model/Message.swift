//
//  Message.swift
//  CakesHub
//
//  Created by Dmitriy Permyakov on 26.03.2024.
//  Copyright 2024 © VK Team CakesHub. All rights reserved.
//

import UIKit

struct Message: Codable, Identifiable {
    var id: UUID
    let kind: WSMessageKind
    let userName: String
    let userID: String
    let receiverID: String
    let dispatchDate: Date
    let message: String
    var state: State

    enum State: String, Codable {
        case progress
        case received
        case error
    }
}

extension Message {

    static func connectionMessage(userID: String) -> Message {
        Message(
            id: UUID(),
            kind: .connection,
            userName: .clear,
            userID: userID,
            receiverID: .clear,
            dispatchDate: Date(),
            message: .clear,
            state: .progress
        )
    }
}

// MARK: - Mapper

extension Message {

    func mapper(name: String, userImage: ImageKind) -> ChatMessage {
        .init(
            id: id,
            isYou: userName == name,
            message: message,
            user: .init(name: name, image: userImage),
            time: dispatchDate.formattedString(format: "HH:mm"),
            state: state
        )
    }
}

// MARK: - Helper

private extension Data? {

    var mapper: ImageKind {
        guard let data = self else { return .clear }
        return .uiImage(UIImage(data: data))
    }
}
