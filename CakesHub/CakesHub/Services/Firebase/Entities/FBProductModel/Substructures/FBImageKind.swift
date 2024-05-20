//
//  ImageKindRequest.swift
//  CakesHub
//
//  Created by Dmitriy Permyakov on 15.04.2024.
//  Copyright 2024 © VK Team CakesHub. All rights reserved.
//

import UIKit

extension FBProductModel {

    enum FBImageKind {
        case url([URL?])
        case images([UIImage?])
        case strings([String])
        case clear
    }
}

// MARK: - DictionaryConvertible

extension FBProductModel.FBImageKind: DictionaryConvertible {

    init?(dictionary: [String: Any]) {
        guard let strings = dictionary["strings"] as? [String] else {
            return nil
        }
        let urls = strings.compactMap { URL(string: $0) }
        self = .url(urls)
    }
}

// MARK: - Equatable

extension FBProductModel.FBImageKind: Equatable {

    static func == (lhs: FBProductModel.FBImageKind, rhs: FBProductModel.FBImageKind) -> Bool {
        switch (lhs, rhs) {
        case (.url(let urls1), .url(let urls2)):
            return urls1 == urls2
        case (.images(let images1), .images(let images2)):
            return images1 == images2
        case (.strings(let strings1), .strings(let strings2)):
            return strings1 == strings2
        case (.url(let urls), .strings(let strings)):
            return urls.compactMap { $0?.absoluteString } == strings
        case (.strings(let strings), .url(let urls)):
            return urls.compactMap { $0?.absoluteString } == strings
        case (.clear, .clear):
            return true
        default:
            return false
        }
    }
}
