//
//  CHMStarsView+Defaults.swift
//  CHMUIKIT
//
//  Created by Dmitriy Permyakov on 20.01.2024.
//  Copyright 2024 © VK Team CakesHub. All rights reserved.
//

import SwiftUI

extension CHMStarsView.Configuration {

    /// Basic configuration
    static let clear = CHMStarsView.Configuration()

    /// Basic configuration
    /// - Parameters:
    ///   - kind: count of the fill stars
    ///   - feedbackCount: count of the feedback
    /// - Returns: configuration of the view
    static func basic(
        kind: Kind,
        feedbackCount: Int? = nil
    ) -> Self {
        modify(.clear) {
            $0.countFillStars = kind.rawValue
            $0.feedbackCount = feedbackCount
            $0.starWidth = Constants.starWidth
            $0.padding = Constants.padding
            $0.foregroundColor = Constants.foregroundColor
            $0.lineHeigth = Constants.lineHeigth
            $0.leftPadding = Constants.leftPadding
        }
    }

    static var shimmering: Self {
        modify(.clear) {
            $0.isShimmering = true
            $0.countFillStars = Kind.five.rawValue
            $0.starWidth = Constants.starWidth
            $0.padding = Constants.padding
        }
    }
}

// MARK: - Constants

private extension CHMStarsView.Configuration {

    enum Constants {
        static let starWidth: CGFloat = 13
        static let padding: CGFloat = 2
        static let lineHeigth: CGFloat = 10
        static let leftPadding: CGFloat = 4
        static let foregroundColor = CHMColor<IconPalette>.iconSecondary.color
    }
}
