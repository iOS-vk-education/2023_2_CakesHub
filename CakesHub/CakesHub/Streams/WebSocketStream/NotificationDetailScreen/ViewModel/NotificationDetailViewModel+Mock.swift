//
//  NotificationDetailViewModel+Mock.swift
//  CakesHub
//
//  Created by Dmitriy Permyakov on 17.05.2024.
//  Copyright 2024 © VKxBMSTU Team CakesHub. All rights reserved.
//

import Foundation

#if DEBUG

extension NotificationDetailViewModel: Mockable {

    static let mockData = NotificationDetailViewModel(
        data: .init(notification: .mockData, customer: .king, seller: .poly)
    )
}

// MARK: - Constants

extension FBNotification: Mockable {

    static let mockData = FBNotification(
        id: "123",
        title: "Вы заказали у нас торт",
        date: Date().description,
        message: "Это просто описание уведомления",
        productID: "1",
        receiverID: "2",
        creatorID: "3"
    )
}

#endif
