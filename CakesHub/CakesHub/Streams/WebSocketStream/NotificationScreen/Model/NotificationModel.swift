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
}

// MARK: - Mapper

extension FBNotification {

    var mapper: NotificationModel {
        NotificationModel(
            id: id,
            title: title,
            text: message,
            date: date.toCorrectDate,
            userID: customerID,
            sellerID: sellerID
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
            sellerID: userID
        )
    }
}

// MARK: - Helper

private extension String {

    var toCorrectDate: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
        if let date = dateFormatter.date(from: self) {
            return date.formatted(.dateTime.year().day().month(.wide))
        } else {
            return self
        }
    }
}
