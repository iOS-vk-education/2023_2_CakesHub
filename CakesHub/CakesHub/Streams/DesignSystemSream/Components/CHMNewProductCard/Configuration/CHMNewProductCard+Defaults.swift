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
    ///   - imageSize: image size
    ///   - productText: product info
    ///   - badgeViewConfiguration: badge info
    ///   - productButtonConfiguration: product button info
    ///   - starsViewConfiguration: product rating
    /// - Returns: configuration of the view
    static func basic(
        imageKind: ImageKind,
        imageSize: CGSize,
        productText: ProductText,
        badgeViewConfiguration: CHMBadgeView.Configuration = .clear,
        productButtonConfiguration: CHMProductButton.Configuration = .clear,
        starsViewConfiguration: CHMStarsView.Configuration = .clear
    ) -> Self {
        modify(.clear) {
            $0.imageConfiguration = .imageConfiguration(imageKind, imageSize)
            $0.badgeViewConfiguration = badgeViewConfiguration
            $0.productText = productText
            $0.productButtonConfiguration = productButtonConfiguration
            $0.starsViewConfiguration = starsViewConfiguration
        }
    }

    static func shimmering(imageSize: CGSize) -> Self {
        modify(.clear) {
            $0.imageConfiguration = .shimmering(imageSize: imageSize, imageShape: .roundedRectangle(9))
            $0.productButtonConfiguration = .shimmering
            $0.starsViewConfiguration = .shimmering
        }
    }
}

// MARK: - MKRImageView Configuration

private extension MKRImageView.Configuration {

    static func imageConfiguration(_ kind: ImageKind, _ imageSize: CGSize) -> Self {
        .basic(
            kind: kind, 
            imageSize: imageSize,
            imageShape: .roundedRectangle(9)
        )
    }
}
