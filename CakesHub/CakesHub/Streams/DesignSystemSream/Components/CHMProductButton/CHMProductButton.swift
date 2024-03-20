//
//  CHMProductButton.swift
//  CHMUIKIT
//
//  Created by Dmitriy Permyakov on 20.01.2024.
//  Copyright 2024 © VK Team CakesHub. All rights reserved.
//

import SwiftUI

/**
Component `CHMProductButton`

For example:
```swift
let view = CHMProductButton(
    configuration: .basic(kind: .basket)
)
```
*/
struct CHMProductButton: View {

    let configuration: Configuration
    var didTapButton: CHMBoolBlock?
    @State private var isSelected: Bool
    @State private var highlighted = false

    init(
        configuration: Configuration,
        didTapButton: CHMBoolBlock? = nil
    ) {
        self.configuration = configuration
        self.didTapButton = didTapButton
        self.isSelected = configuration.kind.isSelected
    }

    var body: some View {
        if configuration.isShimmering {
            ShimmeringView()
                .frame(edge: configuration.buttonSize)
                .clipShape(.circle)
        } else {
            MainView
        }
    }
}

// MARK: - Private Subviews

private extension CHMProductButton {

    var MainView: some View {
        Button {
            isSelected.toggle()
            didTapButton?(isSelected)
        } label: {
            ZStack {
                Circle()
                    .fill(configuration.backgroundColor)
                    .frame(edge: configuration.buttonSize)

                configuration.kind.iconImage(isSelected: isSelected)
                    .renderingMode(.template)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: configuration.iconSize)
                    .foregroundStyle(
                        configuration.kind.iconColor(iconIsSelected: isSelected)
                    )
                
                Rectangle()
                    .fill(.clear)
                    .frame(
                        width: configuration.buttonSize * 2,
                        height: configuration.buttonSize * 2
                    )
            }
            .shadow(color: configuration.shadowColor, radius: 10)
        }
//        ZStack {
//            Circle()
//                .fill(configuration.backgroundColor)
//                .frame(edge: configuration.buttonSize)
//
//            configuration.kind.iconImage(isSelected: isSelected)
//                .renderingMode(.template)
//                .resizable()
//                .aspectRatio(contentMode: .fit)
//                .frame(height: configuration.iconSize)
//                .foregroundStyle(
//                    configuration.kind.iconColor(iconIsSelected: isSelected)
//                )
//        Rectangle()
//            .fill(.clear)
//            .frame(width: configuration.buttonSize * 2, height: configuration.buttonSize * 2)
//            .contentShape(Rectangle())
//            .onTapGesture {
//                isSelected.toggle()
//                didTapButton?(isSelected)
//            }
//        }
//        .shadow(color: configuration.shadowColor, radius: 10)
    }
}

// MARK: - Preview

#Preview {
    CHMProductButton(
        configuration: .basic(kind: .favorite(isSelected: true))
    )
}
