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

    var body: some View {
        GeometryReader { proxy in
            MKRImageView(configuration: .basic(
                kind: configuration.imageKind,
                imageSize: proxy.size,
                imageShape: .rectangle)
            )
        }
        .overlay(alignment: .bottomLeading) {
            VStack(alignment: .leading, spacing: 0) {
                Text(configuration.bannerTitle)
                    .font(.system(size: 48, weight: .black))
                    .foregroundStyle(.white)
                    .padding(.leading, 15)
                    .padding(.bottom, 18)
            }
        }
        .ignoresSafeArea()
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
    )
    .frame(width: 376, height: 536)
}
