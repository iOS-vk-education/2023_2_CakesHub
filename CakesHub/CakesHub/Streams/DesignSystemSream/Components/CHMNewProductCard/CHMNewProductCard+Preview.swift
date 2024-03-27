//
//  CHMNewProductCard+Preview.swift
//  CHMUIKIT
//
//  Created by Dmitriy Permyakov on 20.01.2024.
//

import SwiftUI

struct CHMNewProductCard_Previews: PreviewProvider {

    static var previews: some View {
        VStack(spacing: 20) {
            CHMNewProductCard(
                configuration: .basic(
                    imageKind: .url(.mockProductCard),
                    imageSize: CGSize(width: Constants.cardWidth, height: Constants.imageHeigth),
                    productText: .init(
                        seller: "Mango Boy",
                        productName: "T-Shirt Sailing",
                        productPrice: "10$"
                    ),
                    productButtonConfiguration: .basic(kind: .favorite()),
                    starsViewConfiguration: .basic(kind: .four, feedbackCount: 8)
                )
            ) { isSelected in
                print("Did tap favorite icon. isSelected: \(isSelected)")
            }
            .frame(width: Constants.cardWidth)

            CHMNewProductCard(
                configuration: .basic(
                    imageKind: .url(.mockProductCard),
                    imageSize: CGSize(width: Constants.cardWidth, height: Constants.imageHeigth),
                    productText: .init(
                        seller: "Mango Boy",
                        productName: "T-Shirt Sailing",
                        productPrice: "10$"
                    ),
                    badgeViewConfiguration: .basic(text: "NEW", kind: .dark),
                    productButtonConfiguration: .basic(kind: .basket),
                    starsViewConfiguration: .basic(kind: .four, feedbackCount: 12)
                )
            ) { isSelected in
                print("Did tap favorite icon. isSelected: \(isSelected)")
            }
            .frame(width: Constants.cardWidth)
        }
    }
}

// MARK: - Constants

private extension CHMNewProductCard_Previews {

    enum Constants {
        static let cardWidth: CGFloat = 148
        static let imageHeigth: CGFloat = 184
    }
}
