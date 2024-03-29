//
//  MKRImageView+Configuration.swift
//  MKRDesignSystem
//
//  Created by Dmitriy Permyakov on 31.12.2023.
//

import SwiftUI

extension MKRImageView {

    struct Configuration {
        var kind: ImageKind = .clear
        var imageShape: ImageShape = .capsule
        var imageSize: CGSize = .zero
        var contentMode: ContentMode = .fill
        var isShimmering: Bool = false
    }
}

// MARK: - Image Kind

enum ImageKind: Hashable {
    case url(URL?)
    case uiImage(UIImage?)
    case clear
}

// MARK: - Image Shape

extension MKRImageView.Configuration {

    enum ImageShape: Hashable {
        case capsule
        case rectangle
        case roundedRectangle(CGFloat)
    }
}
