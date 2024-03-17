//
//  CHMBadgeView+Defaults.swift
//  CHMUIKIT
//
//  Created by Dmitriy Permyakov on 20.01.2024.
//

import SwiftUI

extension CHMBadgeView.Configuration {

    static let clear = Self()

    static func basic(
        text: String,
        kind: Kind = .red
    ) -> Self {
        modify(.clear) {
            guard !text.isEmpty else { return }
            $0.text            = text
            $0.backgroundColor = kind.backgroundColor
            $0.foregroundColor = .white
            $0.backgroundEdges = Constants.backgroundEdges
            $0.cornerRadius    = Constants.cornerRadius
        }
    }
}

// MARK: - Constants

private extension CHMBadgeView.Configuration {

    enum Constants {
        static let cornerRadius: CGFloat = 29
        static let fontSize: CGFloat = 11
        static let backgroundEdges = EdgeInsets(top: 7, leading: 6, bottom: 6, trailing: 6)
    }
}
