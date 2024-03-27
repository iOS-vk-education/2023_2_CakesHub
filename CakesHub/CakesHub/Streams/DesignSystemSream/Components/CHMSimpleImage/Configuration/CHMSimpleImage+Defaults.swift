//
//  CHMSimpleImage+Defaults.swift
//  CHMUIKIT
//
//  Created by Dmitriy Permyakov on 27.03.2024.
//  Copyright 2024 © VK Team CakesHub. All rights reserved.
//

import SwiftUI

extension CHMSimpleImage.Configuration {

    /// Basic configuration
    static let clear = CHMSimpleImage.Configuration()

    /// Basic configuration
    /// - Parameters:
    ///   - imageKind: image kind
    /// - Returns: configuration of the view
    static func basic(
        imageKind: ImageKind,
        contentMode: ContentMode = .fill
    ) -> CHMSimpleImage.Configuration {
        modify(.clear) {
            $0.imageKind = imageKind
            $0.contentMode = contentMode
        }
    }
}
