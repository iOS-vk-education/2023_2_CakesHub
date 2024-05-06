//
//  FBNotification.swift
//  CakesHub
//
//  Created by Dmitriy Permyakov on 03.05.2024.
//  Copyright 2024 © VK Team CakesHub. All rights reserved.
//

import Foundation

struct FBNotification: FBModelable {
    let id         : String
    var title      : String
    var date       : String
    var message    : String?
    /// ID Товара
    var productID  : String
    /// Кто получает уведомление
    var receiverID : String
    /// Кто создаёт увидомление
    var creatorID  : String

    static var clear = FBNotification(
        id: .clear,
        title: .clear,
        date: .clear,
        message: .clear,
        productID: .clear,
        receiverID: .clear,
        creatorID: .clear
    )
}

// MARK: - DictionaryConvertible

extension FBNotification {

    init?(dictionary: [String: Any]) {
        guard 
            let id = dictionary["id"] as? String,
            let title = dictionary["title"] as? String,
            let date = dictionary["date"] as? String,
            let productID = dictionary["productID"] as? String,
            let receiverID = dictionary["receiverID"] as? String,
            let creatorID = dictionary["creatorID"] as? String
        else {
            return nil
        }
        let message = dictionary["message"] as? String
        self.init(
            id: id,
            title: title,
            date: date,
            message: message,
            productID: productID,
            receiverID: receiverID,
            creatorID: creatorID
        )
    }
}
