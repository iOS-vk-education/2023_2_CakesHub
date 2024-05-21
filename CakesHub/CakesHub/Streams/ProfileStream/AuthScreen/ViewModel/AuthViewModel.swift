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
    func didTapRegisterButton()
    func didTapSignInButton()
    // MARK: Memory
    func saveUserInMemory(user: FBUserModel)
    // MARK: Reducers
    func setContext(context: ModelContext)
    func setRootViewModel(viewModel: RootViewModel)
}

// MARK: - AuthViewModel

@Observable
final class AuthViewModel: ViewModelProtocol, AuthViewModelProtocol {
    var uiProperies: UIProperties
    @ObservationIgnored
    private var services: VMAuthServices
    @ObservationIgnored
    private var reducers: Reducers

    init(
        uiProperies: UIProperties = .clear,
        services: VMAuthServices = .clear,
        reducers: Reducers = .clear
    ) {
        self.uiProperies = uiProperies
        self.services = services
        self.reducers = reducers
    }
}

// MARK: - Network

extension AuthViewModel {

    @MainActor
    func registerUser() {
        Task {
            do {
                // Регестрируем пользователя
                let uid = try await services.authService.registeUser(with: uiProperies.mapper)

                // Устанавливаем Web Socket соединение
                startWebSocketLink(userID: uid)

                // Сохраняем данные о пользователе на устройстве
                let fbUser = FBUserModel(uid: uid, nickname: uiProperies.nickName, email: uiProperies.email)
                saveUserInMemory(user: fbUser)

                // Обновляем рутового пользователя. Должно выполняться на главном потоке
                reducers.rootViewModel.setCurrentUser(for: fbUser)
            } catch {
                generateErrorMessage(error: error)
            }
        }
    }

    /// Нажали кнопку  `войти`
    @MainActor
    func didTapSignInButton() {
        Task {
            do {
                // Проверяем, зарегестрирован ли пользователь
                let userUID = try await services.authService.loginUser(
                    with: LoginUserRequest(email: uiProperies.email, password: uiProperies.password)
                )

                // Устанавливаем Web Socket соединение
                startWebSocketLink(userID: userUID)

                // Получаем все данные пользователя
                let userInfo = try await services.userService.getUserInfo(uid: userUID)

                // Обновляем рутового пользователя. Должно выполняться на главном потоке
                reducers.rootViewModel.setCurrentUser(for: userInfo)

                // Сохраняем новые данные на устройстве
                saveUserInMemory(user: userInfo)
            } catch {
                generateErrorMessage(error: error)
            }
        }
    }

    private func generateErrorMessage(error: any Error) {
        uiProperies.showingAlert = true
        uiProperies.alertMessage = error.localizedDescription
        Logger.log(kind: .error, message: error)
    }
}

// MARK: - Actions

extension AuthViewModel {

    /// Нажали кнопку  `регистрация`
    @MainActor
    func didTapRegisterButton() {
        if uiProperies.nickName.isEmpty || uiProperies.email.isEmpty || uiProperies.password.isEmpty {
            uiProperies.showingAlert = true
            uiProperies.alertMessage = String(localized: "Fill in all the fields.")
        } else if uiProperies.password != uiProperies.repeatPassword {
            uiProperies.showingAlert = true
            uiProperies.alertMessage = String(localized: "The passwords don't match.")
        } else if !isValidEmail(uiProperies.email) {
            uiProperies.showingAlert = true
            uiProperies.alertMessage = String(localized: "Invalid email format.")
        } else if !isValidPassword(uiProperies.password) {
            uiProperies.showingAlert = true
            uiProperies.alertMessage = String(localized: "The password format is incorrect.")
        } else {
            registerUser()
        }
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
            let sdUsers = try reducers.context.fetch(fetchDescriptor)
            guard let sdCurrentUser = sdUsers.first else {
                Logger.log(kind: .error, message: "Текущий пользователь не найден в БД, но обладает userID в UserDefauls")
                return
            }
            reducers.rootViewModel.setCurrentUser(for: sdCurrentUser.mapper)
        }
        catch {
            Logger.log(kind: .error, message: error.localizedDescription)
        }
    }

    /// Сохраняем данные о `пользователе` на устройство
    func saveUserInMemory(user: FBUserModel) {
        let sdUser = SDUserModel(fbModel: user)
        UserDefaults.standard.set(user.uid, forKey: UserDefaultsKeys.currentUser)
        reducers.context.insert(sdUser)
        do { try reducers.context.save() }
        catch { Logger.log(kind: .error, message: error.localizedDescription) }
    }
}

// MARK: - Reducers

extension AuthViewModel {

    func setContext(context: ModelContext) {
        reducers.context = context
    }

    func setRootViewModel(viewModel: RootViewModel) {
        reducers.rootViewModel = viewModel
    }
}

// MARK: - User Defaults Keys

extension AuthViewModel {

    enum UserDefaultsKeys {
        static let currentUser = "com.vk.AuthViewModel.currentUserID"
    }
}

// MARK: - Inner Methods

extension AuthViewModel {

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
                message: WSMessage.connectionMessage(userID: userID)
            ) { [weak self] in
                guard let self else { return }
                Logger.log(kind: .webSocket, message: "Соединение установленно через Auth View")

                services.wsService.receive { data in
                    do {
                        let message = try JSONDecoder().decode(WSMessage.self, from: data)
                        DispatchQueue.main.async {
                            NotificationCenter.default.post(
                                name: .WebSocketNames.message,
                                object: message
                            )
                        }
                        return
                    } catch {
                        do {
                            let notification = try JSONDecoder().decode(WSNotification.self, from: data)
                            DispatchQueue.main.async {
                                NotificationCenter.default.post(
                                    name: .WebSocketNames.notification,
                                    object: notification
                                )
                            }
                            return
                        } catch {
                            Logger.log(kind: .error, message: error.localizedDescription)
                        }
                    }
                }
            }
        }
    }

    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\\.[a-zA-Z0-9-.]+$"
        let emailPred = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }

    func isValidPassword(_ password: String) -> Bool {
        let passwordRegex = "^(?=.*[A-Za-z])(?=.*\\d).{6,}$"
        return NSPredicate(format: "SELF MATCHES %@", passwordRegex).evaluate(with: password)
    }
}
