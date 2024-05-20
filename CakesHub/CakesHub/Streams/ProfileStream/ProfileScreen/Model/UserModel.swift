//
//  UserModel.swift
//  CakesHub
//
//  Created by Milana Shakhbieva on 25.03.2024.
//  Copyright 2024 © VK Team CakesHub. All rights reserved.
//

import SwiftUI

struct UserModel: ClearConfigurationProtocol, Hashable {
    var id: String = .clear
    var name: String = .clear
    var surname: String = .clear
    var mail: String = .clear
    var orders: Int = 0
    var userImage: ImageKind = .clear
    var userHeaderImage: ImageKind = .clear
    var products: [ProductModel] = []

    static let clear: Self = .init()
}

// MARK: - Mock Data

#if DEBUG

extension UserModel: Mockable {

    private static let milana = ProductModel.SellerInfo.milana
    static let mockData = UserModel(
        id: milana.id,
        name: milana.name,
        surname: milana.surname,
        mail: milana.mail,
        orders: 555,
        userImage: milana.userImage,
        userHeaderImage: milana.userHeaderImage,
        products: Constants.sellerProducts
    )
}

// MARK: - ProductModel

private extension UserModel {

    enum Constants {
        static let sellerProducts: [ProductModel] = (1...24).map {
            ProductModel(
                id: String($0),
                images: [
                    .init(kind: .url(.mockProductCard)),
                    .init(kind: .url(.mockCake1)),
                    .init(kind: .url(.mockCake2)),
                    .init(kind: .url(.mockCake3)),
                    .init(kind: .url(.mockCake4)),
                ].shuffled(),
                isFavorite: [true, false].randomElement()!,
                isNew: $0.isMultiple(of: 4),
                categories: ["Size", "Color"],
                seller: .milana,
                productName: "Торт \($0)",
                price: "$1\($0).99",
                description: """
                Short dress in soft cotton jersey with decorative buttons down the front and a wide, frill-trimmed square neckline with concealed elastication. Elasticated seam under the bust and short puff sleeves with a small frill trim.
                """,
                reviewInfo: .mockData,
                establishmentDate: "\($0).03.2024",
                similarProducts: .similarProducts
            )
        }
    }
}

#endif
