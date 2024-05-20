//
//
//  SettingButtonsModifier.swift
//  CakesHub
//
//  Created by Milana Shakhbieva on 19.05.2024.
//  Copyright 2024 © VK Team CakesHub. All rights reserved.
//

import SwiftUI

struct SettingButtonsModifier: ViewModifier {
    var kind: Kind

    func body(content: Content) -> some View {
        content
            .frame(maxWidth: .infinity)
            .padding()
            .background(kind.color, in: .rect(cornerRadius: kind.cornerRadius))
            .padding(.horizontal)
    }
}

extension SettingButtonsModifier {

    enum Kind {
        case textField
        case button

        var color: Color {
            switch self {
            case .textField:
                return CHMColor<BackgroundPalette>.bgCommentView.color
            case .button:
                return CHMColor<BackgroundPalette>.bgRed.color
            }
        }

        var cornerRadius: CGFloat {
            switch self {
            case .textField:
                return 4
            case .button:
                return 25
            }
        }
    }
}
