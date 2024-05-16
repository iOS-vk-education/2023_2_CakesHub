//
//  MKRImageView+Defaults.swift
//  MKRDesignSystem
//
//  Created by Dmitriy Permyakov on 31.12.2023.
//

import Foundation

extension MKRImageView.Configuration {

    static let clear = Self()

    static func basic(
        kind: ImageKind,
        imageShape: ImageShape
    ) -> Self {
        modify(.clear) {
            $0.kind = kind
            $0.imageShape = imageShape
        }
    }

    static func shimmering(imageShape: ImageShape = .rectangle) -> Self {
        modify(.clear) {
            $0.imageShape = imageShape
            $0.isShimmering = true
        }
    }
}
