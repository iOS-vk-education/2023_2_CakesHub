//
//  CHMPicker+Defaults.swift
//  CHMUIKIT
//
//  Created by Dmitriy Permyakov on 27.01.2024.
//  Copyright 2024 © VK Team CakesHub. All rights reserved.
//

import SwiftUI

extension CHMPicker.Configuration {

    /// Basic configuration
    static let clear = CHMPicker.Configuration()

    /// Basic configuration
    /// - Parameters:
    ///   - text: title of the component
    ///   - currentState: is selected flag
    /// - Returns: configuration of the view
    static func basic(_ text: String, currentState: Bool = false) -> CHMPicker.Configuration {
        modify(.clear) {
            $0.text = text
            $0.textColor = CHMColor<TextPalette>.textPrimary.color
            $0.selectedBorderColor = CHMColor<SeparatorPalette>.selectedBorder.color
            $0.unselectedBorderColor = CHMColor<SeparatorPalette>.unselectedBorder.color
            $0.iconColor = Color(uiColor: UIColor(hex: 0xABB4BD))
        }
    }
}
