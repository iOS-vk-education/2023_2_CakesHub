//
//  UserModel.swift
//  CakesHub
//
//  Created by Milana Shakhbieva on 25.03.2024.
//

import SwiftUI

struct UserModel {
    var name: String = .clear
    var surname: String = .clear
    var mail: String = .clear
    var orders: Int = 0
    var userImage: ImageKind = .clear
    var userHeaderImage: ImageKind = .clear
    var products: [ProductModel] = []
}

#if DEBUG

extension UserModel: Mockable {
    
    static let mockData = UserModel(
        name: Constants.sellerName,
        surname: "Shakhbieva",
        mail: "milanashakhbieva@mail.com",
        orders: 555,
        userImage: .uiImage(.bigBanner),
        userHeaderImage: .uiImage(.cake2),
        products: Constants.sellerProducts
    )
}

// MARK: - ProductModel

private extension UserModel {

    enum Constants {
        static let sellerName = "Milana"
        static let sellerProducts: [ProductModel] = (1...20).map {
            ProductModel(
                productID: $0,
                images: [
                    .init(kind: .url(.mockProductCard)),
                    .init(kind: .url(.mockCake2)),
                    .init(kind: .url(.mockCake3)),
                    .init(kind: .url(.mockCake4)),
                ],
                isFavorite: true,
                pickers: ["Size", "Color"],
                productName: "Торт \($0)",
                price: "$1\($0).99",
                sellerName: sellerName,
                description: """
                Short dress in soft cotton jersey with decorative buttons down the front and a wide, frill-trimmed square neckline with concealed elastication. Elasticated seam under the bust and short puff sleeves with a small frill trim.
                """,
                reviewInfo: .mockData,
                similarProducts: .similarProducts
            )
        }
    }
}

#endif
