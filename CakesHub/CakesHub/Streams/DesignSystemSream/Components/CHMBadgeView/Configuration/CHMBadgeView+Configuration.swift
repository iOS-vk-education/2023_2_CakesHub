//
//  CHMBadgeView+Configuration.swift
//  CHMUIKIT
//
//  Created by Dmitriy Permyakov on 20.01.2024.
//

import SwiftUI

extension CHMBadgeView {

    struct Configuration {
        var text            : String = .clear
        var backgroundColor : Color = .clear
        var foregroundColor : Color = .clear
        var backgroundEdges : EdgeInsets = .init()
        var cornerRadius    : CGFloat = .zero
        var fontSize        : CGFloat = .zero
    }
}

// MARK: - Kind

extension CHMBadgeView.Configuration {
    
    /// Kind of the background color
    enum Kind {
        case dark
        case red
    }
}

extension CHMBadgeView.Configuration.Kind {

    var backgroundColor: Color {
        switch self {
        case .dark: return CHMColor<BackgroundPalette>.bgDark.color
        case .red: return CHMColor<BackgroundPalette>.bgRed.color
        }
    }
}
