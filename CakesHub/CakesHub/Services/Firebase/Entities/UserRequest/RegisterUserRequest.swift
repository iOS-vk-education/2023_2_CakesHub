//
//  RegisterUserRequest.swift
//  CakesHub
//
//  Created by Dmitriy Permyakov on 02.03.2024.
//

import Foundation

struct RegisterUserRequest {
    var nickname: String
    var email: String
    var password: String
}

// MARK: - MockData

#if DEBUG
extension RegisterUserRequest: Mockable {
    
    /// `UID`: D4zfn3CLZjb0d2PWVPIFmGhptHr2
    static let mockData = RegisterUserRequest(
        nickname: UserRequest.mockData.nickname,
        email: UserRequest.mockData.email,
        password: "123456789"
    )
}
#endif
