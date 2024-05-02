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
    @Attribute(.unique)
    var _id                : String
    var _imageKeys         : [String]
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
        self._imageKeys = images
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

extension SDProductModel: SDModelable {
    typealias FBModelType = FBProductModel

    convenience init(fbModel: FBProductModel) {
        var images: [String] {
            switch fbModel.images {
            case let .strings(strings):
                return strings
            case let .url(urls):
                return urls.compactMap { $0?.absoluteString }
            default:
                return []
            }
        }

        self.init(
            id: fbModel.documentID,
            images: images,
            pickers: fbModel.pickers,
            productName: fbModel.productName,
            price: fbModel.price,
            discountedPrice: fbModel.discountedPrice,
            weight: fbModel.weight,
            seller: SDUserModel(fbModel: fbModel.seller),
            description: fbModel.description,
            similarProducts: fbModel.similarProducts.map { SDProductModel(fbModel: $0) },
            establishmentDate: fbModel.establishmentDate,
            reviewInfo: SDProductReviewsModel(fbModel: fbModel.reviewInfo)
        )
    }
}

// MARK: - Mapper

extension SDProductModel {

    var mapperInFBProductModel: FBProductModel {
        FBProductModel(
            documentID: _id,
            images: .strings(_imageKeys),
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
