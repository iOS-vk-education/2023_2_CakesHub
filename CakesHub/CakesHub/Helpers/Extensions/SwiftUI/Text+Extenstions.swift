//
//  Text+Extenstions.swift
//  CakesHub
//
//  Created by Dmitriy Permyakov on 16.02.2024.
//

import SwiftUI

extension Text {

    func style(
        _ size: CGFloat,
        _ weight: Font.Weight,
        _ color: Color = CHMColor<TextPalette>.textPrimary.color
    ) -> some View {
        font(.system(size: size, weight: weight))
            .foregroundStyle(color)
    }
}
