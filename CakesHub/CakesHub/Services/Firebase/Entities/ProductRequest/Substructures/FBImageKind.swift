//
//  ImageKindRequest.swift
//  CakesHub
//
//  Created by Dmitriy Permyakov on 15.04.2024.
//  Copyright 2024 © VK Team CakesHub. All rights reserved.
//

import UIKit

extension FBProductModel {

    enum FBImageKind: DictionaryConvertible {
        case url([URL?])
        case images([UIImage?])
        case strings([String])
        case clear
    }
}

// MARK: - DictionaryConvertible

extension FBProductModel.FBImageKind {

    init?(dictionary: [String: Any]) {
        guard let strings = dictionary["strings"] as? [String] else {
            return nil
        }
        let urls = strings.compactMap { URL(string: $0) }
        self = .url(urls)
    }
}
