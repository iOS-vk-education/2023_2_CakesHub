//
//  ProductRequest.swift
//  CakesHub
//
//  Created by Dmitriy Permyakov on 02.03.2024.
//  Copyright 2024 © VK Team CakesHub. All rights reserved.
//

import SwiftUI

struct ProductRequest: DictionaryConvertible, ClearConfigurationProtocol {
    /// ID firebase документа
    var documentID: String = .clear
    /// Картинки товара
    var images: ImageKindRequest = .clear
    /// Бейдж с информацией
    var badgeText: String = .clear
    /// Фильтры торта
    var pickers: [String] = []
    /// Название торта
    var productName: String = .clear
    /// Цена торта
    var price: String = .clear
    /// Цена торта со скидкой
    var discountedPrice: String?
    /// Вес торта
    var weight: String?
    /// Имя продовца
    var seller: UserRequest = .clear
    /// Описание товара
    var description: String = .clear
    /// Схожие товары
    var similarProducts: [String] = []
    /// Оценки товара
    var reviewInfo: ProductReviewsRequest = .clear

    static let clear = ProductRequest()
}

// MARK: - ProductRequest Substructures

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

    struct CommentInfoRequest: ClearConfigurationProtocol, DictionaryConvertible {
        var userName       : String = .clear
        var date           : String = .clear
        var description    : String = .clear
        var countFillStars : Int = 0
        var feedbackCount  : Int = 0

        static let clear = CommentInfoRequest()
    }

    enum ImageKindRequest: DictionaryConvertible {
        case url([URL?])
        case images([UIImage?])
        case strings([String])
        case clear
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

extension ProductRequest.ImageKindRequest {

    init?(dictionary: [String: Any]) {
        guard let strings = dictionary["strings"] as? [String] else {
            return nil
        }
        let urls = strings.compactMap { URL(string: $0) }
        self = .url(urls)
    }
}

extension ProductRequest {

    init?(dictionary: [String: Any]) {
        var images: ProductRequest.ImageKindRequest?
        if let imagesDictionary = dictionary["images"] as? [String: Any] {
            images = ProductRequest.ImageKindRequest(dictionary: imagesDictionary)
        }
        let badgeText = dictionary["badgeText"] as? String ?? .clear
        let pickers = dictionary["pickers"] as? [String] ?? []
        let productName = dictionary["productName"] as? String ?? .clear
        let price = dictionary["price"] as? String ?? .clear
        let discountedPrice = dictionary["discountedPrice"] as? String
        let weight = dictionary["weight"] as? String
        var user: UserRequest?
        if let sellerDict = dictionary["seller"] as? [String: Any] {
            user = UserRequest(dictionary: sellerDict)
        }
        let description = dictionary["description"] as? String ?? .clear
        let similarProducts = dictionary["similarProducts"] as? [String] ?? []
        var reviewInfo: ProductReviewsRequest?
        if let reviewInfoDict = dictionary["reviewInfo"] as? [String: Any] {
            reviewInfo = ProductReviewsRequest(dictionary: reviewInfoDict)
        }

        self.init(
            images: images ?? .clear,
            badgeText: badgeText,
            pickers: pickers,
            productName: productName,
            price: price,
            discountedPrice: discountedPrice,
            weight: weight,
            seller: user ?? .clear,
            description: description,
            similarProducts: similarProducts,
            reviewInfo: reviewInfo ?? .clear
        )
    }
}
