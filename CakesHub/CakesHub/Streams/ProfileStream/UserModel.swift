//
//  UserModel.swift
//  CakesHub
//
//  Created by Milana Shakhbieva on 25.03.2024.
//

import SwiftUI

struct UserModel {
    var name: String = .clear
    var surname: String = .clear
    var mail: String = .clear
    var orders: Int = 0
    var userImage: ImageKind = .clear
}

#if DEBUG

extension UserModel: Mockable {
    
    static let mockData = UserModel(
        name: "Milana",
        surname: "Shakhbieva",
        mail: "milanashakhbieva@mail.com",
        orders: 555,
        userImage: .uiImage(.cake2)
    )
}

#endif
