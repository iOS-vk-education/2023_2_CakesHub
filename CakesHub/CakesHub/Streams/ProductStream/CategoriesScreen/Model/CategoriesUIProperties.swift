//
//  CategoriesUIProperties.swift
//  CakesHub
//
//  Created by Dmitriy Permyakov on 07.05.2024.
//

import Foundation

extension CategoriesViewModel {

    struct CategoriesUIProperties: ClearConfigurationProtocol {
        var selectedTab: CategoriesTab?
        var tabBarProgess: CGFloat = .zero
        var showSearchBar: Bool = false
        var searchText: String = .clear

        static let clear = CategoriesUIProperties()
    }
}
