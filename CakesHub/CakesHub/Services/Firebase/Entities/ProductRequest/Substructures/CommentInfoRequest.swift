//
//  CommentInfoRequest.swift
//  CakesHub
//
//  Created by Dmitriy Permyakov on 15.04.2024.
//

import Foundation

extension ProductRequest {
    
    struct CommentInfoRequest: ClearConfigurationProtocol, DictionaryConvertible {
        var userName       : String = .clear
        var date           : String = .clear
        var description    : String = .clear
        var countFillStars : Int = 0
        var feedbackCount  : Int = 0
        
        static let clear = CommentInfoRequest()
    }
}

// MARK: - DictionaryConvertible

extension ProductRequest.CommentInfoRequest {

    init?(dictionary: [String: Any]) {
        self.init(
            userName: dictionary["userName"] as? String ?? .clear,
            date: dictionary["date"] as? String ?? .clear,
            description: dictionary["description"] as? String ?? .clear,
            countFillStars: dictionary["countFillStars"] as? Int ?? 0,
            feedbackCount: dictionary["feedbackCount"] as? Int ?? 0
        )
    }
}

// MARK: - Mapper

extension ProductRequest.CommentInfoRequest {

    var mapper: ProductReviewsModel.CommentInfo {
        .init(
            userName: userName,
            date: date,
            description: description,
            countFillStars: countFillStars,
            feedbackCount: feedbackCount
        )
    }
}

extension [ProductRequest.CommentInfoRequest] {

    var mapper: [ProductReviewsModel.CommentInfo] {
        map { $0.mapper }
    }
}
