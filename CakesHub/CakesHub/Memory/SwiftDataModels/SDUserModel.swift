//
//  CurrentUserModel.swift
//  CakesHub
//
//  Created by Dmitriy Permyakov on 13.04.2024.
//

import SwiftData

@Model
class SDUserModel {
    var _id                 : String
    var _nickName           : String
    var _email              : String
    var _userImageURL       : String?
    var _userHeaderImageURL : String?
    var _phone              : String?

    init(
        id                 : String,
        nickName           : String,
        email              : String,
        userImageURL       : String? = nil,
        userHeaderImageURL : String? = nil,
        phone              : String? = nil
    ) {
        self._id = id
        self._nickName = nickName
        self._email = email
        self._userImageURL = userImageURL
        self._userHeaderImageURL = userHeaderImageURL
        self._phone = phone
    }
}

// MARK: - SDModelable

extension SDUserModel: SDModelable {
    typealias FBModelType = FBUserModel

    convenience init(fbModel: FBUserModel) {
        self.init(
            id: fbModel.uid,
            nickName: fbModel.nickname,
            email: fbModel.email,
            userImageURL: fbModel.avatarImage,
            userHeaderImageURL: fbModel.headerImage,
            phone: fbModel.phone
        )
    }
}

// MARK: - Mapper

extension SDUserModel {

    var mapperInFBUserModel: FBUserModel {
        FBUserModel(
            uid: _id,
            nickname: _nickName,
            email: _email,
            avatarImage: _userImageURL,
            headerImage: _userHeaderImageURL,
            phone: _phone
        )
    }
}
