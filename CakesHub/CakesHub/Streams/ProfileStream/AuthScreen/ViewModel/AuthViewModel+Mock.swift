//
//  AuthViewModel+Mock.swift
//  CakesHub
//
//  Created by Dmitriy Permyakov on 13.04.2024.
//  Copyright 2024 © VKxBMSTU Team CakesHub. All rights reserved.
//

import Foundation
import SwiftData

#if DEBUG
extension AuthViewModel: Mockable {

    static let mockData = AuthViewModel(
        uiProperies: UIProperties(
            nickName: "mightyK1ngRichard",
            password: "123456789",
            email: "dimapermyakov55@gmail.com",
            isRegister: true
        )
    )

    static let poly = AuthViewModel(
        uiProperies: UIProperties(
            nickName: "Полиночка",
            password: "123456789",
            email: "kakashek@gmail.com"
        )
    )
}
#endif
