//
//  CHMNewProductCard+Configuration.swift
//  CHMUIKIT
//
//  Created by Dmitriy Permyakov on 20.01.2024.
//

import SwiftUI

extension CHMNewProductCard {

    struct Configuration {

        typealias OwnerViewType = CHMNewProductCard

        /// Configuration of the image view
        var imageConfiguration: MKRImageView.Configuration = .clear
        /// Configuration of the badge view
        var badgeViewConfiguration: CHMBadgeView.Configuration = .clear
        /// Height of the image view
        var imageHeight: CGFloat = .zero
        /// Configuration of the product info
        var productButtonConfiguration: CHMProductButton.Configuration = .clear
        /// Configuration of the product rating
        var starsViewConfiguration: CHMStarsView.Configuration = .clear
        /// Product info
        var productText: ProductText = .clear
    }
}

// MARK: - ProductText

extension CHMNewProductCard.Configuration {

    struct ProductText: Hashable {
        var seller: String?
        var productName: String?
        var productPrice: String = .clear
        var productOldPrice: String?

        static let clear = Self()
    }
}

// MARK: - Shimmering

extension CHMNewProductCard.Configuration {

    var isShimmering: Bool {
        imageConfiguration.isShimmering
        || productButtonConfiguration.isShimmering
        || starsViewConfiguration.isShimmering
    }
}
