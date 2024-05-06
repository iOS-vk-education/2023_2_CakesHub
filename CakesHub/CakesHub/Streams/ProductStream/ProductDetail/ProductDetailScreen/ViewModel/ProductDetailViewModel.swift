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
            sellerID: notification.receiverID,
            customerID: notification.userID
        )
        try await services.notificationService.createNotification(notification: fbNotification)
    }
}

// MARK: - Actions

extension ProductDetailViewModel {

    func didTapLikeButton(isSelected: Bool, completion: CHMVoidBlock?) {}

    func didTapBuyButton(completion: @escaping CHMVoidBlock) {
        guard let currentUser else { return }

        // Отправляем уведомление
        let notification = WSNotification(
            id: UUID().uuidString,
            kind: .notification,
            title: "Покупка торта: \"\(currentProduct.productName)\"",
            date: Date().description,
            message: "Пользователь \"\(currentUser.nickname)\" заказал у вас товар: \"\(currentProduct.productName)\"",
            productID: currentProduct.id,
            userID: currentUser.uid,
            receiverID: currentProduct.seller.id
        )
        services.wsService.send(message: notification) {
            Logger.log(message: "Сообщение отправленно продавцу")
            // TODO: Сделать какой-то алерт об успешной покупке и возможно сделать удаление товара из firebase
            completion()
        }

        // Отправляем уведомление в firebase
        Task {
            do {
                try await sendNotification(notification: notification)
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
