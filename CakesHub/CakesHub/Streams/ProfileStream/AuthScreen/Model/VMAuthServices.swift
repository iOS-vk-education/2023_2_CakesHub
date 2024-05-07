//
//  VMAuthServices.swift
//  CakesHub
//
//  Created by Dmitriy Permyakov on 16.04.2024.
//  Copyright 2024 © VK Team CakesHub. All rights reserved.
//

import Foundation

extension AuthViewModel {

    struct VMAuthServices {
        let authService: AuthServiceProtocol = AuthService.shared
        let userService: UserServiceProtocol = UserService.shared
        let wsService: WebSockerManagerProtocol = WebSockerManager.shared

        static let clear = VMAuthServices()
    }
}
