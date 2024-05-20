//
//  SettingsViewModel.swift
//  CakesHub
//
//  Created by Dmitriy Permyakov on 14.05.2024.
//  Copyright 2024 © VKxBMSTU Team CakesHub. All rights reserved.
//

import Foundation
import Observation
import SwiftData

protocol SettingsViewModelProtocol: AnyObject {
    // MARK: Network
    func signOut() throws
    // MARK: Actions
    func didTapSignOutButton()
    func didTapDeleteAccount()
    // MARK: Memory
    func deleteChatHistoryFromMemory()
    // MARK: Reducers
    func setNavigation(nav: Navigation, modelContext: ModelContext, root: RootViewModel)
}

// MARK: - SettingsViewModel

@Observable
final class SettingsViewModel: ViewModelProtocol, SettingsViewModelProtocol {
    var uiProperties: UIProperties
    private(set) var data: ScreenData
    private(set) var services: Services
    private var reducers: Reducers

    init(
        uiProperties: UIProperties = .clear,
        data: ScreenData = .clear,
        services: Services = .clear,
        reducers: Reducers = .clear
    ) {
        self.uiProperties = uiProperties
        self.data = data
        self.services = services
        self.reducers = reducers
    }
}

// MARK: - Network

extension SettingsViewModel {

    @MainActor 
    func signOut() throws {
        try services.authService.logoutUser()
        deleteChatHistoryFromMemory()
    }

    func deleteUser() async throws {
        let userID = reducers.root.currentUser.uid
        Task.detached {
            try await self.services.cakeService.deleteUserProducts(sellerID: userID)
        }
        Task.detached {
            try await self.services.userService.deleteUserInfo(uid: userID)
        }
        try await services.authService.deleteUser()
    }
}

// MARK: - Actions

extension SettingsViewModel {

    @MainActor 
    func didTapSignOutButton() {
        // Отправляе запрос на Firebase
        do {
            try signOut()
            resetData()
        } catch {
            Logger.log(kind: .error, message: error.localizedDescription)
        }
    }

    func didTapDeleteAccount() {
        Task {
            try? await deleteUser()
            await deleteChatHistoryFromMemory()
            await resetData()
        }
    }

    @MainActor
    private func resetData() {
        // Сбрасываем информацию текущего пользователя
        reducers.root.resetUser()
        // Удаляем id текущего пользователя из user defaults
        UserDefaults.standard.removeObject(forKey: AuthViewModel.UserDefaultsKeys.currentUser)
        // Отключаем web socket соединение
        services.wsService.close()
        // Спускаемся на экран авторизации
        reducers.nav.goToRoot()
    }
}

// MARK: - Memory

extension SettingsViewModel {

    @MainActor
    func deleteChatHistoryFromMemory() {
        try? reducers.modelContext.delete(model: SDChatMessageModel.self)
    }
}


// MARK: - Reducers

extension SettingsViewModel {

    func setNavigation(nav: Navigation, modelContext: ModelContext, root: RootViewModel) {
        reducers.nav = nav
        reducers.modelContext = modelContext
        reducers.root = root
    }
}
