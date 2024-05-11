//
//  ProductModel.swift
//  CakesHub
//
//  Created by Dmitriy Permyakov on 04.02.2024.
//  Copyright 2024 © VK Team CakesHub. All rights reserved.
//

import SwiftUI
import UIKit

struct ProductModel: Identifiable, Hashable {
    let id: String
    /// Картинки товара
    var images: [ProductImage] = []
    /// Бейдж с информацией
    var badgeText: String = .clear
    /// Флаг если товар нравится
    var isFavorite: Bool = false
    /// Флаг если товар новый
    var isNew: Bool = false
    /// Категории торта
    var categories: [String] = []
    /// Информация об продавце
    var seller: SellerInfo = .clear
    /// Название торта
    var productName: String = .clear
    /// Цена торта без скидки
    var price: String = .clear
    /// Цена со скидкой
    var discountedPrice: String?
    /// Описание товара
    var description: String = .clear
    /// Оценки товара
    var reviewInfo: ProductReviewsModel = .clear
    /// Дата создания товара
    var establishmentDate: String = .clear
    /// Схожие товары
    var similarProducts: [ProductModel] = []
}

extension ProductModel {

    struct ProductImage: Identifiable {
        let id = UUID()
        var kind: ImageKind
    }

    struct SellerInfo: Hashable {
        var id: String = .clear
        var name: String = .clear
        var surname: String = .clear
        var mail: String = .clear
        var userImage: ImageKind = .clear
        var userHeaderImage: ImageKind = .clear
        var phone: String?

        static let clear = SellerInfo()
    }

    var starsCount: Int {
        Int(reviewInfo.averageRating.rounded())
    }
}

// MARK: - Mapper

extension ProductModel {

    func mapperToProductCardConfiguration(
        height: CGFloat,
        badgeConfiguration: CHMBadgeView.Configuration
    ) -> CHMNewProductCard.Configuration {
        .basic(
            imageKind: images.first?.kind ?? .clear,
            imageHeight: height,
            productText: .init(
                seller: seller.name,
                productName: productName,
                productPrice: price,
                productDiscountedPrice: discountedPrice
            ),
            badgeViewConfiguration: badgeConfiguration,
            productButtonConfiguration: .basic(
                kind: .favorite(isSelected: isFavorite)
            ),
            starsViewConfiguration: .basic(
                kind: .init(rawValue: starsCount) ?? .zero,
                feedbackCount: reviewInfo.feedbackCounter
            )
        )
    }

    func mapperToProductCardConfiguration(
        height: CGFloat
    ) -> CHMNewProductCard.Configuration {
        .basic(
            imageKind: images.first?.kind ?? .clear,
            imageHeight: height,
            productText: .init(
                seller: seller.name,
                productName: productName,
                productPrice: price,
                productDiscountedPrice: discountedPrice
            ),
            badgeViewConfiguration: calculatedBadgeConfiguration,
            productButtonConfiguration: .basic(
                kind: .favorite(isSelected: isFavorite)
            ),
            starsViewConfiguration: .basic(
                kind: .init(rawValue: starsCount) ?? .zero,
                feedbackCount: reviewInfo.feedbackCounter
            )
        )
    }

    private var calculatedBadgeConfiguration: CHMBadgeView.Configuration {
        if !discountedPrice.isNil {
            return .basic(text: badgeText, kind: .red)
        } else if isNew {
            return .basic(text: badgeText, kind: .dark)
        }
        return .clear
    }
}

#if DEBUG
extension ProductModel {

    /// Маппер для заполнения БД
    var mapper: FBProductModel {
        var productImages: FBProductModel.FBImageKind {
            guard let kind = images.first?.kind else { return .clear }
            switch kind {
            case .url:
                return .url(images.compactMap {
                    switch $0.kind {
                    case let .url(url):
                        return url
                    default:
                        return nil
                    }
                })
            case .uiImage:
                return .images(images.compactMap {
                    switch $0.kind {
                    case let .uiImage(uiImage):
                        return uiImage
                    default:
                        return nil
                    }
                })
            case .string:
                return .strings(images.compactMap {
                    switch $0.kind {
                    case let .string(string):
                        return string
                    default:
                        return nil
                    }
                })
            case .clear:
                return .clear
            }
        }

        var sellerImage: String? {
            switch seller.userImage {
            case .url(let url):
                return url?.absoluteString
            default:
                return nil
            }
        }

        var sellerHeaderImage: String? {
            switch seller.userHeaderImage {
            case .url(let url):
                return url?.absoluteString
            default:
                return nil
            }
        }

        let sellerInfo = FBUserModel(
            uid: seller.id,
            nickname: seller.name,
            email: seller.mail,
            avatarImage: sellerImage,
            headerImage: sellerHeaderImage,
            phone: seller.phone
        )

        return FBProductModel(
            documentID: id,
            images: productImages,
            categories: categories,
            productName: productName,
            price: price,
            discountedPrice: discountedPrice,
            weight: nil,
            seller: sellerInfo,
            description: description,
            similarProducts: [],
            establishmentDate: Date().description,
            reviewInfo: .init(
                countFiveStars: reviewInfo.countFiveStars,
                countFourStars: reviewInfo.countFourStars,
                countThreeStars: reviewInfo.countThreeStars,
                countTwoStars: reviewInfo.countTwoStars,
                countOneStars: reviewInfo.countOneStars,
                countOfComments: reviewInfo.countOfComments,
                comments: reviewInfo.comments.map {
                    .init(
                        id: $0.id,
                        userName: $0.userName,
                        date: $0.date,
                        description: $0.description,
                        countFillStars: $0.countFillStars
                    )
                },
                feedbackCount: reviewInfo.feedbackCount
            )
        )
    }
}
#endif

extension ProductModel.SellerInfo {

    func mapper(products: [ProductModel]) -> UserModel {
        .init(
            id: id,
            name: name,
            surname: surname,
            mail: mail,
            orders: products.count,
            userImage: userImage,
            userHeaderImage: userHeaderImage,
            products: products
        )
    }
}

// MARK: - Hasher

extension ProductModel {

    static func == (lhs: ProductModel, rhs: ProductModel) -> Bool {
        lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
