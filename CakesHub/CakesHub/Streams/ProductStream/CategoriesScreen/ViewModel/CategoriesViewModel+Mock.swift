//
//  CategoriesViewModel+Mock.swift
//  CakesHub
//
//  Created by Dmitriy Permyakov on 03.03.2024.
//

import Foundation

#if DEBUG

extension CategoriesViewModel: Mockable {

    static let mockData = CategoriesViewModel(
        sections: [
            .kids(.mockData),
            .men(.mockData2),
            .women(.mockData3)
        ]
    )
}

#endif
