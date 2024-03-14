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
            return isSelected ? .bgBasketColor : Color(hexLight: 0x9B9B9B, hexDarK: 0xABB4BD)
        case .basket:
            return Color(hexLight: 0xF9F9F9, hexDarK: 0xF6F6F6)
        case let .custom(_, color):
            return color
        }
    }

    var backgroundColor: Color {
        switch self {
        case .basket: 
            return Color(hexLight: 0xDB3022, hexDarK: 0xEF3651)
        case let .favorite(isSelected):
            return isSelected ? Color(hexLight: 0xFFFFFF, hexDarK: 0x2A2C36) : Color(hexLight: 0xFFFFFF, hexDarK: 0x2A2C36)
        case .custom:
            return Color(hexLight: 0xDB3022, hexDarK: 0xEF3651)
        }
    }

    var shadowColor: Color {
        switch self {
        case .basket: return Color(hexLight: 0xF9F9F9, hexDarK: 0xEF3651, alpha: 0.5)
        case let .favorite(isSelected): 
            return isSelected
            ? Color(hexLight: 0x9B9B9B, hexDarK: 0xEF3651, alphaLight: 0.5, alphaDark: 0)
            : Color(hexLight: 0x9B9B9B, hexDarK: 0x2A2C36, alpha: 0.5)
        case .custom: return Color(hexLight: 0x9B9B9B, hexDarK: 0x2A2C36, alpha: 0.5)
        }
    }
}
