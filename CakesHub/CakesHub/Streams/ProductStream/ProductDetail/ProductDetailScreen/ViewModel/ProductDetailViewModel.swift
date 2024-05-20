//
//  NewProductDetailViewModel.swift
//  CakesHub
//
//  Created by Dmitriy Permyakov on 04.02.2024.
//  Copyright 2024 © VK Team CakesHub. All rights reserved.
//

import Foundation
import Observation

protocol NewDetailScreenViewModelProtocol {
    // MARK: Network
    func sendNotification(notification: WSNotification) async throws
    // MARK: Actions
    func didTapLikeButton(isSelected: Bool, completion: CHMVoidBlock?)
    func didTapBuyButton(completion: @escaping CHMVoidBlock)
    // MARK: Reducers
    func setCurrentUser(user: FBUserModel)
}

@Observable
final class ProductDetailViewModel: ViewModelProtocol, NewDetailScreenViewModelProtocol {

    var currentProduct: ProductModel
    var currentUser: FBUserModel?
    var services: VMServices

    init(data: ProductModel, services: VMServices = .clear) {
        self.currentProduct = data
        self.services = services
    }
}

// MARK: - Network
extension ProductDetailViewModel {

    /// Отправляем уведомление в firebase
    func sendNotification(notification: WSNotification) async throws {
        let fbNotification = FBNotification(
            id: notification.id,
            title: notification.title,
            date: notification.date,
            message: notification.message,
            productID: notification.productID,
            receiverID: notification.receiverID,
            creatorID: notification.userID
        )
        try await services.notificationService.createNotification(notification: fbNotification)
    }
}

// MARK: - Actions

extension ProductDetailViewModel {

    func didTapLikeButton(isSelected: Bool, completion: CHMVoidBlock?) {}

    func didTapBuyButton(completion: @escaping CHMVoidBlock) {
        guard let currentUser else { return }

        // Формируем модели уведомлений
        let purchaseDate = Date().description
        let sellerID = currentProduct.seller.id
        let customerID = currentUser.uid
        let productName = currentProduct.productName
        let productID = currentProduct.id

        let sellerNotification = generateNotificationForSeller(
            date: purchaseDate,
            sellerID: sellerID,
            customerID: customerID,
            customerName: currentUser.nickname,
            productName: productName,
            productID: productID
        )
        let customerNotification = generateNotificationForCustomer(
            date: purchaseDate,
            sellerID: sellerID,
            customerID: customerID,
            sellerName: currentProduct.seller.name,
            productPrice: currentProduct.price,
            productName: productName,
            productID: productID
        )

        // Отправляем уведомления по Web Socket протоколу
        services.wsService.send(message: sellerNotification) {
            Logger.log(message: "Уведомление отправленно продавцу")
        }
        services.wsService.send(message: customerNotification) {
            Logger.log(message: "Уведомление отправленно покупателю")
        }

        // Отправляем уведомление в firebase
        Task {
            do {
                try await sendNotification(notification: sellerNotification)
                DispatchQueue.main.async {
                    completion()
                }
            } catch {
                Logger.log(kind: .error, message: error.localizedDescription)
            }
        }
        Task {
            do {
                try await sendNotification(notification: customerNotification)
            } catch {
                Logger.log(kind: .error, message: error.localizedDescription)
            }
        }
    }
}

// MARK: - Reducers

extension ProductDetailViewModel {

    func setCurrentUser(user: FBUserModel) {
        currentUser = user
    }
}

// MARK: - Helper

private extension ProductDetailViewModel {

    func generateNotificationForSeller(
        date: String,
        sellerID: String,
        customerID: String,
        customerName: String,
        productName: String,
        productID: String
    ) -> WSNotification {
        WSNotification(
            id: UUID().uuidString,
            kind: .notification,
            title: "У вас заказали торт: \"\(productName)\"",
            date: date,
            message: "Пользователь \"\(customerName)\" заказал у вас торт: \"\(productName)\"",
            productID: productID,
            userID: customerID,
            receiverID: sellerID
        )
    }

    func generateNotificationForCustomer(
        date: String,
        sellerID: String,
        customerID: String,
        sellerName: String,
        productPrice: String,
        productName: String,
        productID: String
    ) -> WSNotification {
        WSNotification(
            id: UUID().uuidString,
            kind: .notification,
            title: "Вы заказали торт: \"\(productName)\"",
            date: date,
            message: "Вы заказали торт: \"\(productName)\" по цене \(productPrice) у продавца: \(sellerName)",
            productID: productID,
            userID: sellerID,
            receiverID: customerID
        )
    }
}

