//
//  VMAuthScreenData.swift
//  CakesHub
//
//  Created by Dmitriy Permyakov on 13.04.2024.
//  Copyright 2024 © VK Team CakesHub. All rights reserved.
//

import Foundation

extension AuthViewModel {

    struct ScreenData: ClearConfigurationProtocol {
        var nickName: String = .clear
        var password: String = .clear
        var email: String = .clear
        var showingAlert = false
        var alertMessage: String?

        static let clear = ScreenData()
    }
}

// MARK: - Mapper

extension AuthViewModel.ScreenData {

    var mapper: RegisterUserRequest {
        RegisterUserRequest(nickname: nickName, email: email, password: password)
    }
}
