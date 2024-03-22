//
//  CHMText.swift
//  CakesHub
//
//  Created by Dmitriy Permyakov on 16.02.2024.
//

import SwiftUI

struct CHMText: View {

    let text: String
    let size: CGFloat
    let weight: Font.Weight
    var color: Color = CHMColor<TextPalette>.textPrimary.color

    var body: some View {
        Text(text)
            .font(.system(size: size, weight: weight))
            .foregroundStyle(color)
    }
}

// MARK: - Preview

#Preview {
    CHMText(text: "Просто текст", size: 12, weight: .bold, color: .accentColor)
}
