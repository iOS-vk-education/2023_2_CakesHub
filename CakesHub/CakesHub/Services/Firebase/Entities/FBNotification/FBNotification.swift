//
//  FBNotification.swift
//  CakesHub
//
//  Created by Dmitriy Permyakov on 03.05.2024.
//  Copyright 2024 © VK Team CakesHub. All rights reserved.
//

import Foundation

struct FBNotification: FBModelable {
    let id: String
    var title: String
    var date: String
    var message: String?
    var productID: String
    var sellerID: String
    var customerID: String

    static var clear = FBNotification(
        id: .clear,
        title: .clear,
        date: .clear,
        message: .clear,
        productID: .clear,
        sellerID: .clear,
        customerID: .clear
    )
}

// MARK: - DictionaryConvertible

extension FBNotification {

    init?(dictionary: [String : Any]) {
        guard 
            let id = dictionary["id"] as? String,
            let title = dictionary["title"] as? String,
            let date = dictionary["date"] as? String,
            let productID = dictionary["productID"] as? String,
            let sellerID = dictionary["sellerID"] as? String,
            let customerID = dictionary["customerID"] as? String
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
            sellerID: sellerID,
            customerID: customerID
        )
    }
}
