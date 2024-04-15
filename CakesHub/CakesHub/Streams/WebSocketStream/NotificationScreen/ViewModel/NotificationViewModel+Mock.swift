//
//  NotificationViewModel+Mock.swift
//  CakesHub
//
//  Created by Dmitriy Permyakov on 31.03.2024.
//

import Foundation

#if DEBUG

extension NotificationViewModel: Mockable {

    static let mockData = NotificationViewModel(notifications: .mockData)
}

extension NotificationModel: Mockable {

    static let mockData = NotificationModel(
        id: 0,
        title: "Доставка",
        text: "Вас ожидает доставщик торта по номеру заказа #12342",
        date: .now,
        userID: 2,
        sellerID: 1,
        isRead: false
    )
}

private extension [NotificationModel] {

    static let mockData: Self = (0...15).map {
        NotificationModel(
            id: $0,
            title: "Доставка \($0)",
            text: "Вас ожидает доставщик торта по номеру заказа #\($0)",
            date: .now,
            userID: 2,
            sellerID: 1,
            isRead: false
        )
    }
}

#endif
