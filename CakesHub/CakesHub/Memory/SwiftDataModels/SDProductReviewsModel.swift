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
    var countFiveStars  : Int
    var countFourStars  : Int
    var countThreeStars : Int
    var countTwoStars   : Int
    var countOneStars   : Int
    var countOfComments : Int
    var comments        : [CommentInfo]

    init(
        countFiveStars: Int,
        countFourStars: Int,
        countThreeStars: Int,
        countTwoStars: Int,
        countOneStars: Int,
        countOfComments: Int,
        comments: [CommentInfo]
    ) {
        self.countFiveStars = countFiveStars
        self.countFourStars = countFourStars
        self.countThreeStars = countThreeStars
        self.countTwoStars = countTwoStars
        self.countOneStars = countOneStars
        self.countOfComments = countOfComments
        self.comments = comments
    }
}

// MARK: - CommentInfo

extension SDProductReviewsModel {

    @Model
    final class CommentInfo {
        let id                 : String
        var userName           : String
        var date               : String
        var descriptionComment : String
        var countFillStars     : Int
        var feedbackCount      : Int

        init(
            id: String,
            userName: String,
            date: String,
            description: String,
            countFillStars: Int,
            feedbackCount: Int
        ) {
            self.id = id
            self.userName = userName
            self.date = date
            self.descriptionComment = description
            self.countFillStars = countFillStars
            self.feedbackCount = feedbackCount
        }
    }
}
