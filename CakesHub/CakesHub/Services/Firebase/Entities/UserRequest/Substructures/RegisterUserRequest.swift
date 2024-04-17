//
//  RegisterUserRequest.swift
//  CakesHub
//
//  Created by Dmitriy Permyakov on 02.03.2024.
//

import Foundation

struct RegisterUserRequest {
    var uid      : String
    var nickname : String
    var email    : String
    var password : String
}

// MARK: - MockData

#if DEBUG
extension RegisterUserRequest: Mockable {

    static let mockData = RegisterUserRequest(
        uid: "D4zfn3CLZjb0d2PWVPIFmGhptHr2",
        nickname: FBUserModel.mockData.nickname,
        email: FBUserModel.mockData.email,
        password: "123456789"
    )
    static let kind: RegisterUserRequest = .mockData
}
#endif
