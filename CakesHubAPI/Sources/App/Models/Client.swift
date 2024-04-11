//
//  Client.swift
//
//
//  Created by Dmitriy Permyakov on 10.04.2024.
//

import Vapor

struct Client: Hashable {
    var ws: WebSocket
    var userName: String
    var userID: String
}

// MARK: - Hashable

extension Client {

    static func == (lhs: Client, rhs: Client) -> Bool {
        lhs.userName == rhs.userName && lhs.userID == rhs.userID
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(userName)
        hasher.combine(userID)
    }
}
