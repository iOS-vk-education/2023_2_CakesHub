//
//  WSNotification.swift
//  CakesHub
//
//  Created by Dmitriy Permyakov on 03.05.2024.
//

import Foundation

struct WSNotification: Codable {
    let id         : String
    let kind       : WSMessageKind
    var title      : String
    var date       : String
    var message    : String?
    var productID  : String
    var userID     : String
    var receiverID : String
}
