//
//  SDProductModel.swift
//  CakesHub
//
//  Created by Dmitriy Permyakov on 14.04.2024.
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

    convenience init(product: ProductModel) {
        var images: [String] {
            product.images.compactMap { image in
                switch image.kind {
                case let .url(url):
                    return url?.absoluteString
                default:
                    return nil
                }
            }
        }

        self.init(
            id: product.id,
            images: images,
            pickers: product.pickers,
            productName: product.productName,
            price: product.price,
            discountedPrice: product.discountedPrice,
            weight: nil,
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

    var mapperInProductModel: ProductModel {
        var productImages: [ProductModel.ProductImage] {
            _images.map { .init(kind: .url(URL(string: $0))) }
        }

        // Проставляем `badgeText` в зависимости от данных по продукту
        let badgeText: String
        if let salePrice = Int(_discountedPrice ?? .clear), let oldPrice = Int(_price) {
            let floatOldePrice = CGFloat(oldPrice)
            let floatSalePrice = CGFloat(salePrice)
            let sale = (floatOldePrice - floatSalePrice) / floatOldePrice * 100
            badgeText = "-\(Int(sale.rounded(toPlaces: 0)))%"
        } else {
            badgeText = "NEW"
        }

        var seller: ProductModel.SellerInfo {
            .init(
                id: _seller._uid,
                name: _seller._nickName,
                surname: .clear,
                mail: _seller._email,
                userImage: .url(URL(string: _seller._userImageURL ?? .clear)),
                userHeaderImage: .url(URL(string: _seller._userHeaderImageURL ?? .clear)),
                phone: _seller._phone
            )
        }

        var reviewInfo: ProductReviewsModel {
            ProductReviewsModel(
                countFiveStars: _reviewInfo._countFourStars,
                countFourStars: _reviewInfo._countFourStars,
                countThreeStars: _reviewInfo._countThreeStars,
                countTwoStars: _reviewInfo._countTwoStars,
                countOneStars: _reviewInfo._countOneStars,
                countOfComments: _reviewInfo._countOfComments
//                comments: _reviewInfo._comments.map { review in
//                    ProductReviewsModel.CommentInfo(
//                        userName: review._userName,
//                        date: review._date,
//                        description: review._descriptionComment,
//                        countFillStars: review._countFillStars,
//                        feedbackCount: review._feedbackCount
//                    )
//                }
            )
        }

        return ProductModel(
            id: _id,
            images: productImages,
            badgeText: badgeText,
            isFavorite: false,
            isNew: _discountedPrice.isNil,
            pickers: _pickers,
            seller: seller,
            productName: _productName,
            price: _price,
            discountedPrice: _discountedPrice,
            description: _descriptionInfo,
            reviewInfo: reviewInfo,
            establishmentDate: _establishmentDate,
            similarProducts: _similarProducts.map { $0.mapperInProductModel }
        )
    }
}
