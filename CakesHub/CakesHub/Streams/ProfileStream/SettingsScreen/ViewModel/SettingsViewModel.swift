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

    func signOut() throws {
        try services.authService.logoutUser()
    }
}

// MARK: - Actions

extension SettingsViewModel {

    func didTapSignOutButton() {
        // Отправляе запрос на Firebase
        try? signOut()
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

// MARK: - Reducers

extension SettingsViewModel {

    func setNavigation(nav: Navigation, modelContext: ModelContext, root: RootViewModel) {
        reducers.nav = nav
        reducers.modelContext = modelContext
        reducers.root = root
    }
}
