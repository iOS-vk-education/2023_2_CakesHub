//
//  NotificationModel.swift
//  CakesHub
//
//  Created by Dmitriy Permyakov on 26/11/2023.
//  Copyright 2023 © VK Team CakesHub. All rights reserved.
//

import Foundation

struct NotificationModel: Identifiable {
    let id: String
    var title: String
    var text: String?
    var date: String
    var userID: String
    var sellerID: String
    var productID: String
}

// MARK: - Mapper

extension NotificationModel {

    var mapper: FBNotification {
        FBNotification(
            id: id,
            title: title,
            date: date,
            message: text,
            productID: productID,
            receiverID: userID,
            creatorID: sellerID
        )
    }
}

extension FBNotification {

    var mapper: NotificationModel {
        NotificationModel(
            id: id,
            title: title,
            text: message,
            date: date.toCorrectDate,
            userID: receiverID,
            sellerID: creatorID,
            productID: productID
        )
    }
}

extension WSNotification {

    var mapper: NotificationModel {
        NotificationModel(
            id: id,
            title: title,
            text: message,
            date: date.toCorrectDate,
            userID: receiverID,
            sellerID: userID,
            productID: productID
        )
    }
}
