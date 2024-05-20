//
//  NotificationDetailVMData.swift
//  CakesHub
//
//  Created by Dmitriy Permyakov on 17.05.2024.
//  Copyright 2024 © VKxBMSTU Team CakesHub. All rights reserved.
//

import Foundation

extension NotificationDetailViewModel {

    struct ScreenData: ClearConfigurationProtocol {
        var notification: FBNotification
        var product: FBProductModel?
        var customer: FBUserModel?
        var seller: FBUserModel?
        var deliveryAddress: String?

        init(
            notification: FBNotification = .clear,
            product: FBProductModel? = nil,
            customer: FBUserModel? = nil,
            seller: FBUserModel? = nil,
            deliveryAddress: String? = nil

        ) {
            self.notification = notification
            self.product = product
            self.customer = customer
            self.seller = seller
            self.deliveryAddress = deliveryAddress
        }

        static let clear = ScreenData()
    }
}
