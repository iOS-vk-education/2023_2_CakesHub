//
//  UserInputData.swift
//  CakesHub
//
//  Created by Dmitriy Permyakov on 13.04.2024.
//

import Foundation

extension AuthViewModel {

    struct VMAuthInputData: ClearConfigurationProtocol {
        var uid: String
        var nickName: String
        var password: String
        var email: String

        static let clear = VMAuthInputData(uid: .clear, nickName: .clear, password: .clear, email: .clear)
    }
}

// MARK: - Mapper

extension AuthViewModel.VMAuthInputData {

    var mapper: RegisterUserRequest {
        RegisterUserRequest(uid: uid, nickname: nickName, email: email, password: password)
    }
}
