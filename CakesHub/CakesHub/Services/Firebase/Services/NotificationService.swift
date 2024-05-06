//
//  NotificationService.swift
//  CakesHub
//
//  Created by Dmitriy Permyakov on 03.05.2024.
//  Copyright 2024 © VK Team CakesHub. All rights reserved.
//

import Foundation
import Firebase
import FirebaseFirestore

protocol NotificationServiceProtocol: AnyObject {
    func createNotification(notification: FBNotification) async throws
    func deleteNotification(id: String) async throws
    func getNotifications(customerID: String) async throws -> [FBNotification]
}

// MARK: - NotificationService

final class NotificationService {

    static let shared: NotificationServiceProtocol = NotificationService()
    private let collection = FirestoreCollections.notification.rawValue
    private let firestore = Firestore.firestore()

    private init() {}
}

// MARK: - Actions

extension NotificationService: NotificationServiceProtocol {
    
    /// Создание уведомления
    func createNotification(notification: FBNotification) async throws {
        let docRef = firestore.collection(collection).document(notification.id)
        try await docRef.setData(notification.dictionaryRepresentation)
    }

    /// Получение уведомлений покупателя
    /// - Parameter customerID: ID покупателя
    func getNotifications(customerID: String) async throws -> [FBNotification] {
        let query = firestore
            .collection(collection)
            .whereField("customerID", isEqualTo: customerID)
            .whereField("sellerID", isEqualTo: customerID)
        let snapshots = try await query.getDocuments()
        let notifications = snapshots.documents.compactMap {
            FBNotification(dictionary: $0.data())
        }
        return notifications
    }
    
    /// Удаление уведомления
    /// - Parameter id: ID уведомления
    func deleteNotification(id: String) async throws {
        try await firestore.collection(collection).document(id).delete()
    }
}
