//
//  CurrentUserModel.swift
//  CakesHub
//
//  Created by Dmitriy Permyakov on 13.04.2024.
//

import SwiftData

@Model
class SDUserModel {
    var _uid: String
    var _nickName: String
    var _email: String
    var _userImageURL: String?
    var _userHeaderImageURL: String?
    var _phone: String?

    init(
        uid: String,
        nickName: String,
        email: String,
        userImageURL: String? = nil,
        userHeaderImageURL: String? = nil,
        phone: String? = nil
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

    convenience init(user: ProductModel.SellerInfo) {
        var imageURL: String? {
            switch user.userImage {
            case let .url(url):
                return url?.absoluteString
            default:
                return nil
            }
        }
        var headerImageURL: String? {
            switch user.userHeaderImage {
            case .url(let url):
                return url?.absoluteString
            default:
                return nil
            }
        }

        self.init(
            uid: user.id,
            nickName: user.name,
            email: user.mail,
            userImageURL: imageURL,
            userHeaderImageURL: headerImageURL,
            phone: user.phone
        )
    }
}
