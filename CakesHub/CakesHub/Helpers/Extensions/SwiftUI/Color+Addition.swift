//
//  Color+Addition.swift
//  CHMUIKIT
//
//  Created by Dmitriy Permyakov on 27.01.2024.
//

import SwiftUI

final class CHMColor<Palette: Hashable> {
    let color: Color
    let uiColor: UIColor

    init(hexLight: Int, hexDark: Int, alphaLight: CGFloat = 1.0, alphaDark: CGFloat = 1.0) {
        let lightColor = UIColor(hex: hexLight, alpha: alphaLight)
        let darkColor = UIColor(hex: hexDark, alpha: alphaDark)
        let uiColor = UIColor { $0.userInterfaceStyle == .light ? lightColor : darkColor }
        self.uiColor = uiColor
        self.color = Color(uiColor: uiColor)
    }

    init(hexLight: Int, hexDark: Int, alpha: CGFloat = 1.0) {
        let chmColor = CHMColor(hexLight: hexLight, hexDark: hexDark, alphaLight: alpha, alphaDark: alpha)
        self.uiColor = chmColor.uiColor
        self.color = chmColor.color
    }

    init(uiColor: UIColor) {
        self.uiColor = uiColor
        self.color = Color(uiColor: uiColor)
    }
}

// MARK: - Palettes

enum BackgroundPalette: Hashable {}
enum IconPalette: Hashable {}
enum SeparatorPalette: Hashable {}
enum TextPalette: Hashable {}
enum ShadowPalette: Hashable {}
enum CustomPalette: Hashable {}
#if DEBUG
enum PreviewPalette: Hashable {}
#endif

// MARK: - Background Colors

extension CHMColor where Palette == BackgroundPalette {

    /// Красный задний фон. Ex: Кнопка покупки
    static let bgRed = CHMColor(hexLight: 0xDB3022, hexDark: 0xFF3E3E)
    /// Тёмный задний фон. Ex: Бейдж новых продктов
    static let bgDark = CHMColor(hexLight: 0x222222, hexDark: 0x1E1F28)
    /// Задний фон икноки корзины, кнопки баннера
    static let bgBasketColor = CHMColor(hexLight: 0xDB3022, hexDark: 0xEF3651)
    /// Задний фон иконки лайка
    static let bgFavoriteIcon = CHMColor(hexLight: 0xFFFFFF, hexDark: 0x2A2C36)
    /// White gray
    static let bgCommentView = CHMColor(hexLight: 0xFFFFFF, hexDark: 0x2A2C36)
    /// App bg color
    static let bgMainColor = CHMColor(hexLight: 0xF9F9F9, hexDark: 0x1E1F28)
    /// Search bg color
    static let bgSearchBar = CHMColor(hexLight: 0xFFFFFF, hexDark: 0x2A2C36)
    /// Цвет шиммера
    static let bgShimmering = CHMColor(hexLight: 0xF3F3F7, hexDark: 0x242429)
    /// Черный белый фон
    static let bgPrimary = CHMColor(hexLight: 0xF9F9F9, hexDark: 0x060606)
}

// MARK: - Text Colors

extension CHMColor where Palette == TextPalette {

    /// Основной текст
    static let textPrimary = CHMColor(hexLight: 0x222222, hexDark: 0xF6F6F6)
    /// Второстепенный текст
    static let textSecondary = CHMColor(hexLight: 0x9B9B9B, hexDark: 0xABB4BD)
    /// Текст описания
    static let textDescription = CHMColor(hexLight: 0x222222, hexDark: 0xF5F5F5)
    /// Выделенный красный текст: Ex: Цена при скидке
    static let textWild = CHMColor(hexLight: 0xDB3022, hexDark: 0xFF3E3E)
}

// MARK: - Icon Colors

extension CHMColor where Palette == IconPalette {

    static let iconRed = CHMColor(hexLight: 0xDB3022, hexDark: 0xEF3651)
    static let iconSecondary = CHMColor(hexLight: 0x9B9B9B, hexDark: 0x8E8E93)
    static let iconGray = CHMColor(hexLight: 0x9B9B9B, hexDark: 0xABB4BD)
    static let iconBasket = CHMColor(hexLight: 0xF9F9F9, hexDark: 0xF6F6F6)
    static let iconPrimary = CHMColor(hexLight: 0x222222, hexDark: 0xF9F9F9)
    static let navigationBackButton = CHMColor(hexLight: 0x222222, hexDark: 0xF6F6F6)
}

// MARK: - Separator Colors

extension CHMColor where Palette == SeparatorPalette {

    /// Красная граница
    static let selectedBorder = CHMColor(hexLight: 0xF01F0E, hexDark: 0xFF2424)
    /// Серая граница
    static let unselectedBorder = CHMColor(hexLight: 0x9B9B9B, hexDark: 0xABB4BD)
    /// Цвет дивайдера. Ex: палочка при всплывающем окне
    static let divider = CHMColor(hexLight: 0x9B9B9B, hexDark: 0xABB4BD)
    /// Красная линия. Ex: Экран рейтинга
    static let redLine = CHMColor(hexLight: 0xDB3022, hexDark: 0xFF3E3E)
}

// MARK: - Shadow Colors

extension CHMColor where Palette == ShadowPalette {

    static let basket = CHMColor(hexLight: 0xF9F9F9, hexDark: 0xEF3651, alpha: 0.5)
    static let favoriteSeletected = CHMColor(hexLight: 0x9B9B9B, hexDark: 0xEF3651, alphaLight: 0.5, alphaDark: 0)
    static let favoriteUnseletected = CHMColor(hexLight: 0x9B9B9B, hexDark: 0x2A2C36, alpha: 0.5)
    static let customShadow = CHMColor(hexLight: 0x9B9B9B, hexDark: 0x2A2C36, alpha: 0.5)
    static let tabBarShadow = CHMColor(hexLight: 0x000000, hexDark: 0x1A1B20, alphaLight: 0.06)
}

// MARK: - Preview Colors

#if DEBUG
extension CHMColor where Palette == PreviewPalette {

    /// Серый фон превью
    static let bgPreview = CHMColor(uiColor: UIColor(hex: 0xE5E5E5))
}
#endif
