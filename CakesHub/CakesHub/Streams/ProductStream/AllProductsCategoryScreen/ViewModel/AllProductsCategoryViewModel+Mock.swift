//
//  AllProductsCategoryViewModel+Mock.swift
//  CakesHub
//
//  Created by Dmitriy Permyakov on 31.03.2024.
//  Copyright 2024 © VKxBMSTU Team CakesHub. All rights reserved.
//

import Foundation

#if DEBUG

extension AllProductsCategoryViewModel: Mockable {

    static let mockData = AllProductsCategoryViewModel(
        products: .mockProducts
    )
}

#endif
