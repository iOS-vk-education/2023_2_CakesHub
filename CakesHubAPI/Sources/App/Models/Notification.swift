//
//  Notification.swift
//
//
//  Created by Dmitriy Permyakov on 03.05.2024.
//

import Foundation

struct Notification: Codable, Identifiable {
    let kind       : MessageKind
    let id         : String
    var title      : String
    var date       : String
    var message    : String?
    var productID  : String
    var userID     : String
    var receiverID : String
}
