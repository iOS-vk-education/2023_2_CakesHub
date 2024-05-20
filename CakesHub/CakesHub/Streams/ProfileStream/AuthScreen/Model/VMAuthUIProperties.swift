//
//  VMAuthUIProperties.swift
//  CakesHub
//
//  Created by Dmitriy Permyakov on 13.04.2024.
//  Copyright 2024 © VK Team CakesHub. All rights reserved.
//

import Foundation

extension AuthViewModel {

    struct UIProperties: ClearConfigurationProtocol {
        var nickName: String = .clear
        var password: String = .clear
        var repeatPassword: String = .clear
        var email: String = .clear
        var showingAlert = false
        var isRegister = false
        var alertMessage: String?

        static let clear = UIProperties()
    }
}

// MARK: - Mapper

extension AuthViewModel.UIProperties {

    var mapper: RegisterUserRequest {
        RegisterUserRequest(nickname: nickName, email: email, password: password)
    }
}
