//
//  CurrentUserModel.swift
//  CakesHub
//
//  Created by Dmitriy Permyakov on 13.04.2024.
//

import SwiftData

@Model
class CurrentUserModel {
    var uid: String
    var nickName: String
    var email: String
    var userImageURL: String
    var userHeaderImageURL: String

    init(
        uid: String,
        nickName: String,
        email: String,
        userImageURL: String = .clear,
        userHeaderImageURL: String = .clear
    ) {
        self.uid = uid
        self.nickName = nickName
        self.email = email
        self.userImageURL = userImageURL
        self.userHeaderImageURL = userHeaderImageURL
    }
}
