//
//  AuthViewModel.swift
//  CakesHub
//
//  Created by Dmitriy Permyakov on 13.04.2024.
//  Copyright 2024 © VKxBMSTU Team CakesHub. All rights reserved.
//

import SwiftUI
import SwiftData
import Observation

// MARK: - AuthViewModelProtocol

protocol AuthViewModelProtocol: AnyObject {
    // Actions
    func didTapRegisterButton() async throws
    func didTapSignInButton() async throws -> String
    // Memory
    func saveUserInMemory(uid: String)
    // Reducers
    func setContext(context: ModelContext)
}

// MARK: - AuthViewModel

@Observable
final class AuthViewModel: ViewModelProtocol, AuthViewModelProtocol {
    var inputData: UserInputData
    @ObservationIgnored
    private(set) var context: ModelContext?
    private(set) var currentUser: CurrentUserModel? = nil
    @ObservationIgnored
    private let authService: AuthServiceProtocol

    init(inputData: UserInputData = .clear, authService: AuthServiceProtocol = AuthService.shared) {
        self.inputData = inputData
        self.authService = authService
    }
}

// MARK: - Actions

extension AuthViewModel {
    
    /// Нажали кнопку  `регистрация`
    func didTapRegisterButton() async throws {
        let uid = try await authService.registeUser(with: inputData.mapper)
        saveUserInMemory(uid: uid)
    }

    /// Нажали кнопку  `войти`
    func didTapSignInButton() async throws -> String {
        try await authService.loginUser(
            with: LoginUserRequest(email: inputData.email, password: inputData.password)
        ).user.uid
    }
}

// MARK: - Memory CRUD

extension AuthViewModel {

    /// Достаём данные о `пользователе` из устройства
    func fetchUserInfo() {
        let fetchDescriptor = FetchDescriptor<CurrentUserModel>()
        currentUser = try? context?.fetch(fetchDescriptor).first
    }

    /// Сохраняем данные о `пользователе` на устройство
    func saveUserInMemory(uid: String) {
        let user = CurrentUserModel(uid: uid, nickName: inputData.nickName, email: inputData.email)
        context?.insert(user)
        try? context?.save()
        currentUser = user
    }
}

// MARK: - Reducers

extension AuthViewModel {

    func setContext(context: ModelContext) {
        if self.context.isNil {
            self.context = context
        }
    }
}
