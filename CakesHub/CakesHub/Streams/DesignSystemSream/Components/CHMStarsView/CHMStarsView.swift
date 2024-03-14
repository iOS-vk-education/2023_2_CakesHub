//
//  CHMStarsView.swift
//  CHMUIKIT
//
//  Created by Dmitriy Permyakov on 20.01.2024.
//  Copyright 2024 © VK Team CakesHub. All rights reserved.
//

import SwiftUI

/**
Component `CHMStarsView`

For example:
```swift
let view = CHMStarsView(
    configuration: .basic(kind: .two)
)
```
*/
struct CHMStarsView: View {

    let configuration: Configuration
    
    var body: some View {
        MainBlock
    }
}

private extension CHMStarsView {

    var MainBlock: some View {
        HStack(spacing: configuration.leftPadding) {
            HStack(spacing: configuration.padding) {
                ForEach(0..<configuration.countFillStars, id: \.self) { _ in
                    if configuration.isShimmering {
                        ShimmeringView()
                            .frame(edge: configuration.starWidth)
                            .mask {
                                Image.starFill
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: configuration.starWidth)
                            }
                    } else {
                        Image.starFill
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: configuration.starWidth)
                    }
                }

                ForEach(0..<5-configuration.countFillStars, id: \.self) { _ in
                    Image.starOutline
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: configuration.starWidth)
                }
            }

            if let text = configuration.feedbackCount {
                Text("(\(text))")
                    .font(.system(size: configuration.lineHeigth, weight: .regular))
                    .foregroundStyle(configuration.foregroundColor)
            }
        }
    }

    var ShimmeringBlock: some View {
        VStack {}
    }
}

// MARK: - Preview

#Preview {
    CHMStarsView(configuration: .shimmering)
}

#Preview {
    CHMStarsView(configuration: .basic(kind: .two, feedbackCount: 10))
}
