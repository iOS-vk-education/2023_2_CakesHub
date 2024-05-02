//
//  FBProductModel+Mock.swift
//  CakesHub
//
//  Created by Dmitriy Permyakov on 02.03.2024.
//  Copyright 2024 © VK Team CakesHub. All rights reserved.
//

import UIKit

#if DEBUG

extension FBProductModel: Mockable {

    static let mockData = FBProductModel(
        documentID: "888",
        images: .strings([]),
        pickers: [],
        productName: "Клубничное облако",
        price: "1400",
        discountedPrice: "1250",
        seller: .king,
        description: "Нежнейший клубничный мусс со сливками, покрыт шоколадным велюром.",
        similarProducts: [], 
        establishmentDate: Date().description,
        reviewInfo: .clear
    )
    static let serverData = FBProductModel(
        documentID: "777",
        images: .url([
            .mockCake1,
            .mockCake2,
            .mockCake3,
        ]),
        pickers: [],
        productName: "Моковый торт из примера ответа сервера",
        price: "300",
        discountedPrice: nil,
        weight: nil,
        seller: .king,
        description: "Просто описание серверного мокового торта",
        similarProducts: [],
        establishmentDate: Date().description,
        reviewInfo: .clear
    )
}

extension [FBProductModel]: Mockable {

    static let mockData: [FBProductModel] = [salesAndNews, allData].flatMap { $0 }
    static let salesAndNews: [FBProductModel] = (1...35).map {
        FBProductModel(
            documentID: String($0),
            images: .url([
                .mockCake1,
                .mockCake2,
                .mockCake3,
            ].shuffled()),
            pickers: [],
            productName: "Моковый торт \($0) из примера ответа сервера",
            price: "\($0)50",
            discountedPrice: $0.isMultiple(of: 2) ? nil : "\($0)10",
            weight: nil,
            seller: .king,
            description: "Просто описание серверного мокового торта \($0)",
            similarProducts: [],
            establishmentDate: $0.isMultiple(of: 4) ? Date().description : "2024-01-\($0)T01:32:01+0000",
            reviewInfo: .mockData
        )
    }
    static let allData: [FBProductModel] = (36...48).map {
        FBProductModel(
            documentID: String($0),
            images: .url([
                .mockCake1,
                .mockCake2,
                .mockCake3,
            ].shuffled()),
            pickers: [],
            productName: "Моковый торт \($0) из примера ответа сервера",
            price: "\($0)50",
            discountedPrice: nil,
            weight: nil,
            seller: .king,
            description: "Просто описание серверного мокового торта \($0)",
            similarProducts: [],
            establishmentDate: "2024-03-\($0)T01:32:01+0000",
            reviewInfo: .mockData
        )
    }
}

// MARK: - FBProductReviewsModel

extension FBProductModel.FBProductReviewsModel: Mockable {

    static let mockData: FBProductModel.FBProductReviewsModel = .init(
        countFiveStars: 12,
        countFourStars: 5,
        countThreeStars: 4,
        countTwoStars: 2,
        countOneStars: 0,
        countOfComments: [FBProductModel.FBCommentInfoModel].mockData.count,
        comments: .mockData
    )
}

// MARK: - FBCommentInfoModel

private extension [FBProductModel.FBCommentInfoModel] {

    static let mockData: [FBProductModel.FBCommentInfoModel] = (0...30).map { mockData($0) }

    static func mockData(_ number: Int) -> FBProductModel.FBCommentInfoModel {
        .init(
            id: String(number),
            userName: "Helene Moore \(number)",
            date: "June 5, 2019",
            description: """
            The dress is great! Very classy and comfortable. It fit perfectly! I'm 5'7" and 130 pounds. I am a 34B chest. This dress would be too long for those who are shorter but could be hemmed. I wouldn't recommend it for those big chested as I am smaller chested and it fit me perfectly. The underarms were not too wide and the dress was made well.
            """,
            countFillStars: number % 6,
            feedbackCount: number
        )
    }
}

#endif
