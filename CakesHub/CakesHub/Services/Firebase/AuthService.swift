//
//  AuthService.swift
//  CakesHub
//
//  Created by Dmitriy Permyakov on 02.03.2024.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

// MARK: - AuthServiceProtocol

protocol AuthServiceProtocol {
    func registeUser(with userRequest: RegisterUserRequest) async throws -> String
    func loginUser(with userRequest: LoginUserRequest) async throws -> AuthDataResult
    func logoutUser() throws
}

// MARK: - AuthService

final class AuthService {

    static var shared = AuthService()
    private var auth = Auth.auth()

    private init() {}
}

// MARK: - Methods

extension AuthService: AuthServiceProtocol {

    func registeUser(with userRequest: RegisterUserRequest) async throws -> String {
        let result = try await auth.createUser(withEmail: userRequest.email, password: userRequest.password)
        let user = result.user
        let db = Firestore.firestore()
        let uid = user.uid
        let userData = [
            "uid": uid,
            "nickname": userRequest.nickname,
            "email": userRequest.email
        ]
        try await db.collection(FirestoreCollections.users.rawValue).document(user.uid).setData(userData)
        return uid
    }

    func loginUser(with userRequest: LoginUserRequest) async throws -> AuthDataResult {
        try await auth.signIn(withEmail: userRequest.email, password: userRequest.password)
    }

    func logoutUser() throws {
        try auth.signOut()
    }
}
