//
//  CHMNewProductCard+Defaults.swift
//  CHMUIKIT
//
//  Created by Dmitriy Permyakov on 20.01.2024.
//

import Foundation

extension CHMNewProductCard.Configuration {

    /// Basic configuration
    static let clear = Self()

    /// Basic configuration
    /// - Parameters:
    ///   - imageKind: image kind
    ///   - imageHeight: image height
    ///   - productText: product info
    ///   - badgeViewConfiguration: badge info
    ///   - productButtonConfiguration: product button info
    ///   - starsViewConfiguration: product rating
    /// - Returns: configuration of the view
    static func basic(
        imageKind: ImageKind,
        imageHeight: CGFloat,
        productText: ProductText,
        badgeViewConfiguration: CHMBadgeView.Configuration = .clear,
        productButtonConfiguration: CHMProductButton.Configuration = .clear,
        starsViewConfiguration: CHMStarsView.Configuration = .clear
    ) -> Self {
        modify(.clear) {
            $0.imageConfiguration = .imageConfiguration(imageKind)
            $0.imageHeight = imageHeight
            $0.badgeViewConfiguration = badgeViewConfiguration
            $0.productText = productText
            $0.productButtonConfiguration = productButtonConfiguration
            $0.starsViewConfiguration = starsViewConfiguration
        }
    }

    static func shimmering(imageHeight: CGFloat) -> Self {
        modify(.clear) {
            $0.imageConfiguration = .shimmering(imageShape: .roundedRectangle(9))
            $0.imageHeight = imageHeight
            $0.productButtonConfiguration = .shimmering
            $0.starsViewConfiguration = .shimmering
        }
    }
}

// MARK: - MKRImageView Configuration

private extension MKRImageView.Configuration {

    static func imageConfiguration(_ kind: ImageKind) -> Self {
        .basic(
            kind: kind, 
            imageShape: .roundedRectangle(9)
        )
    }
}
