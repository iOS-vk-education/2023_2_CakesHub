//
//  RegisterUserRequest.swift
//  CakesHub
//
//  Created by Dmitriy Permyakov on 02.03.2024.
//  Copyright 2024 © VK Team CakesHub. All rights reserved.
//

import Foundation

struct RegisterUserRequest {
    var nickname : String
    var email    : String
    var password : String
}

// MARK: - MockData

#if DEBUG
extension RegisterUserRequest: Mockable {

    static let mockData = RegisterUserRequest(
        nickname: FBUserModel.mockData.nickname,
        email: FBUserModel.mockData.email,
        password: "123456789"
    )
    static let kind: RegisterUserRequest = .mockData
}
#endif
