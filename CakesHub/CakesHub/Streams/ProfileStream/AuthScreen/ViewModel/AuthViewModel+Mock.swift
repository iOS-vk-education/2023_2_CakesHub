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
        inputData: VMAuthInputData(
            nickName: "mightyK1ngRichard",
            password: "123456789",
            email: "dimapermyakov55@gmail.com"
        )
    )

    static let poly = AuthViewModel(
        inputData: VMAuthInputData(
            nickName: "Полиночка",
            password: "123456789",
            email: "kakashek@gmail.com"
        )
    )
}
#endif
