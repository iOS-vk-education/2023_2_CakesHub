//
//  SDCommentInfo.swift
//  CakesHub
//
//  Created by Dmitriy Permyakov on 16.04.2024.
//

import SwiftData

extension SDProductReviewsModel {

    @Model
    final class SDCommentInfoModel {
        let _id                 : String
        var _userName           : String
        var _date               : String
        var _descriptionComment : String
        var _countFillStars     : Int
        var _feedbackCount      : Int

        init(
            id             : String,
            userName       : String,
            date           : String,
            description    : String,
            countFillStars : Int,
            feedbackCount  : Int
        ) {
            self._id = id
            self._userName = userName
            self._date = date
            self._descriptionComment = description
            self._countFillStars = countFillStars
            self._feedbackCount = feedbackCount
        }
    }
}

// MARK: - Init

extension SDProductReviewsModel.SDCommentInfoModel: SDModelable {
    typealias FBModelType = FBProductModel.FBCommentInfoModel

    convenience init(fbModel: FBProductModel.FBCommentInfoModel) {
        self.init(
            id: fbModel.id,
            userName: fbModel.userName,
            date: fbModel.date,
            description: fbModel.description,
            countFillStars: fbModel.countFillStars,
            feedbackCount: fbModel.feedbackCount
        )
    }
}

// MARK: - Mapper

extension SDProductReviewsModel.SDCommentInfoModel {

    var mapperInFBCommentInfo: FBProductModel.FBCommentInfoModel {
        .init(
            id: _id,
            userName: _userName,
            date: _date,
            description: _descriptionComment,
            countFillStars: _countFillStars,
            feedbackCount: _feedbackCount
        )
    }
}
