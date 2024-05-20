//
//  UserService.swift
//  CakesHub
//
//  Created by Dmitriy Permyakov on 14.04.2024.
//  Copyright 2024 © VK Team CakesHub. All rights reserved.
//

import Foundation
import FirebaseFirestore
import FirebaseStorage

// MARK: - UserServiceProtocol

protocol UserServiceProtocol {
    func getUserInfo(uid userUID: String) async throws -> FBUserModel
    func updateUserInfo(with user: FBUserModel) async throws
    func deleteUserInfo(uid: String) async throws
    func createUserInfo(for user: FBUserModel) async throws
    func addUserAddress(for userID: String, address: String) async throws
    func updateUserImage(userID: String, uiImage: UIImage, kind: UserService.UserImageKind) async throws
}

// MARK: - UserService

final class UserService {
    
    static let shared: UserServiceProtocol = UserService()

    private let storage = Storage.storage()
    private let db = Firestore.firestore()
    private let collection = FirestoreCollections.users.rawValue

    private init() {}
    
    /// Вид фотографии пользователя
    enum UserImageKind: String {
        case avatar = "avatarImage"
        case header = "headerImage"
    }
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

    /// Добавления адреса пользователя
    func addUserAddress(for userID: String, address: String) async throws {
        let docRef = db.collection(collection).document(userID)
        try await docRef.updateData(["address": address])
    }
    
    /// Обновление фотографии пользователя
    func updateUserImage(userID: String, uiImage: UIImage, kind: UserImageKind) async throws {
        guard let imageData = uiImage.jpegData(compressionQuality: 1) else {
            throw APIError.badParameters
        }
        let imageURL = try await createImage(imageData: imageData)
        let docRef = db.collection(collection).document(userID)
        try await docRef.updateData([kind.rawValue: imageURL.absoluteString])
    }
}

// MARK: - Helper

private extension UserService {
    
    /// Создание фотографии
    func createImage(imageData: Data) async throws -> URL {
       let imageName = UUID().uuidString
       let storageRef = storage.reference().child("users/\(imageName).jpg")
       let _ = try await storageRef.putDataAsync(imageData)
       let downloadURL = try await storageRef.downloadURL()
       return downloadURL
   }
}
