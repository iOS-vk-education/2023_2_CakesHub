//
//  Message.swift
//  CakesHub
//
//  Created by Dmitriy Permyakov on 26.03.2024.
//

import Foundation

struct Message: Codable, Identifiable {
    var id: UUID
    let kind: MessageKind
    let userName: String
    let dispatchDate: Date
    let message: String
    var state: State

    enum MessageKind: String, Codable {
        case connection
        case message
        case close
    }

    enum State: String, Codable {
        case progress
        case received
        case error
    }
}

// MARK: - Mapper

extension Message {

    func mapper(name: String) -> ChatMessage {
        .init(
            id: id,
            isYou: userName == name,
            message: message,
            userName: userName,
            time: dispatchDate.formattedString(format: "HH:mm"),
            state: state,
            kind: kind.toChatKind
        )
    }
}

private extension Message.MessageKind {

    var toChatKind: ChatMessage.Kind {
        switch self {
        case .connection: return .join
        case .message: return .bubble
        case .close: return .quit
        }
    }
}

// MARK: - Helper

private extension Date {

    func formattedString(format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
}
