//
//  CHMProductButton+Defaults.swift
//  CHMUIKIT
//
//  Created by Dmitriy Permyakov on 20.01.2024.
//  Copyright 2024 © VK Team CakesHub. All rights reserved.
//

import Foundation

extension CHMProductButton.Configuration {

    /// Basic configuration
    static let clear = CHMProductButton.Configuration()

    /// Basic configuration
    /// - Parameters:
    ///   - kind: icon style
    /// - Returns: configuration of the view
    static func basic(
        kind: Kind
    ) -> Self {
        modify(.clear) {
            $0.backgroundColor = kind.backgroundColor
            $0.iconSize = Constants.iconSize
            $0.buttonSize = Constants.buttonSize
            $0.shadowColor = kind.shadowColor
            $0.kind = kind
        }
    }

    static var shimmering: Self {
        modify(.clear) {
            $0.buttonSize = Constants.buttonSize
            $0.isShimmering = true
        }
    }
}

// MARK: - Constants

private extension CHMProductButton.Configuration {

    enum Constants {
        static let buttonSize: CGFloat = 36
        static let iconSize: CGFloat = 12
    }
}
