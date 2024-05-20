//
//  Message.swift
//  
//
//  Created by Dmitriy Permyakov on 11.04.2024.
//

import Foundation

struct MessageAbstract: Codable {
    let kind: MessageKind
}

struct Message: Codable, Identifiable {
    var id: String
    let kind: MessageKind
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

enum MessageKind: String, Codable {
    case connection
    case message
    case close
    case notification
}

// MARK: - Encode

extension Message {

    func encodeMessage() throws -> String {
        let msgData = try JSONEncoder().encode(self)
        guard let msgString = String(data: msgData, encoding: .utf8) else {
            throw KingError.dataToString
        }
        return msgString
    }
}
