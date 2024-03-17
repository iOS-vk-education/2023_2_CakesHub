//
//  CHMPicker.swift
//  CHMUIKIT
//
//  Created by Dmitriy Permyakov on 27.01.2024.
//  Copyright 2024 © VK Team CakesHub. All rights reserved.
//

import SwiftUI

/**
 Component `CHMPicker`

 For example:
 ```swift
 let view = CHMPicker(
     configuration: .basic("Размер")
 )
 ```
*/
struct CHMPicker: View {

    // MARK: Values

    let configuration: Configuration
    var handlerConfiguration: HandlerConfiguration?
    @Binding var isSelected: Bool

    // MARK: UI Components

    var body: some View {
        Button {
            isSelected.toggle()
            handlerConfiguration?.didTapView?(isSelected)
        } label: {
            ComponentView
        }
    }

    var ComponentView: some View {
        HStack {
            Text(configuration.text)
                .font(.system(size: 14, weight: .semibold))
                .foregroundStyle(CHMColor<TextPalette>.textPrimary.color)
                .padding(.leading, 12)
                .lineLimit(1)

            Image.chevronDown
                .renderingMode(.template)
                .frame(edge: 16)
                .rotationEffect(
                    isSelected ? Angle(degrees: 180) : Angle(degrees: 0)
                )
                .foregroundStyle(configuration.iconColor)
                .padding(.trailing, 8)
                .padding(.leading, 16)
        }
        .frame(height: 40)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .stroke(lineWidth: 1)
                .fill(isSelected ? configuration.selectedBorderColor : configuration.unselectedBorderColor)
        )
    }
}

// MARK: - Preview

#Preview {
    CHMPicker(
        configuration: .basic("Размер"),
        handlerConfiguration: nil,
        isSelected: .constant(true)
    )
}
