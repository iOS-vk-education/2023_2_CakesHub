//
//  VMAuthServices.swift
//  CakesHub
//
//  Created by Dmitriy Permyakov on 16.04.2024.
//

import Foundation

extension AuthViewModel {

    struct VMAuthServices {
        let authService: AuthServiceProtocol
        let userService: UserServiceProtocol
    }
}
