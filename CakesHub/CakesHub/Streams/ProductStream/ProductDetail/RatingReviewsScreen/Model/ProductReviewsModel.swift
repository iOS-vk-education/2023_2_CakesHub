//
//  ProductReviewsModel.swift
//  CakesHub
//
//  Created by Dmitriy Permyakov on 04.02.2024.
//  Copyright 2024 © VK Team CakesHub. All rights reserved.
//

import Foundation

struct ProductReviewsModel {
    static let clear = ProductReviewsModel()

    var countFiveStars  : Int = 0
    var countFourStars  : Int = 0
    var countThreeStars : Int = 0
    var countTwoStars   : Int = 0
    var countOneStars   : Int = 0
    var countOfComments : Int = 0
    var comments        : [CommentInfo] = []
    var feedbackCount   : Int = 0

    struct CommentInfo: Identifiable {
        var id             : String = .clear
        var userName       : String = .clear
        var date           : String = .clear
        var description    : String = .clear
        var countFillStars : Int = 0
    }
}

// MARK: Calculation values

extension ProductReviewsModel {

    var fiveStarsConfiguration: CHMRatingReviewsView.Configuration.RatingData {
        calculateRatingConfiguration(countFiveStars)
    }
    var fourStarsConfiguration: CHMRatingReviewsView.Configuration.RatingData {
        calculateRatingConfiguration(countFourStars)
    }
    var threeStarsConfiguration: CHMRatingReviewsView.Configuration.RatingData { 
        calculateRatingConfiguration(countThreeStars)
    }
    var twoStarsConfiguration: CHMRatingReviewsView.Configuration.RatingData {
        calculateRatingConfiguration(countTwoStars)
    }
    var oneStarsConfiguration: CHMRatingReviewsView.Configuration.RatingData {
        calculateRatingConfiguration(countOneStars)
    }
    var feedbackAmountOfPoints: Int {
        countFiveStars * 5 + countFourStars * 4 + countThreeStars * 3 + countTwoStars * 2 + countOneStars
    }
    var averageRatingString: String {
        return "\(averageRating.rounded(toPlaces: 1))"
    }
    var averageRating: CGFloat {
        CGFloat(feedbackAmountOfPoints) / CGFloat(feedbackCount)
    }
}

// MARK: - Inner logic

private extension ProductReviewsModel {

    func calculateRatingConfiguration(_ count: Int) -> CHMRatingReviewsView.Configuration.RatingData {
        let perсentArea = CGFloat(count) / CGFloat(feedbackCount)
        let ration = CHMRatingReviewsView.Configuration.Kind(rawValue: perсentArea.rounded(toPlaces: 1)) ?? .zero
        let configuration = CHMRatingReviewsView.Configuration.RatingData.basic(ration: ration, count: count)
        return configuration
    }
}

// MARK: - Mapper

extension FBProductModel.FBCommentInfoModel {

    var mapper: ProductReviewsModel.CommentInfo {
        .init(
            id: id,
            userName: userName,
            date: date.toCorrectDate,
            description: description,
            countFillStars: countFillStars
        )
    }
}

extension [FBProductModel.FBCommentInfoModel] {

    var mapper: [ProductReviewsModel.CommentInfo] {
        map { $0.mapper }
    }
}
