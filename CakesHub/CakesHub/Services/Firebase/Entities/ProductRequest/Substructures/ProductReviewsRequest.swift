//
//  ProductReviewsRequest.swift
//  CakesHub
//
//  Created by Dmitriy Permyakov on 15.04.2024.
//

import Foundation

extension ProductRequest {
    
    struct ProductReviewsRequest: ClearConfigurationProtocol, DictionaryConvertible {
        var countFiveStars  : Int = 0
        var countFourStars  : Int = 0
        var countThreeStars : Int = 0
        var countTwoStars   : Int = 0
        var countOneStars   : Int = 0
        var countOfComments : Int = 0
        var comments        : [CommentInfoRequest] = []
        
        static let clear = ProductReviewsRequest()
    }
}

// MARK: - DictionaryConvertible

extension ProductRequest.ProductReviewsRequest {

    init?(dictionary: [String: Any]) {
        let comments = dictionary["comments"] as? [[String: Any]] ?? []
        self.init(
            countFiveStars: dictionary["countFiveStars"] as? Int ?? 0,
            countFourStars: dictionary["countFourStars"] as? Int ?? 0,
            countThreeStars: dictionary["countThreeStars"] as? Int ?? 0,
            countTwoStars: dictionary["countTwoStars"] as? Int ?? 0,
            countOneStars: dictionary["countOneStars"] as? Int ?? 0,
            countOfComments: dictionary["countOfComments"] as? Int ?? 0,
            comments: comments.compactMap { .init(dictionary: $0) }
        )
    }
}

// MARK: - Mapper

extension ProductRequest.ProductReviewsRequest {

    var mapper: ProductReviewsModel {
        ProductReviewsModel(
            countFiveStars: countFiveStars,
            countFourStars: countFourStars,
            countThreeStars: countThreeStars,
            countTwoStars: countTwoStars,
            countOneStars: countOneStars,
            countOfComments: countOfComments,
            comments: comments.mapper
        )
    }
}
