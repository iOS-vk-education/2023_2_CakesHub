//
//  ChatMessage.swift
//  CakesHub
//
//  Created by Dmitriy Permyakov on 26.03.2024.
//

import Foundation

struct ChatMessage: Identifiable, Hashable {
    var id = UUID()
    let isYou: Bool
    let message: String
    let userName: String
    let time: String
    let state: Message.State
    var kind: Kind = .bubble

    enum Kind {
        case bubble
        case join
        case quit
    }
}

// MARK: Mock Data

#if DEBUG

extension [ChatMessage] {

    static let mockData: [ChatMessage] = [
        .init(isYou: true, message: message, userName: yourUser, time: "10:11", state: .error),
        .init(isYou: false, message: "Привет! Как твои дела?", userName: anotherUser, time: "10:12", state: .progress),
        .init(isYou: true, message: "Урааа, я очень жду", userName: anotherUser, time: "10:14", state: .received),
        .init(isYou: true, message: message + message, userName: anotherUser, time: "10:15", state: .error),
        .init(isYou: false, message: "Воу, ну это рил неплохо", userName: anotherUser, time: "10:16", state: .received),
        .init(isYou: false, message: message, userName: anotherUser, time: "10:15", state: .received),
        .init(isYou: true, message: message, userName: anotherUser, time: "10:15", state: .received),
        .init(isYou: false, message: message, userName: anotherUser, time: "10:15", state: .received)

    ]

    private static let message = "Hi! 🤗 You can switch patterns and gradients in the settings."
    private static let yourUser = "mightyK1ngRichard"
    private static let anotherUser = "poly"
}

#endif
