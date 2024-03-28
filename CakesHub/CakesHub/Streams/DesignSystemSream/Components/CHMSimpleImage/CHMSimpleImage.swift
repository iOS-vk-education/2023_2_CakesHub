//
//  CHMSimpleImage.swift
//  CHMUIKIT
//
//  Created by Dmitriy Permyakov on 27.03.2024.
//  Copyright 2024 © VK Team CakesHub. All rights reserved.
//

import SwiftUI

/**
 Component `CHMSimpleImage`

 For example:
 ```swift
 let view = CHMSimpleImage(
     configuration: .basic(
         imageKind: .url(.mockCake1)
     )
 )
 ```
*/
struct CHMSimpleImage: View {

    let configuration: Configuration

    var body: some View {
        MainView
    }
}

private extension CHMSimpleImage {

    @ViewBuilder
    var MainView: some View {
        GeometryReader { geo in
            let size = geo.size
            switch configuration.imageKind {
            case let .url(url):
                AsyncImage(url: url) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: size.width, height: size.height)
                        .clipped()
                } placeholder: {
                    ShimmeringView()
                        .frame(width: size.width, height: size.height)
                }

            case let .uiImage(uiImage):
                if let uiImage {
                    Image(uiImage: uiImage)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: size.width, height: size.height)
                        .clipped()
                }
            case .clear:
                EmptyView()
            }
        }
    }
}

// MARK: - Preview

#Preview {
    CHMSimpleImage(
        configuration: .basic(
            imageKind: .url(.mockCake4)
        )
    )
    .frame(width: 200, height: 200)
    .clipShape(.rect(cornerRadius: 20))
}
