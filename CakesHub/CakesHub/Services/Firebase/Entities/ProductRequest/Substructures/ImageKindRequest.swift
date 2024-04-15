//
//  ImageKindRequest.swift
//  CakesHub
//
//  Created by Dmitriy Permyakov on 15.04.2024.
//

import UIKit

extension ProductRequest {

    enum ImageKindRequest: DictionaryConvertible {
        case url([URL?])
        case images([UIImage?])
        case strings([String])
        case clear
    }
}

// MARK: - DictionaryConvertible

extension ProductRequest.ImageKindRequest {

    init?(dictionary: [String: Any]) {
        guard let strings = dictionary["strings"] as? [String] else {
            return nil
        }
        let urls = strings.compactMap { URL(string: $0) }
        self = .url(urls)
    }
}
