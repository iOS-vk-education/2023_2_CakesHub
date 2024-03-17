//
//  UIImage+Additions.swift
//  CakesHub
//
//  Created by Dmitriy Permyakov on 02.03.2024.
//

import UIKit


// MARK: - Local Images

extension UIImage {

    static let category_1 = UIImage(named: "category-1")
    static let category_2 = UIImage(named: "category-2")
    static let category_3 = UIImage(named: "category-3")
}

// MARK: - Preview Images

#if DEBUG
extension UIImage {

    static let mockImageCake  = UIImage(named: "cake")
    static let mockImageCake2 = UIImage(named: "cake2")
    static let mockImageCake3 = UIImage(named: "cake3")
}
#endif
