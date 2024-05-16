//
//  CHMBigBannerView+Configuration.swift
//  CHMUIKIT
//
//  Created by Dmitriy Permyakov on 28.01.2024.
//  Copyright 2024 © VK Team CakesHub. All rights reserved.
//

import UIKit

extension CHMBigBannerView {

    struct Configuration {

        typealias OwnerViewType = CHMBigBannerView

        /// Kind of the image source
        var imageKind: ImageKind = .clear
        /// Title of the banner
        var bannerTitle: String = .clear
        /// Title of the button
        var buttonTitle: String = .clear
    }
}
