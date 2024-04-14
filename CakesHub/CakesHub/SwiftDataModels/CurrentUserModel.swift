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
    var userImageURL: String?
    var userHeaderImageURL: String?

    init(
        uid: String,
        nickName: String,
        email: String,
        userImageURL: String? = nil,
        userHeaderImageURL: String? = nil
    ) {
        self.uid = uid
        self.nickName = nickName
        self.email = email
        self.userImageURL = userImageURL
        self.userHeaderImageURL = userHeaderImageURL
    }
}

#if DEBUG
extension CurrentUserModel? {

    static let king = ProductModel.SellerInfo(
        id: "1",
        name: "mightyK1ngRichard",
        surname: "Permyakov",
        mail: "dimapermyakov55@gmail.com",
        userImage: .url(.mockKingImage),
        userHeaderImage: .url(.mockKingHeaderImage)
    )
}
#endif
