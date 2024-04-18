//
//  SDProductModel.swift
//  CakesHub
//
//  Created by Dmitriy Permyakov on 14.04.2024.
//  Copyright 2024 © VK Team CakesHub. All rights reserved.
//

import Foundation
import SwiftData

@Model
final class SDProductModel {
    var _id                : String
    var _images            : [String]
    var _pickers           : [String]
    var _productName       : String
    var _price             : String
    var _discountedPrice   : String?
    var _weight            : String?
    var _seller            : SDUserModel
    var _descriptionInfo   : String
    var _similarProducts   : [SDProductModel]
    var _establishmentDate : String
    var _reviewInfo        : SDProductReviewsModel

    init(
        id: String,
        images: [String],
        pickers: [String],
        productName: String,
        price: String,
        discountedPrice: String? = nil,
        weight: String? = nil,
        seller: SDUserModel,
        description: String,
        similarProducts: [SDProductModel],
        establishmentDate: String,
        reviewInfo: SDProductReviewsModel
    ) {
        self._id = id
        self._images = images
        self._pickers = pickers
        self._productName = productName
        self._price = price
        self._discountedPrice = discountedPrice
        self._weight = weight
        self._seller = seller
        self._descriptionInfo = description
        self._establishmentDate = establishmentDate
        self._reviewInfo = reviewInfo
        self._similarProducts = similarProducts
    }
}

// MARK: - Init

extension SDProductModel {

    convenience init(product: FBProductModel) {
        var images: [String] {
            switch product.images {
            case let .strings(strings):
                return strings
            case let .url(urls):
                return urls.compactMap { $0?.absoluteString }
            default:
                return []
            }
        }

        self.init(
            id: product.documentID,
            images: images,
            pickers: product.pickers,
            productName: product.productName,
            price: product.price,
            discountedPrice: product.discountedPrice,
            weight: product.weight,
            seller: SDUserModel(user: product.seller),
            description: product.description,
            similarProducts: product.similarProducts.map { SDProductModel(product: $0) },
            establishmentDate: product.establishmentDate,
            reviewInfo: SDProductReviewsModel(reviews: product.reviewInfo)
        )
    }
}

// MARK: - Mapper

extension SDProductModel {

    var mapperInFBProductModel: FBProductModel {
        return FBProductModel(
            documentID: _id,
            images: .strings(_images),
            pickers: _pickers,
            productName: _productName,
            price: _price,
            discountedPrice: _discountedPrice,
            weight: _weight,
            seller: _seller.mapperInFBUserModel,
            description: _descriptionInfo,
            similarProducts: _similarProducts.map { $0.mapperInFBProductModel },
            establishmentDate: _establishmentDate,
            reviewInfo: _reviewInfo.mapperInFBProductReviews
        )
    }
}
