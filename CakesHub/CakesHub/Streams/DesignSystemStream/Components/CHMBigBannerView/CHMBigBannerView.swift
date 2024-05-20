//
//  CHMBigBannerView.swift
//  CHMUIKIT
//
//  Created by Dmitriy Permyakov on 28.01.2024.
//  Copyright 2024 © VK Team CakesHub. All rights reserved.
//

import SwiftUI

/**
 Component `CHMBigBannerView`

 For example:
 ```swift
 let view = CHMBigBannerView(
     configuration: .basic(
         imageKind: .uiImage(UIImage(bundleNamed: "Big Banner")),
         bannerTitle: "Fashion\nsale",
         buttonTitle: "Check"
     )
 )
 ```
*/
struct CHMBigBannerView: View {

    var configuration: Configuration
    var didTapButton: CHMVoidBlock?

    var body: some View {
        MKRImageView(configuration: .basic(
            kind: configuration.imageKind,
            imageShape: .rectangle)
        )
        .overlay(alignment: .bottomLeading) {
            VStack(alignment: .leading, spacing: 18) {
                Text(configuration.bannerTitle)
                    .font(.system(size: 48, weight: .black))
                    .foregroundStyle(.white)

                if let title = configuration.buttonTitle {
                    Button {
                        didTapButton?()
                    } label: {
                        Text(title)
                            .style(14, .medium, .white)
                            .frame(width: 160, height: 36)
                            .background(CHMColor<BackgroundPalette>.bgBasketColor.color)
                            .clipShape(.rect(cornerRadius: 25))
                    }
                }
            }
            .padding(.leading, 15)
            .padding(.bottom, 32)
        }
    }
}

// MARK: - Preview

#Preview {
    CHMBigBannerView(
        configuration: .basic(
            imageKind: .uiImage(UIImage(named: "Big Banner")),
            bannerTitle: "Fashion\nsale",
            buttonTitle: "Check"
        )
    ) {
        print("Tap")
    }
    .frame(width: 376, height: 536)
}
