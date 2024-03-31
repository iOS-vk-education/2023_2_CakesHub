//
//  UserModel.swift
//  CakesHub
//
//  Created by Milana Shakhbieva on 25.03.2024.
//

import SwiftUI

struct UserModel: ClearConfigurationProtocol, Hashable {
    var name: String = .clear
    var surname: String = .clear
    var mail: String = .clear
    var orders: Int = 0
    var userImage: ImageKind = .clear
    var userHeaderImage: ImageKind = .clear
    var products: [ProductModel] = []

    static let clear: Self = .init()
}

#if DEBUG

extension UserModel: Mockable {
    
    static let mockData = UserModel(
        name: "Milana",
        surname: "Shakhbieva",
        mail: "milanashakhbieva@mail.com",
        orders: 555,
        userImage: .url(.mockMilanaImage),
        userHeaderImage: .uiImage(.cake2),
        products: Constants.sellerProducts
    )
}

// MARK: - ProductModel

private extension UserModel {

    enum Constants {
        static let sellerProducts: [ProductModel] = (1...24).map {
            ProductModel(
                productID: $0,
                images: [
                    .init(kind: .url(.mockProductCard)),
                    .init(kind: .url(.mockCake1)),
                    .init(kind: .url(.mockCake2)),
                    .init(kind: .url(.mockCake3)),
                    .init(kind: .url(.mockCake4)),
                ].shuffled(),
                isFavorite: [true, false].randomElement()!,
                isNew: $0.isMultiple(of: 4),
                pickers: ["Size", "Color"],
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
