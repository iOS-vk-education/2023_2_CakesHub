//
//  CHMNewCategoryView.swift
//  CHMUIKIT
//
//  Created by Dmitriy Permyakov on 27.01.2024.
//  Copyright 2024 © VK Team CakesHub. All rights reserved.
//

import SwiftUI

/**
 Component `CHMNewCategoryView`

 For example:
 ```swift
 let view = CHMNewCategoryView(
     configuration: .constant(
         .basic(
             imageKind: .url(.mockCake1),
             title: "Clothes"
         )
     )
 )
 ```
*/
struct CHMNewCategoryView: View {

    let configuration: Configuration

    var body: some View {
        GeometryReader { proxy in
            let size = proxy.size
            HStack {
                Text(configuration.title)
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundStyle(CHMColor<TextPalette>.textPrimary.color)
                    .padding(.leading, 23)
                Spacer()
                MKRImageView(configuration: .basic(
                    kind: configuration.imageKindConfiguration,
                    imageSize: CGSize(width: size.width / 2, height: size.height),
                    imageShape: .rectangle
                ))
            }
        }
        .frame(height: 100)
        .background(CHMColor<BackgroundPalette>.bgCommentView.color)
        .clippedShape(.roundedRectangle(8))
    }
}

// MARK: - Preview

#Preview {
    CHMNewCategoryView(
        configuration: .basic(
            imageKind: .url(.mockCake2),
            title: "Clothes"
        )
    )
    .padding()
    .background(CHMColor<PreviewPalette>.bgPreview.color)
}
