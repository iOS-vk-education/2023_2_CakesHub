//
//  ProductDetailCells.swift
//  CakesHub
//
//  Created by Dmitriy Permyakov on 19.03.2024.
//  Copyright 2024 © VK Team CakesHub. All rights reserved.
//

import Foundation

enum ProductDetailCells: String {
    case ratingReviews
    case sellerInfo

    var title: LocalizedStringResource {
        switch self {
        case .ratingReviews:
            return "Rating&Reviews"
        case .sellerInfo:
            return "Seller info"
        }
    }
}
