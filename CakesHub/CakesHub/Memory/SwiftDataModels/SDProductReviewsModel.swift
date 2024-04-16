//
//  SDProductReviewsModel.swift
//  CakesHub
//
//  Created by Dmitriy Permyakov on 14.04.2024.
//

import Foundation
import SwiftData

@Model
final class SDProductReviewsModel {
    var _countFiveStars  : Int
    var _countFourStars  : Int
    var _countThreeStars : Int
    var _countTwoStars   : Int
    var _countOneStars   : Int
    var _countOfComments : Int
    var _comments        : [SDCommentInfo]

    init(
        countFiveStars: Int,
        countFourStars: Int,
        countThreeStars: Int,
        countTwoStars: Int,
        countOneStars: Int,
        countOfComments: Int,
        comments: [SDCommentInfo]
    ) {
        self._countFiveStars = countFiveStars
        self._countFourStars = countFourStars
        self._countThreeStars = countThreeStars
        self._countTwoStars = countTwoStars
        self._countOneStars = countOneStars
        self._countOfComments = countOfComments
        self._comments = comments
    }
}

// MARK: - Init

extension SDProductReviewsModel {

    convenience init(reviews: ProductReviewsModel) {
        self.init(
            countFiveStars: reviews.countFiveStars,
            countFourStars: reviews.countFourStars,
            countThreeStars: reviews.countThreeStars,
            countTwoStars: reviews.countTwoStars,
            countOneStars: reviews.countOneStars,
            countOfComments: reviews.countOfComments,
            comments: reviews.comments.map { .init(comment: $0) }
        )
    }
}
