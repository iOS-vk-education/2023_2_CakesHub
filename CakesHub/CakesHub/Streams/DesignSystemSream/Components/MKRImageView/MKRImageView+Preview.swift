//
//  MKRImageView+Preview.swift
//  MKRDesignSystem
//
//  Created by Dmitriy Permyakov on 20.01.2024.
//

import SwiftUI

struct MKRImageView_Previews: PreviewProvider {

    static var previews: some View {
        VStack(spacing: 20) {
            MKRImageView(
                configuration: .basic(
                    kind: .url(.mockCake2),
                    imageShape: .capsule
                )
            )
            .frame(width: 150, height: 150)
            .previewDisplayName("Circle")

            MKRImageView(
                configuration: .basic(
                    kind: .url(.mockCake2),
                    imageShape: .rectangle
                )
            )
            .frame(width: 150, height: 150)
            .previewDisplayName("Rectangle")
            
            MKRImageView(
                configuration: .basic(
                    kind: .url(.mockCake2),
                    imageShape: .roundedRectangle(20)
                )
            )
            .frame(width: 150, height: 150)
            .previewDisplayName("RoundedRectangle")

            MKRImageView(
                configuration: .shimmering()
            )
            .frame(width: 150, height: 150)
            .previewDisplayName("Shimmering")
        }
    }
}
