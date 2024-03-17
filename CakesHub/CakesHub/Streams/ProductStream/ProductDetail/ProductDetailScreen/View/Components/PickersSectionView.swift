//
//  PickersSectionView.swift
//  CakesHub
//
//  Created by Dmitriy Permyakov on 04.02.2024.
//  Copyright 2024 © VK Team CakesHub. All rights reserved.
//

import SwiftUI

struct PickersSectionView: View {

    struct PickersItem: Identifiable, Hashable {
        var id = UUID()
        var title: String = .clear
    }

    var pickers: [PickersItem] = []
    @Binding var lastSelected: PickersItem?
    @State private var lastSelectedItem: UUID?

    var body: some View {
        ScrollView(.horizontal) {
            HStack {
                ForEach(pickers) { picker in
                    Button {
                        lastSelectedItem = picker.id
                        lastSelected = picker
                    } label: {
                        PickerView(title: picker.title, id: picker.id)
                    }
                }
            }
            .padding(.vertical, 1)
            .padding(.horizontal)
        }
    }
}

// MARK: - Subivew

private extension PickersSectionView {

    func PickerView(title: String, id: UUID) -> some View {
        HStack {
            Text(title)
                .font(.system(size: 14, weight: .semibold))
                .tint(CHMColor<TextPalette>.textPrimary.color)
                .padding(.leading, 12)
                .lineLimit(1)

            Image.chevronDown
                .renderingMode(.template)
                .frame(width: 16, height: 16)
                .rotationEffect(
                    lastSelectedItem == id ? Angle(degrees: 180) : Angle(degrees: 0)
                )
                .foregroundStyle(Color(uiColor: UIColor(hex: 0xABB4BD)))
                .padding(.trailing, 8)
                .padding(.leading, 16)
        }
        .frame(height: 40)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .stroke(lineWidth: 1)
                .fill(
                    lastSelectedItem == id
                    ? CHMColor<SeparatorPalette>.selectedBorder.color
                    : CHMColor<SeparatorPalette>.unselectedBorder.color
                )
        )
    }
}

// MARK: - Preview

#Preview {
    PickersSectionView(
        pickers: [
            "Size",
            "Размер",
        ].map { .init(title: $0) },
        lastSelected: .constant(nil)
    )
}
