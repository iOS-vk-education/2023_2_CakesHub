//
//  CategoriesTab.swift
//  CakesHub
//
//  Created by Dmitriy Permyakov on 17.02.2024.
//  Copyright 2024 © VK Team CakesHub. All rights reserved.
//

import Foundation

enum CategoriesTab: String, CaseIterable {
    case women
    case men
    case kids

    var title: LocalizedStringResource {
        switch self {
        case .men:
            return "men"
        case .women:
            return "women"
        case .kids:
            return "kids"
        }
    }
}
