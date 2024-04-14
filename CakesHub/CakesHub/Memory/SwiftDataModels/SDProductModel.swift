//
//  SDProductModel.swift
//  CakesHub
//
//  Created by Dmitriy Permyakov on 14.04.2024.
//

import SwiftData

@Model
final class SDProductModel {
    let id                 : String
    var images             : [String]
    var badgeText          : String
    var isFavorite         : Bool
    var isNew              : Bool
    var pickers            : [String]
    var seller             : SDUserModel
    var productName        : String
    var price              : String
    var discountedPrice    : String?
    var productDescription : String
    var reviewInfo         : SDProductReviewsModel
    var establishmentDate  : String
    var similarProducts    : [SDProductModel]

    init(
        id: String,
        images: [String],
        badgeText: String,
        isFavorite: Bool,
        isNew: Bool,
        pickers: [String],
        seller: SDUserModel,
        productName: String,
        price: String,
        discountedPrice: String? = nil,
        description: String,
        reviewInfo: SDProductReviewsModel,
        establishmentDate: String,
        similarProducts: [SDProductModel]
    ) {
        self.id = id
        self.images = images
        self.badgeText = badgeText
        self.isFavorite = isFavorite
        self.isNew = isNew
        self.seller = seller
        self.pickers = pickers
        self.productName = productName
        self.price = price
        self.discountedPrice = discountedPrice
        self.productDescription = description
        self.reviewInfo = reviewInfo
        self.establishmentDate = establishmentDate
        self.similarProducts = similarProducts
    }
}
