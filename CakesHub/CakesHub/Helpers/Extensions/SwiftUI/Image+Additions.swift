//
//  Image+Additions.swift
//  CHMUIKIT
//
//  Created by Dmitriy Permyakov on 02/12/2023.
//

import SwiftUI

// MARK: - Icons

struct CHMImage {
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

    static let category_1      = UIImage(named: "category-1")
    static let category_2      = UIImage(named: "category-2")
    static let category_3      = UIImage(named: "category-3")
}

#if DEBUG

// MARK: - Preview Images

extension CHMImage {

    static let mockImageCake  = UIImage(named: "cake")
    static let mockImageCake2 = UIImage(named: "cake2")
    static let mockImageCake3 = UIImage(named: "cake3")
}
#endif
