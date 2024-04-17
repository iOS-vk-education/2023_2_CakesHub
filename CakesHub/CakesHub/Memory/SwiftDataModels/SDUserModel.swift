//
//  CurrentUserModel.swift
//  CakesHub
//
//  Created by Dmitriy Permyakov on 13.04.2024.
//

import SwiftData

@Model
class SDUserModel {
    var _uid                : String
    var _nickName           : String
    var _email              : String
    var _userImageURL       : String?
    var _userHeaderImageURL : String?
    var _phone              : String?

    init(
        uid                : String,
        nickName           : String,
        email              : String,
        userImageURL       : String? = nil,
        userHeaderImageURL : String? = nil,
        phone              : String? = nil
    ) {
        self._uid = uid
        self._nickName = nickName
        self._email = email
        self._userImageURL = userImageURL
        self._userHeaderImageURL = userHeaderImageURL
        self._phone = phone
    }
}

// MARK: - Init

extension SDUserModel {

    convenience init(user: FBUserModel) {
        self.init(
            uid: user.uid,
            nickName: user.nickname,
            email: user.email,
            userImageURL: user.avatarImage,
            userHeaderImageURL: user.headerImage,
            phone: user.phone
        )
    }
}

// MARK: - Mapper

extension SDUserModel {

    var mapperInFBUserModel: FBUserModel {
        FBUserModel(
            uid: _uid,
            nickname: _nickName,
            email: _email,
            avatarImage: _userImageURL,
            headerImage: _userHeaderImageURL,
            phone: _phone
        )
    }
}
