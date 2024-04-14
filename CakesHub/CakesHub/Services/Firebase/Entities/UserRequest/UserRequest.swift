//
//  UserRequest.swift
//  CakesHub
//
//  Created by Dmitriy Permyakov on 02.03.2024.
//

import Foundation

struct UserRequest: DictionaryConvertible, ClearConfigurationProtocol {
    var uid         : String = .clear
    var nickname    : String = .clear
    var email       : String = .clear
    var avatarImage : String?
    var headerImage : String?
    var phone       : String?

    static let clear = UserRequest()
}

// MARK: - DictionaryConvertible

extension UserRequest {

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

extension UserRequest {

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
extension UserRequest: Mockable {

    static let mockData = UserRequest(
        uid: "D4zfn3CLZjb0d2PWVPIFmGhptHr2",
        nickname: "mightyK1ngRichard",
        email: "dimapermyakov55@gmail.com",
        avatarImage: "https://webmg.ru/wp-content/uploads/2022/10/i-321-1.jpeg",
        phone: "+7(914)234-12-12"
    )
}
#endif
