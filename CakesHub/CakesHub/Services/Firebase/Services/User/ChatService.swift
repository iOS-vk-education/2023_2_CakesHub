//
//
//  ChatService.swift
//  CakesHub
//
//  Created by Dmitriy Permyakov on 08.05.2024.
//  Copyright 2024 © VK Team CakesHub. All rights reserved.
//

import Foundation
import FirebaseFirestore

protocol ChatServiceProtocol: AnyObject {
    func fetchUserMessages(userID: String) async throws -> [FBChatMessageModel]
    func create(message: FBChatMessageModel) async throws
}

// MARK: - ChatService

final class ChatService {

    static let shared: ChatServiceProtocol = ChatService()
    private let firestore = Firestore.firestore()
    private let collection = FirestoreCollections.messages.rawValue

    private init() {}
}

// MARK: - ChatServiceProtocol

extension ChatService: ChatServiceProtocol {

    /// Получение всех сообщений пользователя
    /// - Parameter userID: ID текущего пользователя
    func fetchUserMessages(userID: String) async throws -> [FBChatMessageModel] {
        let query = firestore.collection(collection).whereFilter(
            .orFilter([
                .whereField("receiverID", isEqualTo: userID),
                .whereField("userID", isEqualTo: userID)
            ])
        )
        let snapshots = try await query.getDocuments()
        let messages = snapshots.documents.compactMap {
            FBChatMessageModel(dictionary: $0.data())
        }
        return messages
    }
    
    /// Отправка сообщения
    func create(message: FBChatMessageModel) async throws {
        let documentRef = firestore.collection(collection).document(message.id)
        try await documentRef.setData(message.dictionaryRepresentation)
    }
}
