//
//  UserRequest.swift
//  CakesHub
//
//  Created by Dmitriy Permyakov on 02.03.2024.
//  Copyright 2024 © VK Team CakesHub. All rights reserved.
//

import Foundation

struct FBUserModel: FBModelable {
    var uid         : String
    var nickname    : String
    var email       : String
    var avatarImage : String?
    var headerImage : String?
    var phone       : String?

    static let clear = FBUserModel(uid: .clear, nickname: .clear, email: .clear)
}

// MARK: - DictionaryConvertible

extension FBUserModel {

    init?(dictionary: [String: Any]) {
        guard let uid = dictionary["uid"] as? String else { return nil }
        self.init(
            uid: uid,
            nickname: dictionary["nickname"] as? String ?? .clear,
            email: dictionary["email"] as? String ?? .clear,
            avatarImage: dictionary["avatarImage"] as? String,
            headerImage: dictionary["headerImage"] as? String,
            phone: dictionary["phone"] as? String
        )
    }
}

// MARK: - Mapper

extension FBUserModel {

    var mapper: ProductModel.SellerInfo {
        .init(
            id: uid,
            name: nickname,
            mail: email,
            userImage: .url(URL(string: avatarImage ?? .clear)),
            userHeaderImage: .url(URL(string: headerImage ?? .clear))
        )
    }
}

// MARK: - MockData

#if DEBUG
extension FBUserModel: Mockable {

    static let mockData = FBUserModel(
        uid: "D4zfn3CLZjb0d2PWVPIFmGhptHr2",
        nickname: "mightyK1ngRichard",
        email: "dimapermyakov55@gmail.com",
        avatarImage: "https://webmg.ru/wp-content/uploads/2022/10/i-321-1.jpeg",
        headerImage: headerImage,
        phone: "+7(914)234-12-12"
    )

    static let king: FBUserModel = .mockData

    static let poly = FBUserModel(
        uid: "6Y1qLJG5NihwnL4qsSJL5397LA93",
        nickname: "Полиночка",
        email: "kakashek@gmail.com",
        avatarImage: "https://i.pinimg.com/originals/10/b6/f4/10b6f4ee1fb2909ab75a0636a984ef60.jpg",
        headerImage: headerImage,
        phone: "+7(914)234-12-12"
    )

    private static let headerImage: String = "https://catherineasquithgallery.com/uploads/posts/2021-12/1639776866_365-catherineasquithgallery-com-p-kartinki-anime-na-fon-telefona-rozovie-486.jpg"
}
#endif

// MARK: - Equatable

extension FBUserModel: Equatable {

    static func == (lhs: FBUserModel, rhs: FBUserModel) -> Bool {
        lhs.uid         == rhs.uid &&
        lhs.nickname    == rhs.nickname &&
        lhs.email       == rhs.email &&
        lhs.avatarImage == rhs.avatarImage &&
        lhs.headerImage == rhs.headerImage &&
        lhs.phone       == rhs.phone
    }
}
