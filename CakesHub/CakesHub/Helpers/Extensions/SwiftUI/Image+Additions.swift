//
//  Image+Additions.swift
//  CHMUIKIT
//
//  Created by Dmitriy Permyakov on 02/12/2023.
//

import SwiftUI

// MARK: - Icons

extension Image {

    static let basketIcon      = Image("basketIcon")
    static let chevronDown     = Image("chevron-down")
    static let chevronLeft     = Image("chevron-left")
    static let chevronRight    = Image("chevron-right")
    static let magnifier       = Image("magnifier")
    static let starFill        = Image("StarFill")
    static let starOutline     = Image("StarOutline")
    static let favoriteBorder  = Image("favorite_border")
    static let favoritePressed = Image("favorite_pressed")
    static let bell            = Image("bell")
    static let plusSign        = Image("plusSign")
}

// MARK: - Local Images

extension Image {

    static let category_1 = Image("category-1")
    static let category_2 = Image("category-2")
    static let category_3 = Image("category-3")
}

// MARK: - Preview Images

#if DEBUG
extension Image {

    static let mockImageCake  = Image("cake")
    static let mockImageCake2 = Image("cake2")
    static let mockImageCake3 = Image("cake3")
}
#endif
