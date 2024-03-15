//
//  CategoriesViewModel+Mock.swift
//  CakesHub
//
//  Created by Dmitriy Permyakov on 03.03.2024.
//

import Foundation

#if DEBUG

extension CategoriesViewModel: Mockable {

    static let mockData = CategoriesViewModel(firstSections: .mockData, secondSections: .mockData2)
}

#endif
