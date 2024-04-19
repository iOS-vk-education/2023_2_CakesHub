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
    func saveUserInMemory(user: SDUserModel)
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
    private(set) var context: ModelContext?
    @ObservationIgnored
    private let services: VMAuthServices

    init(
        inputData: VMAuthInputData = .clear,
        authService: AuthServiceProtocol = AuthService.shared,
        userService: UserServiceProtocol = UserService.shared
    ) {
        self.inputData = inputData
        self.services = VMAuthServices(authService: authService, userService: userService)
    }
}

// MARK: - Actions

extension AuthViewModel {
    
    /// Нажали кнопку  `регистрация`
    @MainActor
    func didTapRegisterButton() async throws {
        // Регестрируем пользователя
        let uid = try await services.authService.registeUser(with: inputData.mapper)

        // Сохраняем данные о пользователе на устройстве
        let user = SDUserModel(uid: uid, nickName: inputData.nickName, email: inputData.email)
        saveUserInMemory(user: user)

        // Обновляем рутового пользователя. Должно выполняться на главном потоке
        rootViewModel?.setCurrentUser(for: user.mapperInFBUserModel)
    }

    /// Нажали кнопку  `войти`
    @MainActor
    func didTapSignInButton() async throws {
        // Проверяем, зарегестрирован ли пользователь
        let userUID = try await services.authService.loginUser(
            with: LoginUserRequest(email: inputData.email, password: inputData.password)
        )

        // Получаем все данные пользователя
        let userInfo = try await services.userService.getUserInfo(uid: userUID)

        // Обновляем рутового пользователя. Должно выполняться на главном потоке
        rootViewModel?.setCurrentUser(for: userInfo)

        // Сохраняем новые данные на устройстве
        saveUserInMemory(user: SDUserModel(fbModel: userInfo))
    }
}

// MARK: - Memory CRUD

extension AuthViewModel {

    /// Достаём данные о `пользователе` из устройства
    func fetchUserInfo() {
        let fetchDescriptor = FetchDescriptor<SDUserModel>()

        do {
            guard let userInfo = try context?.fetch(fetchDescriptor).first else { return }
            rootViewModel?.setCurrentUser(for: userInfo.mapperInFBUserModel)
        } catch {
            Logger.log(kind: .error, message: error)
        }
    }

    /// Сохраняем данные о `пользователе` на устройство
    func saveUserInMemory(user: SDUserModel) {
        DispatchQueue.global(qos: .utility).async {
            self.context?.insert(user)
            do {
                try self.context?.save()
            } catch {
                Logger.log(kind: .error, message: error)
            }
        }
    }
}

// MARK: - Reducers

extension AuthViewModel {

    func setContext(context: ModelContext) {
        if self.context.isNil {
            self.context = context
        }
    }

    func setRootViewModel(viewModel: RootViewModel) {
        self.rootViewModel = viewModel
    }
}
