//
//
//  SettingsVMServices.swift
//  CakesHub
//
//  Created by Dmitriy Permyakov on 14.05.2024.
//  Copyright 2024 © VK Team CakesHub. All rights reserved.
//

import Foundation

extension SettingsViewModel {

    struct Services: ClearConfigurationProtocol {

        var authService: AuthServiceProtocol
        var userService: UserServiceProtocol
        var cakeService: CakeServiceProtocol
        var wsService: WebSockerManagerProtocol

        init(
            authService: AuthServiceProtocol = AuthService.shared,
            userService: UserServiceProtocol = UserService.shared,
            cakeService: CakeServiceProtocol = CakeService.shared,
            wsService: WebSockerManagerProtocol = WebSockerManager.shared
        ) {
            self.authService = authService
            self.userService = userService
            self.cakeService = cakeService
            self.wsService = wsService
        }

        static let clear = Services()
    }
}
