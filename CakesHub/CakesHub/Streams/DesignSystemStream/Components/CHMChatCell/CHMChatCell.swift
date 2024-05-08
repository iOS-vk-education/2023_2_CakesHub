//
//  CHMChatCell.swift
//  CHMUIKIT
//
//  Created by Dmitriy Permyakov on 08.05.2024.
//  Copyright 2024 © VK Team CakesHub. All rights reserved.
//

import SwiftUI

/**
 Component `CHMChatCell`

 For example:
 ```swift
 let view = CHMChatCell(
     configuration: .basic(
         imageKind: .uiImage(.cake),
         title: "Dmitriy Permyakov",
         subtitle: "Hello, VK! It is CakesHub application",
         time: "02:10"
     )
 )
 ```
*/
struct CHMChatCell: View {

    let configuration: Configuration

    var body: some View {
        HStack(spacing: 15) {
            MKRImageView(
                configuration: configuration.imageConfiguration
            )
            .frame(edge: 60)

            HStack(spacing: 20) {
                VStack(alignment: .leading, spacing: 2) {
                    Text(configuration.title)
                        .style(20, .semibold, CHMColor<TextPalette>.textPrimary.color)
                        .lineLimit(1)

                    Text(configuration.subtitle)
                        .style(16, .regular, CHMColor<TextPalette>.textSecondary.color)
                        .lineLimit(1)
                }

                Spacer(minLength: 2)

                Text(configuration.time)
                    .style(13, .medium, CHMColor<TextPalette>.textSecondary.color)
            }
        }
    }
}

// MARK: - Preview

#Preview {
    CHMChatCell(
        configuration: .basic(
            imageKind: .uiImage(.bestGirl),
            title: "Dmitriy Permyakov",
            subtitle: "Hello, VK! It is CakesHub application",
            time: "02:10"
        )
    )
    .frame(maxWidth: .infinity, alignment: .leading)
    .padding(.horizontal)
}
