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
    // MARK: Actions
    func didTapRegisterButton() async throws
    func didTapSignInButton() async throws
    // MARK: Memory
    func saveUserInMemory(user: FBUserModel)
    // MARK: Reducers
    func setContext(context: ModelContext)
    func setRootViewModel(viewModel: RootViewModel)
}

// MARK: - AuthViewModel

@Observable
final class AuthViewModel: ViewModelProtocol, AuthViewModelProtocol {
    var inputData: VMAuthInputData
    private(set) var rootViewModel: RootViewModel? = nil
    @ObservationIgnored
    private var services: VMAuthServices
    var context: ModelContext?

    init(
        inputData: VMAuthInputData = .clear,
        services: VMAuthServices = .clear
    ) {
        self.inputData = inputData
        self.services = services
    }
}

// MARK: - Actions

extension AuthViewModel {
    
    /// Нажали кнопку  `регистрация`
    @MainActor
    func didTapRegisterButton() async throws {
        // Регестрируем пользователя
        let uid = try await services.authService.registeUser(with: inputData.mapper)

        // Устанавливаем Web Socket соединение
        startWebSocketLink(userID: uid)

        // Сохраняем данные о пользователе на устройстве
        let fbUser = FBUserModel(uid: uid, nickname: inputData.nickName, email: inputData.email)
        saveUserInMemory(user: fbUser)

        // Обновляем рутового пользователя. Должно выполняться на главном потоке
        rootViewModel?.setCurrentUser(for: fbUser)
    }

    /// Нажали кнопку  `войти`
    @MainActor
    func didTapSignInButton() async throws {
        // Проверяем, зарегестрирован ли пользователь
        let userUID = try await services.authService.loginUser(
            with: LoginUserRequest(email: inputData.email, password: inputData.password)
        )

        // Устанавливаем Web Socket соединение
        startWebSocketLink(userID: userUID)

        // Получаем все данные пользователя
        let userInfo = try await services.userService.getUserInfo(uid: userUID)

        // Обновляем рутового пользователя. Должно выполняться на главном потоке
        rootViewModel?.setCurrentUser(for: userInfo)

        // Сохраняем новые данные на устройстве
        saveUserInMemory(user: userInfo)
    }
}

// MARK: - Memory CRUD

extension AuthViewModel {

    /// Достаём данные о `пользователе` из устройства
    func fetchUserInfo() {
        guard
            let userID = UserDefaults.standard.string(forKey: UserDefaultsKeys.currentUser)
        else {
            Logger.log(kind: .error, message: "UserID is nil")
            return
        }

        var fetchDescriptor = FetchDescriptor<SDUserModel>(
            predicate: #Predicate { $0._id == userID }
        )
        fetchDescriptor.fetchLimit = 1

        do {
            let sdUsers = try context?.fetch(fetchDescriptor)
            guard let sdCurrentUser = sdUsers?.first else {
                Logger.log(kind: .error, message: "Текущий пользователь не найден в БД, но обладает userID в UserDefauls")
                return
            }
            rootViewModel?.setCurrentUser(for: sdCurrentUser.mapper)
        }
        catch {
            Logger.log(kind: .error, message: error.localizedDescription)
        }
    }

    /// Сохраняем данные о `пользователе` на устройство
    func saveUserInMemory(user: FBUserModel) {
        let sdUser = SDUserModel(fbModel: user)
        UserDefaults.standard.set(user.uid, forKey: UserDefaultsKeys.currentUser)
        context?.insert(sdUser)
        do { try self.context?.save(); print("[DEBUG]: Сохранил") }
        catch { Logger.log(kind: .error, message: error.localizedDescription) }
    }
}

// MARK: - Reducers

extension AuthViewModel {

    func setContext(context: ModelContext) {
        self.context = context
    }

    func setRootViewModel(viewModel: RootViewModel) {
        self.rootViewModel = viewModel
    }
}

// MARK: - User Defaults Keys

extension AuthViewModel {

    enum UserDefaultsKeys {
        static let currentUser = "com.vk.AuthViewModel.currentUserID"
    }
}

// MARK: - Inner Methods

private extension AuthViewModel {

    func startWebSocketLink(userID: String) {
        services.wsService.connection { [weak self] error in
            guard let self else { return }
            if let error {
                if error is APIError {
                    Logger.log(kind: .error, message: error.localizedDescription)
                } else {
                    Logger.log(kind: .error, message: error)
                }
                return
            }

            services.wsService.send(
                message: Message.connectionMessage(userID: userID)
            ) {
                Logger.log(kind: .webSocket, message: "Соединение установленно через Auth View")
            }
        }
    }
}
