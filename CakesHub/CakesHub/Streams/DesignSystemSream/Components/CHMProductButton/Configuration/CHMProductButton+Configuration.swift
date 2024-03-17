//
//  CHMProductButton+Configuration.swift
//  CHMUIKIT
//
//  Created by Dmitriy Permyakov on 20.01.2024.
//  Copyright 2024 © VK Team CakesHub. All rights reserved.
//

import SwiftUI

extension CHMProductButton {

    struct Configuration {

        typealias OwnerViewType = CHMProductButton

        /// Color of the background view
        var backgroundColor: Color = .clear
        /// Icon image
        var iconImage: Image = Image("")
        /// Size of the view
        var buttonSize: CGFloat = .zero
        /// Size of the icon
        var iconSize: CGFloat = .zero
        /// Color of the icon
        var iconColor: Color = .clear
        /// Color of the shadow
        var shadowColor: Color = .clear
        /// Shimmering flag
        var isShimmering: Bool = false
    }
}

// MARK: - Kind

extension CHMProductButton.Configuration {
    
    /// Kind of the component icon
    enum Kind {
        case favorite(isSelected: Bool = false)
        case basket
        case custom(Image, Color)
    }
}

extension CHMProductButton.Configuration.Kind {

    var iconImage: Image {
        switch self {
        case .basket: return Image.basketIcon
        case let .favorite(isSelected): return isSelected ? .favoritePressed : .favoriteBorder
        case let .custom(image, _): return image
        }
    }

    var iconColor: Color {
        switch self {
        case let .favorite(isSelected):
            return isSelected ? CHMColor<IconPalette>.iconRed.color : CHMColor<IconPalette>.iconGray.color
        case .basket:
            return CHMColor<IconPalette>.iconBasket.color
        case let .custom(_, color):
            return color
        }
    }

    var backgroundColor: Color {
        switch self {
        case .basket: 
            return CHMColor<BackgroundPalette>.bgBasketColor.color
        case let .favorite(isSelected):
            return CHMColor<BackgroundPalette>.bgFavoriteIcon.color
        case .custom:
            return CHMColor<CustomPalette>.bgCustom.color
        }
    }

    var shadowColor: Color {
        switch self {
        case .basket: 
            return CHMColor<ShadowPalette>.basket.color
        case let .favorite(isSelected):
            return isSelected
            ? CHMColor<ShadowPalette>.favoriteSeletected.color
            : CHMColor<ShadowPalette>.favoriteUnseletected.color
        case .custom:
            return CHMColor<ShadowPalette>.customShadow.color
        }
    }
}

// MARK: - Colors

private extension CHMColor where Palette == CustomPalette {

    static let bgCustom = CHMColor(hexLight: 0xDB3022, hexDark: 0xEF3651)
}
