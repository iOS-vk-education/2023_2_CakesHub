//
//  UserRequest.swift
//  CakesHub
//
//  Created by Dmitriy Permyakov on 02.03.2024.
//

import Foundation

struct FBUserModel: DictionaryConvertible, ClearConfigurationProtocol {
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
        phone: "+7(914)234-12-12"
    )

    static let king: FBUserModel = .mockData

    static let poly = FBUserModel(
        uid: "6Y1qLJG5NihwnL4qsSJL5397LA93",
        nickname: "Полиночка",
        email: "kakashek@gmail.com",
        avatarImage: "https://i.pinimg.com/originals/10/b6/f4/10b6f4ee1fb2909ab75a0636a984ef60.jpg",
        phone: "+7(914)234-12-12"
    )
}
#endif
