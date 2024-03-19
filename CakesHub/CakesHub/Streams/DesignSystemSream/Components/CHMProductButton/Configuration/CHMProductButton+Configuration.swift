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
        /// Size of the view
        var buttonSize: CGFloat = .zero
        /// Size of the icon
        var iconSize: CGFloat = .zero
        /// Color of the shadow
        var shadowColor: Color = .clear
        /// Shimmering flag
        var isShimmering: Bool = false
        /// Icon kind
        var kind: Kind = .clear
    }
}

// MARK: - Kind

extension CHMProductButton.Configuration {
    
    /// Kind of the component icon
    enum Kind: Hashable {
        case favorite(isSelected: Bool = false)
        case basket
        case clear
    }
}

extension CHMProductButton.Configuration.Kind {

    var isSelected: Bool {
        switch self {
        case let .favorite(isSelected):
            return isSelected
        default:
            return false
        }
    }

    func iconColor(iconIsSelected: Bool = false) -> Color {
        switch self {
        case .favorite:
            return iconIsSelected ? CHMColor<IconPalette>.iconRed.color : CHMColor<IconPalette>.iconGray.color
        case .basket:
            return CHMColor<IconPalette>.iconBasket.color
        case .clear:
            return .clear
        }
    }

    func iconImage(isSelected: Bool) -> Image {
        switch self {
        case .basket:
            return Image.basketIcon
        case .favorite:
            return isSelected ? .favoritePressed : .favoriteBorder
        case .clear:
            return Image("")
        }
    }

    var backgroundColor: Color {
        switch self {
        case .basket: 
            return CHMColor<BackgroundPalette>.bgBasketColor.color
        case .favorite:
            return CHMColor<BackgroundPalette>.bgFavoriteIcon.color
        case .clear:
            return .clear
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
        case .clear:
            return .clear
        }
    }
}
