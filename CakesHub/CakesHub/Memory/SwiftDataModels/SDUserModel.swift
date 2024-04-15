//
//  CurrentUserModel.swift
//  CakesHub
//
//  Created by Dmitriy Permyakov on 13.04.2024.
//

import SwiftData

@Model
class SDUserModel {
    var uid: String
    var nickName: String
    var email: String
    var userImageURL: String?
    var userHeaderImageURL: String?
    var products: [SDProductModel]

    init(
        uid: String,
        nickName: String,
        email: String,
        userImageURL: String? = nil,
        userHeaderImageURL: String? = nil,
        products: [SDProductModel] = []
    ) {
        self.uid = uid
        self.nickName = nickName
        self.email = email
        self.userImageURL = userImageURL
        self.userHeaderImageURL = userHeaderImageURL
        self.products = products
    }
}

// MARK: - Mock Data

#if DEBUG
extension SDUserModel? {

    static let king = ProductModel.SellerInfo(
        id: "D4zfn3CLZjb0d2PWVPIFmGhptHr2",
        name: "mightyK1ngRichard",
        surname: "Permyakov",
        mail: "dimapermyakov55@gmail.com",
        userImage: .url(.mockKingImage),
        userHeaderImage: .url(.mockKingHeaderImage)
    )
}
#endif
