//
//  UserService.swift
//  CakesHub
//
//  Created by Dmitriy Permyakov on 14.04.2024.
//  Copyright 2024 © VK Team CakesHub. All rights reserved.
//

import Foundation
import FirebaseFirestore

// MARK: - UserServiceProtocol

protocol UserServiceProtocol {
    func getUserInfo(uid userUID: String) async throws -> FBUserModel
    func updateUserInfo(with user: FBUserModel) async throws
    func deleteUserInfo(uid: String) async throws
    func createUserInfo(for user: FBUserModel) async throws
    func addUserAddress(for userID: String, address: String) async throws
}

// MARK: - UserService

final class UserService {
    
    static let shared = UserService()
    private let db = Firestore.firestore()
    private let collection = FirestoreCollections.users.rawValue

    private init() {}
}

// MARK: - Methods

extension UserService: UserServiceProtocol {

    /// Получение данных пользователя по `uid`
    func getUserInfo(uid userUID: String) async throws -> FBUserModel {
        let docRef = db.collection(collection).document(userUID)
        let snapshot = try await docRef.getDocument()
        guard let data = snapshot.data() else {
            throw APIError.dataIsNil
        }
        guard let user = FBUserModel(dictionary: data) else {
            throw APIError.uidNotFound
        }
        return user
    }
    
    /// Обновление данных о пользователе
    /// - Parameter user: новые данные о пользователе
    func updateUserInfo(with user: FBUserModel) async throws {
        let docRef = db.collection(collection).document(user.uid)
        try await docRef.setData(user.dictionaryRepresentation)
    }

    /// Удаление данных о пользователе
    func deleteUserInfo(uid: String) async throws {
        let docRef = db.collection(collection).document(uid)
        try await docRef.delete()
    }

    /// Создание нового пользователя
    func createUserInfo(for user: FBUserModel) async throws {
        let docRef = db.collection(collection).document(user.uid)
        try await docRef.setData(user.dictionaryRepresentation)
    }

    func addUserAddress(for userID: String, address: String) async throws {
        let docRef = db.collection(collection).document(userID)
        try await docRef.updateData(["address": address])
    }
}
