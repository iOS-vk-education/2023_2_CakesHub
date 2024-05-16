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
        var contentMode: ContentMode = .fill
        var isShimmering: Bool = false
    }
}

// MARK: - Image Kind

enum ImageKind: Hashable {
    case url(URL?)
    case uiImage(UIImage?)
    case string(String)
    case clear
}

extension ImageKind {

    var isClear: Bool {
        switch self {
        case let .url(url):
            return url.isNil
        case let .uiImage(uiImage):
            return uiImage.isNil
        case let .string(string):
            return string.isEmpty
        case .clear:
            return true
        }
    }
}

// MARK: - Image Shape

extension MKRImageView.Configuration {

    enum ImageShape: Hashable {
        case capsule
        case rectangle
        case roundedRectangle(CGFloat)
    }
}
