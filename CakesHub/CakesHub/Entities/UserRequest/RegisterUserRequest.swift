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
    
    /// UID: 8n5di1sb8ya1I9Tc2uR8TWpgtsK2
    static let mockData = RegisterUserRequest(nickname: "mightyK1ngRichard", email: "dimapermyakov55@gmail.com", password: "123456789")
}
#endif
