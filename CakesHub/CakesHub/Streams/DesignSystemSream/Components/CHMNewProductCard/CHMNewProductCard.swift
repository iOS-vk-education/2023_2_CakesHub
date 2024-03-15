//
//  CHMNewProductCard.swift
//  CHMUIKIT
//
//  Created by Dmitriy Permyakov on 20.01.2024.
//

import SwiftUI

/**
Component `CHMNewProductCard`

For example:
```swift
let view = CHMNewProductCard(
    configuration: .constant(
        .basic(
            imageKind: .url(.mockProductCard),
            imageSize: CGSize(width: 148, height: 184),
            productText: .init(
                seller: "Mango Boy",
                productName: "T-Shirt Sailing",
                productPrice: "10$"
            ),
            productButtonConfiguration: .basic(kind: .favorite),
            starsViewConfiguration: .basic(kind: .four, feedbackCount: 8)
        )
    )
)
```
*/
struct CHMNewProductCard: View {
    
    let configuration: Configuration
    var didTapButton: CHMVoidBlock?

    var body: some View {
        VStack(alignment: .leading) {
            ImageBlock
            FooterBlockView
                .padding(.top, 2)
        }
    }
}

// MARK: - Subviews

private extension CHMNewProductCard {

    var ImageBlock: some View {
        MKRImageView(configuration: configuration.imageConfiguration)
        .overlay(alignment: .topLeading) {
            CHMBadgeView(configuration: configuration.badgeViewConfiguration)
            .padding([.top, .leading], 8)
        }
        .overlay(alignment: .bottomTrailing) {
            CHMProductButton(
                configuration: configuration.productButtonConfiguration,
                didTapButton: didTapButton
            )
            .offset(y: 18)
        }
    }

    var FooterBlockView: some View {
        VStack(alignment: .leading) {
            StartsBlockView
            if configuration.isShimmering {
                ShimmeringTextBlock
            } else {
                TextBlockView
            }
        }
    }

    var StartsBlockView: some View {
        CHMStarsView(configuration: configuration.starsViewConfiguration)
    }

    var TextBlockView: some View {
        VStack(alignment: .leading, spacing: 3) {
            if let seller = configuration.productText.seller {
                Text(seller)
                    .style(11, .regular, .sellerTextColor)
                    .lineLimit(1)
            }

            if let productName = configuration.productText.productName {
                Text(productName)
                    .style(16, .semibold, .productNameColor)
                    .lineLimit(1)
            }

            if let oldPrice = configuration.productText.productOldPrice {
                HStack(spacing: 4) {
                    Text(oldPrice)
                        .style(14, .medium, .oldPriceColor)
                        .strikethrough(true, color: .oldPriceColor)

                    Text(configuration.productText.productPrice)
                        .style(14, .medium, .newPriceColor)
                }
            } else {
                Text(configuration.productText.productPrice)
                    .style(14, .medium, .productNameColor)
            }
        }
    }

    var ShimmeringTextBlock: some View {
        VStack(alignment: .leading, spacing: 3) {
            Group {
                ShimmeringView()
                    .frame(width: 100, height: 8)

                ShimmeringView()
                    .frame(width: 130,  height: 12)

                ShimmeringView()
                    .frame(width: 40, height: 12)
            }
            .clipShape(.rect(cornerRadius: 7))
        }
    }
}

// MARK: - Preview

#Preview {
    CHMNewProductCard(
        configuration: .shimmering(
            imageSize: CGSize(width: 148, height: 184)
        )
    )
}

#Preview {
    CHMNewProductCard(
        configuration: .basic(
            imageKind: .url(.mockProductCard),
            imageSize: CGSize(width: 148, height: 184),
            productText: .init(
                seller: "Mango Boy",
                productName: "T-Shirt Sailing",
                productPrice: "10$",
                productOldPrice: "22$"
            ),
            productButtonConfiguration: .basic(kind: .favorite()),
            starsViewConfiguration: .basic(kind: .four, feedbackCount: 20000)
        )
    )
    .frame(width: 148)
}

// MARK: - Constants

private extension Color {

    static let sellerTextColor = Color(hexLight: 0x9B9B9B, hexDarK: 0xABB4BD)
    static let oldPriceColor = Color(hexLight: 0x9B9B9B, hexDarK: 0xABB4BD)
    static let newPriceColor = Color(hexLight: 0xDB3022, hexDarK: 0xFF3E3E)
    static let productNameColor = Color(hexLight: 0x222222, hexDarK: 0xF6F6F6)
}
