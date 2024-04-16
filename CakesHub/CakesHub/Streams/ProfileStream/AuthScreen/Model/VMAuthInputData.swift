//
//  UserInputData.swift
//  CakesHub
//
//  Created by Dmitriy Permyakov on 13.04.2024.
//

import Foundation

extension AuthViewModel {

    struct VMAuthInputData: ClearConfigurationProtocol {
        var nickName: String = .clear
        var password: String = .clear
        var email: String = .clear

        static let clear = VMAuthInputData()
    }
}

// MARK: - Mapper

extension AuthViewModel.VMAuthInputData {

    var mapper: RegisterUserRequest {
        RegisterUserRequest(nickname: nickName, email: email, password: password)
    }
}
