//
//  SDCommentInfo.swift
//  CakesHub
//
//  Created by Dmitriy Permyakov on 16.04.2024.
//

import SwiftData

extension SDProductReviewsModel {

    @Model
    final class SDCommentInfo {
        let _id                 : String
        var _userName           : String
        var _date               : String
        var _descriptionComment : String
        var _countFillStars     : Int
        var _feedbackCount      : Int

        init(
            id: String,
            userName: String,
            date: String,
            description: String,
            countFillStars: Int,
            feedbackCount: Int
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

extension SDProductReviewsModel.SDCommentInfo {

    convenience init(comment: ProductReviewsModel.CommentInfo) {
        self.init(
            id: comment.id,
            userName: comment.userName,
            date: comment.date,
            description: comment.description,
            countFillStars: comment.countFillStars,
            feedbackCount: comment.feedbackCount
        )
    }
}
