//
//  UserInputData.swift
//  CakesHub
//
//  Created by Dmitriy Permyakov on 13.04.2024.
//

import Foundation

struct UserInputData: ClearConfigurationProtocol {
    var nickName: String = .clear
    var password: String = .clear
    var email: String = .clear

    static let clear = UserInputData()
}

// MARK: - Mapper

extension UserInputData {

    var mapper: RegisterUserRequest {
        RegisterUserRequest(nickname: nickName, email: email, password: password)
    }
}
