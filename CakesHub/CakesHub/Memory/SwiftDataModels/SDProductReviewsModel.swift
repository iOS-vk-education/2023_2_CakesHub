//
//  SDProductReviewsModel.swift
//  CakesHub
//
//  Created by Dmitriy Permyakov on 14.04.2024.
//  Copyright 2024 © VK Team CakesHub. All rights reserved.
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
    var _comments        : [SDCommentInfoModel]
    var _feedbackCount   : Int

    init(
        countFiveStars  : Int,
        countFourStars  : Int,
        countThreeStars : Int,
        countTwoStars   : Int,
        countOneStars   : Int,
        countOfComments : Int,
        comments        : [SDCommentInfoModel],
        feedbackCount   : Int
    ) {
        self._countFiveStars = countFiveStars
        self._countFourStars = countFourStars
        self._countThreeStars = countThreeStars
        self._countTwoStars = countTwoStars
        self._countOneStars = countOneStars
        self._countOfComments = countOfComments
        self._comments = comments
        self._feedbackCount = feedbackCount
    }
}

// MARK: - Init

extension SDProductReviewsModel: SDModelable {
    typealias FBModelType = FBProductModel.FBProductReviewsModel

    convenience init(fbModel: FBModelType) {
        self.init(
            countFiveStars: fbModel.countFiveStars,
            countFourStars: fbModel.countFourStars,
            countThreeStars: fbModel.countThreeStars,
            countTwoStars: fbModel.countTwoStars,
            countOneStars: fbModel.countOneStars,
            countOfComments: fbModel.countOfComments,
            comments: fbModel.comments.map { .init(fbModel: $0) },
            feedbackCount: fbModel.feedbackCount
        )
    }
}

// MARK: - Mapper

extension SDProductReviewsModel {

    var mapper: FBProductModel.FBProductReviewsModel {
        .init(
            countFiveStars: _countFiveStars,
            countFourStars: _countFourStars,
            countThreeStars: _countThreeStars,
            countTwoStars: _countTwoStars,
            countOneStars: _countOneStars,
            countOfComments: _countOfComments,
            comments: _comments.map { $0.mapper },
            feedbackCount: _feedbackCount
        )
    }
}
